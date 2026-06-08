//usr/bin/clang -fmodules -fobjc-arc -g -o /tmp/ioreggg2.a "$0" && exec /tmp/ioreggg2.a "$@"

//  ioreggg2.m
//      Like ioreggg.m but prints one big old-style plist. (Which you can open in Xcode old-style-plist viewer.)

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

NSString *repeating(NSString *s, int n) {
    return [@"" stringByPaddingToLength: n * s.length withString: s startingAtIndex: 0];
}

NSString *description(id obj);

NSString *nakedDescription(NSDictionary *obj) {
    auto result = [NSMutableString new];
    int i = 0;
    for (NSString *key in obj) {
        if (i) [result appendString: @"\n"];
        [result appendString: stringf(@"\"%@\" = %@;", key, description(obj[key]))];
        i++;
    }
    
    return result;
}

NSString *description(id obj) {
    
    if (isclass(obj, NSDictionary)) {
        if ([obj count] == 0) return @"{}";

        auto result = [NSMutableString new];
        
        [result appendFormat: @"{\n"];
        [result appendFormat: @"%@", indented(@"    ", nakedDescription(obj))];
        [result appendFormat: @"\n}"];
    
        return result;
    }
    else if (
        isclass(obj, NSArray) ||
        isclass(obj, NSSet)         // Naturally prints as {( a,b,c }) but that's not a valid plist entry
    ) {
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
        return stringf(@"\"%@\"", [obj stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""]);
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
            int i = 0;
            for (NSString *key in propsNS) {
                if (i) [propDescription appendString: @"\n"];
                [propDescription appendFormat: @"%@", indented(@"    ", stringf(@"\"%@\" = %@;", key, description(propsNS[key])))];
                i++;
            }
            //[propDescription appendFormat: @" "];
            
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
        
        #define logAtDepth(x...) mflog(@"%@", indented(repeating(@"    ", depth), stringf(x)))

        logAtDepth(@""
           "\"%s (0x%0llX)\" = {\n" /// Use name+entryID as unique id / dict key for this node. Not sure if good.
           "%@\n"
           "    \"__PROPS__\" = {\n"
           "%@\n"
           "    };"
            , name, entryID
            , indented(@"    ", nakedDescription(@{
                @"__NAME__": @(name ?: ""),
                @"__ID__": @(entryID),
                @"__PATH__": path ?: @"",
                @"__CLASS__": classDescription ?: @"",
            }))
            , indented(@"    ", propDescription)
        );
    }
    
    /// Recurse
    io_iterator_t iterator = IO_OBJECT_NULL;
    ret = IORegistryEntryGetChildIterator(entry, kPlane, &iterator);
    mfrequire(!ret, "IORegistryEntryGetChildIterator failed");
    __block int i = 0;
    IOIterator_ForEach(iterator, ^(io_service_t service, bool *stop) {
        @autoreleasepool { /// Not sure this helps anything
            if (!i) logAtDepth(@"    \"__CHILDREN__\" = {");
            IORegistryEntryShow(service, /*depth*/depth+1);
            i++;
        }
    });

    if (i) logAtDepth(@"    }; /* Children end */");


    logAtDepth(@"};");
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
