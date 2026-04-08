/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// Class Definitions and Dataclasses
/// Exploring different syntaxes for defining classes

// =============================================================================
// Basic class definition - exploring the syntax options from the notes
// =============================================================================

/// --- Swuft Option A: @class with inline methods (from original notes) ---

@class Person : Object {

    /// Ivars
    String *name;
    int age;
    @private String *_ssn;

    /// Properties (auto-generate getter/setter)
    @property String *email;
    @property(readonly) String *fullDescription;

    /// Instance method
    - String *[greet: String *other] {
        return @"Hello, %@! I'm %@.".[format: other, name];
    }

    /// Class method
    + Person *[withName: String *n age: int a] {
        auto p = Person.[new];
        p->name = n;
        p->age = a;
        return p;
    }

    /// Dunder method for description (if we add Python-style dunders)
    - String *__str__ {
        return @"Person(%@, %d)".[format: name, @(auto)age];
    }
}


/// --- Swuft Option B: Closer to C struct syntax ---
/// (The idea: start with a C struct, swap 'struct' for '@class', add methods)

@class Person : Object {
    String *name;
    int age;

    /// Methods use selector syntax but appear inline
    (String *) greet: (String *other) {
        return @"Hello, %@! I'm %@.".[format: other, self->name];
    }
}


/// --- Swuft Option C: Separate interface/implementation (like current ObjC) ---

/// Forward declaration (header file)
@class Person;

/// Interface (header file)
@class Person : Object {
    String *name;
    int age;

    - (String *) greet: (String *other);
    + (Person *) withName: (String *n) age: (int a);
}

/// Implementation (.m file)
@class @implementation Person {

    - (String *) greet: (String *other) {
        return @"Hello, %@! I'm %@.".[format: other, name];
    }

    + (Person *) withName: (String *n) age: (int a) {
        auto p = Person.[new];
        p->name = n;
        p->age = a;
        return p;
    }
}


/// --- Current Objective-C ---

@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
- (NSString *)greet:(NSString *)other;
+ (instancetype)personWithName:(NSString *)name age:(int)age;
@end

@implementation Person
- (NSString *)greet:(NSString *)other {
    return [NSString stringWithFormat:@"Hello, %@! I'm %@.", other, self.name];
}
+ (instancetype)personWithName:(NSString *)name age:(int)age {
    Person *p = [[Person alloc] init];
    p.name = name;
    p.age = age;
    return p;
}
@end


/// --- Swift ---

class Person {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func greet(_ other: String) -> String {
        return "Hello, \(other)! I'm \(name)."
    }
}


// =============================================================================
// Dataclasses - automatic description, equality, serialization
// =============================================================================

/// --- Swuft Dataclass Option A: @dataclass decorator-like syntax ---

@dataclass Person {
    String *name;
    int age;
    String *email;
}

/// This would auto-generate:
///   - Designated initializer: Person.[withName: n age: a email: e]
///   - .__str__ / description
///   - .__eq__ / isEqual:
///   - Serialization to/from plist/JSON
///   - Memberwise copy


/// --- Swuft Dataclass Option B: Just extend @class with @auto directives ---

@class Person : Object {
    String *name;
    int age;
    String *email;

    @auto init;         /// Generate .[withName:age:email:]
    @auto description;  /// Generate .[description] / __str__
    @auto equality;     /// Generate .[isEqual:] / __eq__
    @auto serialization;/// Generate .[toJSON], .[fromJSON:]
}


/// --- Swuft Dataclass Option C: Convention-based (like MFDataClass) ---
/// If you inherit from DataClass, you get reflection-based implementations

@class Person : DataClass {
    String *name;
    int age;
    String *email;
}

/// DataClass provides default implementations that use runtime reflection
/// to enumerate ivars and properties.


/// --- Python dataclass ---

from dataclasses import dataclass

@dataclass
class Person:
    name: str
    age: int
    email: str


/// --- Swift struct (closest equivalent) ---

struct Person: Codable, Equatable {
    var name: String
    var age: Int
    var email: String
}


// =============================================================================
// Usage comparison
// =============================================================================

void usage_swuft() {

    /// Creating instances
    auto p1 = Person.[withName: @"Alice" age: 30 email: @"alice@example.com"];
    auto p2 = Person.[withName: @"Bob" age: 25 email: @"bob@example.com"];

    /// Accessing properties
    printf("Name: %s\n", p1->name.[UTF8String]);
    /// Or if we use property syntax:
    printf("Name: %s\n", p1.name.[UTF8String]);

    /// Equality (if __eq__ is implemented)
    if (p1 == p2) { ... }           /// Operator overloading version
    if (p1.[eq: p2]) { ... }        /// Method version

    /// Description
    printf("%s\n", p1.[description].[UTF8String]);
    /// Or with dunder:
    printf("%s\n", p1.__str__.[UTF8String]);

    /// Serialization
    auto json = p1.[toJSON];
    auto restored = Person.[fromJSON: json];

    /// Putting in collections
    auto people = @( p1, p2 );
    auto byName = @{ p1->name: p1, p2->name: p2 };
}


// =============================================================================
// Categories / Extensions
// =============================================================================

/// --- Swuft ---

@extend String {

    /// Add a method to check if string is a valid email
    - bool isValidEmail {
        /// Simple regex check
        return self.[matches: @"^[^@]+@[^@]+\\.[^@]+$"];
    }

    /// Add computed property-like method
    - String *reversed {
        auto result = MutableString.[new];
        for (int i = (int)self.[length] - 1; i >= 0; i--) {
            result.[appendChar: self.[charAtIndex: i]];
        }
        return result;
    }
}

/// Usage:
void extension_usage() {
    auto email = @"test@example.com";
    if (email.[isValidEmail]) {
        printf("Valid!\n");
    }

    auto str = @"hello";
    printf("%s\n", str.[reversed].[UTF8String]);  /// "olleh"
}


/// --- Current Objective-C ---

@interface NSString (Validation)
- (BOOL)isValidEmail;
- (NSString *)reversed;
@end

@implementation NSString (Validation)
- (BOOL)isValidEmail {
    NSRegularExpression *regex = [NSRegularExpression
        regularExpressionWithPattern:@"^[^@]+@[^@]+\\.[^@]+$"
        options:0 error:nil];
    return [regex numberOfMatchesInString:self options:0
        range:NSMakeRange(0, self.length)] > 0;
}
- (NSString *)reversed {
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = self.length - 1; i >= 0; i--) {
        [result appendFormat:@"%c", [self characterAtIndex:i]];
    }
    return result;
}
@end


/// --- Swift ---

extension String {
    var isValidEmail: Bool {
        return self.range(of: "^[^@]+@[^@]+\\.[^@]+$",
                          options: .regularExpression) != nil
    }

    var reversed: String {
        return String(self.reversed())
    }
}
