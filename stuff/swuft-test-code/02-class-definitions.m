/// 02-class-definitions.m
/// Written by Claude (Opus 4.5) – exploring Swuft class definition syntax
///
/// The goal: Small delta from C struct syntax, declarations and implementations together,
/// make the common case easy.

// =============================================================================
// SCENARIO 1: Simple data class (the most common case)
// =============================================================================

/// Current Objective-C 2.0 - requires FOUR separate pieces:
/// 1. @interface in header
/// 2. @implementation in .m
/// 3. Properties declared
/// 4. Init method written manually

// --- MyPerson.h ---
@interface MyPerson : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSDate *birthdate;
- (instancetype)initWithName:(NSString *)name age:(NSInteger)age birthdate:(NSDate *)birthdate;
@end

// --- MyPerson.m ---
@implementation MyPerson
- (instancetype)initWithName:(NSString *)name age:(NSInteger)age birthdate:(NSDate *)birthdate {
    self = [super init];
    if (self) {
        _name = [name copy];
        _age = age;
        _birthdate = birthdate;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"MyPerson(name=%@, age=%ld, birthdate=%@)",
            _name, (long)_age, _birthdate];
}
- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[MyPerson class]]) return NO;
    MyPerson *o = other;
    return [_name isEqual:o->_name] && _age == o->_age && [_birthdate isEqual:o->_birthdate];
}
- (NSUInteger)hash {
    return _name.hash ^ _age ^ _birthdate.hash;
}
@end


/// Swuft 2.0 - Everything in one place, @dataclass does the boilerplate
/// Inspired by your MFDataClass and Python's @dataclass

@dataclass Person : NSObject {
    @prop NSString *name;
    @prop NSInteger age;
    @prop NSDate *birthdate;
}
/// @dataclass auto-generates:
///   - Designated initializer with all props
///   - -[description] showing all props
///   - -[isEqual:] comparing all props
///   - -[hash] combining all props
///   - NSCoding conformance (if all props are codable)


/// Python @dataclass (for comparison)
@dataclass
class Person:
    name: str
    age: int
    birthdate: datetime


/// Swift struct (for comparison)
struct Person: Equatable, CustomStringConvertible {
    let name: String
    let age: Int
    let birthdate: Date

    var description: String {
        "Person(name=\(name), age=\(age), birthdate=\(birthdate))"
    }
}


/// C struct (what we're extending from)
struct Person {
    char *name;
    int age;
    time_t birthdate;
};


// =============================================================================
// SCENARIO 2: Class with custom methods
// =============================================================================

/// Current Objective-C 2.0
@interface NetworkClient : NSObject
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSURLSession *session;
- (void)fetchPath:(NSString *)path completion:(void(^)(NSData *, NSError *))completion;
+ (instancetype)sharedClient;
@end

@implementation NetworkClient
static NetworkClient *_sharedClient = nil;

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
        _sharedClient.baseURL = [NSURL URLWithString:@"https://api.example.com"];
        _sharedClient.session = [NSURLSession sharedSession];
    });
    return _sharedClient;
}

- (void)fetchPath:(NSString *)path completion:(void(^)(NSData *, NSError *))completion {
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    [[self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *r, NSError *e) {
        completion(data, e);
    }] resume];
}
@end


/// Swuft 2.0 - Declaration + implementation together
@class NetworkClient : NSObject {

    /// Properties (ivars auto-generated)
    @prop NSURL *baseURL;
    @prop NSURLSession *session;

    /// Class method
    + NetworkClient *sharedClient {
        static auto _shared = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shared = NetworkClient.[new];
            _shared.[baseURL] = NSURL.[URLWithString: @"https://api.example.com"];
            _shared.[session] = NSURLSession.[sharedSession];
        });
        return _shared;
    }

    /// Instance method
    - void fetchPath: (NSString *path) completion: (void (^completion)(NSData *, NSError *)) {
        auto url = NSURL.[URLWithString: path relativeToURL: self.[baseURL]];
        self.[session].[dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *r, NSError *e) {
            completion(data, e);
        }].[resume];
    }
}


// =============================================================================
// SCENARIO 3: Categories / Extensions
// =============================================================================

/// Current Objective-C 2.0
@interface NSString (Utilities)
- (NSString *)trimmed;
- (BOOL)isBlank;
@end

@implementation NSString (Utilities)
- (NSString *)trimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)isBlank {
    return [[self trimmed] length] == 0;
}
@end


/// Swuft 2.0
@extend NSString {
    - NSString *trimmed {
        return self.[stringByTrimmingCharactersInSet: NSCharacterSet.[whitespaceAndNewlineCharacterSet]];
    }
    - BOOL isBlank {
        return self.[trimmed].[length] == 0;
    }
}


// =============================================================================
// SCENARIO 4: Protocol / Interface definition
// =============================================================================

/// Current Objective-C 2.0
@protocol DataSource <NSObject>
@required
- (NSInteger)numberOfItems;
- (id)itemAtIndex:(NSInteger)index;
@optional
- (NSString *)titleForItemAtIndex:(NSInteger)index;
@end


/// Swuft 2.0 - Similar but cleaner
@protocol DataSource : NSObject {
    - NSInteger numberOfItems;
    - id itemAtIndex: (NSInteger index);

    @optional
    - NSString *titleForItemAtIndex: (NSInteger index);
}


/// Swift (for comparison)
protocol DataSource {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Any
    func title(forItemAt index: Int) -> String?  // optional via default impl
}


// =============================================================================
// SCENARIO 5: Generics
// =============================================================================

/// Current Objective-C 2.0 (lightweight generics)
@interface Stack<ObjectType> : NSObject
- (void)push:(ObjectType)object;
- (ObjectType)pop;
- (ObjectType)peek;
@property (nonatomic, readonly) NSUInteger count;
@end


/// Swuft 2.0 - Your idea of putting generics AFTER the type like subscripts
/// NSString *[NSArray *] means "NSArray of NSString *"
/// Actually let me try both...

/// Option A: Keep current <> syntax (familiar, works)
@class Stack<T> : NSObject {
    @prop NSArray<T> *storage;

    - void push: (T obj) {
        self.[storage].[addObject: obj];
    }
    - T pop {
        auto obj = self.[storage].[lastObject];
        self.[storage].[removeLastObject];
        return obj;
    }
}

/// Option B: Your [T] idea (matches subscript usage)
@class Stack [T] : NSObject {
    @prop T [NSArray *] storage;  /// An NSArray containing T

    - void push: (T obj) { ... }
    - T pop { ... }
}

/// Hmm, the [T] syntax is interesting conceptually but feels harder to read?
/// "T [NSArray *]" reads as "T-subscript-of-NSArray" which... kind of works?
/// But "<>" is so standard across languages that keeping it seems pragmatic.


// =============================================================================
// SCENARIO 6: Method signature variations (from your notes)
// =============================================================================

/// Comparing the different method declaration syntaxes you proposed:

/// Current Objective-C 2.0
- (NSArray<T> *)from:(NSInteger)i to:(NSInteger)j;

/// Your Version A: Parens separate selector from types
- (NSArray<T> *) from: (NSInteger i) to: (NSInteger j);

/// Your Version B: Decl follows use (like C)
- NSArray<T> *[from: NSInteger i to: NSInteger j];

/// Your Version D: Brackets no parens
- NSArray<T> *[from: NSInteger i to: NSInteger j];

/// Your current syntax with better spacing
- (NSArray<T> *) from: (NSInteger) i to: (NSInteger) j;

/// My observation: Current objc syntax with consistent spacing is actually fine.
/// The "weird" part is just the cast-like (type) for parameters.
/// But it's familiar to C programmers (cast syntax) so maybe that's okay?


// =============================================================================
// DESIGN NOTES
// =============================================================================

/// 1. @dataclass is probably the highest-value addition
///    - Eliminates 50+ lines of boilerplate for common case
///    - Already proven valuable in Python
///    - Your MFDataClass shows it's implementable in objc today
///
/// 2. Single-file class definition is cleaner
///    - No more header/impl split for simple classes
///    - Can still have .h files for public API if desired
///
/// 3. @extend is just a rename of categories - fine
///
/// 4. Keep <> for generics - too established to change
///
/// 5. Method signature syntax is a wash
///    - All versions are readable
///    - Current syntax isn't actually that bad with proper spacing

