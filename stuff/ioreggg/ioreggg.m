//usr/bin/clang -fmodules -fobjc-arc -g -o /tmp/ioreggg.a "$0" && exec /tmp/ioreggg.a "$@"

/**
 ioreg alternative
     Benefits:
         - Filter using standard IOKit matchDict instead of cryptic ioreg options
         - Default to printing the entire registry
         - Show paths
         - Nested dicts and arrays in a registry entry's properties aren't forced onto one line.
     Usage examples:
        ```
        // 1. Finds the first IOService of class `IOMobileFramebuffer` for the first external display (dispext0) using a matchDict written as an old-style plist. (XML plist or JSON5 also works)
        ./ioreggg.m 'IOProviderClass = IOMobileFramebuffer; IOParentMatch = { IONameMatch = dispext0; };'
        ```
*/

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

#define mfrequire(condition, reason...) assert(condition && (reason))
#define mflog(x...) { fputs([stringf(x) UTF8String], stdout); fputs("\n", stdout); fflush(stdout); }
#define isclass(obj, clsname) [[(obj) class] isSubclassOfClass: [clsname class]]
#define auto __auto_type
#define range(i, n) (int i = 0; i < (n); i++)
#define stringf(x...) [NSString stringWithFormat: x]

#define kPlane kIOServicePlane /*not sure which plane to use*/

NSString *indented(NSString *prefix, NSString *str) {
    return [str stringByReplacingOccurrencesOfString: @"(\n|^)(.)" withString: stringf(@"$1%@$2", prefix) options: NSRegularExpressionSearch range: NSMakeRange(0, str.length)];
}

NSString *withPrependedDepth(int depth, NSString *str) {
    NSArray *lines = [str componentsSeparatedByString: @"\n"];
    
    auto result = [NSMutableString new];
    
    int i = 0;
    for (NSString *line in lines) {
        if (i) [result appendString: @"\n"];
        if (!i) {
            for range(j, depth) {
                if (j < depth-1) [result appendString: @"|   "];
                else             [result appendString: @"+---"];
            }
        }
        else {
            for range(j, depth) [result appendString: @"|   "];
        }
        [result appendString: line];
        i++;
    }
    
    return result;
}

NSString *description(id obj) {
    
    if (isclass(obj, NSDictionary)) {
        if ([obj count] == 0) return @"{}";

        auto result = [NSMutableString new];
        
        [result appendFormat: @"{\n"];
        for (NSString *key in obj) {
            [result appendString: indented(@"    ", stringf(@"\"%@\" = %@;\n", key, description(obj[key])))];
        }
        
        [result appendFormat: @"}"];
    
        return result;
    }
    else if (isclass(obj, NSArray)) {
        if ([obj count] == 0) return @"()";

        auto result = [NSMutableString new];
        [result appendFormat: @"(\n"];
        for (NSObject *element in obj) {
            [result appendString: indented(@"    ", stringf(@"%@,\n", description(element)))];
        }
        [result appendFormat: @")"];
        
        return result;
    }
    else if (isclass(obj, NSData)) {
        NSData *data = obj;
        auto result = [NSMutableString new];
        [result appendString: @"<"];
        for (int i = 0; i < data.length; i+=1) {
            unsigned char *p = (unsigned char *)data.bytes+i;
            if (i && i%4 == 0) [result appendString: @" "];
            [result appendFormat: @"%02X", *p];
        }
        [result appendString: @">"];
        
        return result;
    }
    else if (isclass(obj, NSString)) {
        return stringf(@"\"%@\"", obj);
    }
    else {
        return [obj description];
    }
    
}

void IOIterator_ForEach(io_iterator_t iterator, void (^block)(io_service_t service, bool *stop)) {
    
    io_service_t service = IO_OBJECT_NULL;
    bool stop = false;
    for (;(service = IOIteratorNext(iterator));) {
        
        block(service, &stop);
        if (stop) { IOObjectRelease(service); break; }
        
        IOObjectRelease(service);
    }
    
    IOObjectRelease(iterator);
}

void IORegistryEntryShow(io_registry_entry_t entry, int depth) {
    
    
    
    kern_return_t ret;

    /// Print description
    @autoreleasepool /// Not sure this helps anything
    {
        auto propDescription = [NSMutableString new]; {
            
            NSDictionary *propsNS = nil; {
                CFMutableDictionaryRef props = NULL;
                ret = IORegistryEntryCreateCFProperties(entry, &props, kCFAllocatorDefault, /*options*/0);
                mfrequire(!ret, "IORegistryEntryCreateCFProperties failed");
                propsNS = CFBridgingRelease(props);
            }

            //[propDescription appendString: @"|\n"];
            for (NSString *key in propsNS) {
                [propDescription appendFormat: @"%@", indented(@"|   ", stringf(@"\"%@\" = %@;\n", key, description(propsNS[key])))];
            }
            [propDescription appendFormat: @"|"];
            
        }
        
        io_name_t name;
        ret = IORegistryEntryGetName(entry, name);
        mfrequire(!ret, "IORegistryEntryGetName failed");
        
        uint64_t entryID = 0;
        ret = IORegistryEntryGetRegistryEntryID(entry, &entryID);
        mfrequire(!ret, "IORegistryEntryGetRegistryEntryID failed");
        
        NSMutableString *classDescription = [NSMutableString new]; {
            NSString *cls = CFBridgingRelease(IOObjectCopyClass(entry));
            for (int i = 0; cls; i++) {
                if (i) [classDescription appendString: @" < "];
                [classDescription appendFormat: @"%@", cls];
                cls = CFBridgingRelease(IOObjectCopySuperclassForClass((__bridge void *)cls));
            }
        }
        
        NSString *path = CFBridgingRelease(IORegistryEntryCopyPath(entry, kPlane));
        
        mflog(@"%@", withPrependedDepth(depth, stringf(
            @"ö %s\n"               /// Use umlaut for greppability
            @"|   <\n"
            @"|        path %@\n"
            @"|          id 0x%llx\n"
            @"|       class %@\n"
            @"|   >\n"
            @"%@"
            , name
            , path
            , entryID
            , classDescription
            , propDescription
        )));
    }
    
    /// Recurse
    io_iterator_t iterator = IO_OBJECT_NULL;
    ret = IORegistryEntryGetChildIterator(entry, kPlane, &iterator);
    mfrequire(!ret, "IORegistryEntryGetChildIterator failed");
    IOIterator_ForEach(iterator, ^(io_service_t service, bool *stop) {
        @autoreleasepool { /// Not sure this helps anything
            IORegistryEntryShow(service, /*depth*/depth+1);
        }
    });
}

auto matchDictKeys = @[
    @ kIOProviderClassKey,          // @"IOProviderClass",
    @ kIONameMatchKey,              // @"IONameMatch",
    @ kIOPropertyMatchKey,          // @"IOPropertyMatch",
    @ kIOPropertyExistsMatchKey,    // @"IOPropertyExistsMatch",
    @ kIOPathMatchKey,              // @"IOPathMatch",
    @ kIOLocationMatchKey,          // @"IOLocationMatch",
    @ kIOParentMatchKey,            // @"IOParentMatch",
    @ kIOResourceMatchKey,          // @"IOResourceMatch",
    @ kIOMatchedServiceCountKey,    // @"IOMatchedServiceCountMatch",
];
auto matchDictKeysWithDescriptions = (@""
    "    \"IOProviderClass\"               (Super)class of the desired IOService\n"
    "    \"IONameMatch\"                   Name of the desired IOService\n"
    "    \"IOPropertyMatch\"               Key-value-pairs that should be present on the desired IOService\n"
    "    \"IOPropertyExistsMatch\"         Keys that should be present on the desired IOService\n"
    "    \"IOPathMatch\"                   Path of the desired IOService\n"
    "    \"IOLocationMatch\"               Location of the desired IOService\n"
    "    \"IOParentMatch\"                 Nested matchDict that the desired IOService's parent needs to match\n"
    "    \"IOResourceMatch\"               Not sure\n"
    "    \"IOMatchedServiceCountMatch\"    Not sure\n"
);

#define invalidArgs(reason...) { mflog(@"Couldn't parse args as matchDict: " reason); exit(1); }

void validateMatchDict(NSDictionary *matchDict) {
    for (NSString *key in matchDict) {
        if (![matchDictKeys containsObject: key]) invalidArgs("Invalid matchDict key: \"%@\".\nValid keys:\n%@", key, matchDictKeysWithDescriptions);
    }
    NSDictionary *parentMatch = matchDict[@"IOParentMatch"];
    if (parentMatch) validateMatchDict(parentMatch);
};

int main(void) {
    
    NSArray<NSString *> *args = [[NSProcessInfo processInfo] arguments];
    
    if (args.count > 1) {
        NSString *matchDictString = [[args subarrayWithRange: NSMakeRange(1, args.count-1)] componentsJoinedByString: @" "];
        
        NSError *errJSON = nil;
        NSError *errPlist = nil;
        NSDictionary *matchDict = nil;
        matchDict = [NSPropertyListSerialization propertyListWithData: [matchDictString dataUsingEncoding: NSUTF8StringEncoding] options: 0 format: nil error: &errPlist];
        if (!matchDict)
        matchDict = [NSJSONSerialization JSONObjectWithData: [matchDictString dataUsingEncoding: NSUTF8StringEncoding]  options: NSJSONReadingJSON5Allowed | NSJSONReadingTopLevelDictionaryAssumed error: &errJSON];
        
        if (!isclass(matchDict, NSDictionary)) invalidArgs("Not a valid dict (Plist or JSON).\nPlist error: %@.\nJSON error: %@.\nDecoded class (should be dict): %@.", errPlist, errJSON, matchDict.class);
        
        validateMatchDict(matchDict);
        
        io_iterator_t iterator = IO_OBJECT_NULL;
        kern_return_t ret = IOServiceGetMatchingServices(kIOMainPortDefault, CFBridgingRetain(matchDict), &iterator);
        mfrequire(!ret, "IOServiceGetMatchingServices failed");
        
        __block int i = 0;
        IOIterator_ForEach(iterator, ^(io_service_t service, bool *stop) {
            mflog(@"\nmatchDict match %d:\n", i+1);
            IORegistryEntryShow(service, /*depth*/0);
            i++;
        });
        
        mflog(@"\n---\n\nSummary: Found %d matches for matchDict: %@", i, description(matchDict));
        
    }
    else {
        
        io_registry_entry_t rootEntry = IORegistryGetRootEntry(kIOMainPortDefault);
        IORegistryEntryShow(rootEntry, /*depth*/0);
    }
    
    return 0;
}
