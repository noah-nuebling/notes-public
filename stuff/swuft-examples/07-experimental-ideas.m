/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// Experimental Ideas
/// Pushing the design further - some of these might be too much complexity

// =============================================================================
// IDEA 1: Pattern Matching / Destructuring
// =============================================================================

/// Python and modern languages have nice destructuring. Could Swuft?

/// Tuple destructuring (if we add tuples)
struct { auto name; int age; } = person.[nameAndAge];

/// Array destructuring
auto [first, second, ...rest] = myArray;

/// Dictionary destructuring (trickier - keys are runtime strings)
/// Maybe pattern-match on known keys?
switch (dict) {
    case @{ @"type": @"user", @"name": auto name }:
        printf("User: %s\n", name.[UTF8String]);
        break;
    case @{ @"type": @"admin" }:
        printf("Admin\n");
        break;
}

/// This is getting complex. Maybe too much for the "simple C extension" philosophy.


// =============================================================================
// IDEA 2: Async/Await (if we must)
// =============================================================================

/// ObjC has dispatch_async and completion blocks. Could add syntax sugar:

/// Current ObjC
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSData *data = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIWithData:data];
    });
});

/// Swuft with async/await
async void fetchAndUpdate() {
    auto data = await Data.[contentsOfURL: url];
    await dispatch_main();
    self.[updateUIWithData: data];
}

/// Or just lean into GCD more cleanly:
void fetchAndUpdate() {
    dispatch_background ^{
        auto data = Data.[contentsOfURL: url];
        dispatch_main ^{
            self.[updateUIWithData: data];
        };
    };
}

/// OBSERVATION: True async/await is complex to implement and changes the runtime.
/// Maybe just make GCD syntax nicer? The second version is almost as readable.


// =============================================================================
// IDEA 3: Method Chaining Builder Pattern
// =============================================================================

/// Fluent builders are common. Could add syntax support:

/// Option A: Return self implicitly for void methods (Ruby style)
@class URLRequestBuilder {
    URLRequest *request;

    - void [setURL: URL *url] {
        request = URLRequest.[with: url];
    }   /// Implicitly returns self because void

    - void [setMethod: String *method] {
        request.[setHTTPMethod: method];
    }

    - void [setBody: Data *data] {
        request.[setHTTPBody: data];
    }

    - URLRequest *build {
        return request;
    }
}

/// Usage:
auto request = URLRequestBuilder.[new]
    .[setURL: url]
    .[setMethod: @"POST"]
    .[setBody: body]
    .[build];

/// Option B: Explicit "chainable" modifier
- chainable void [setURL: URL *url] { ... }

/// OBSERVATION: Option A (implicit self return for void) is simple and useful.
/// Matches Ruby convention. Low cost, high value.


// =============================================================================
// IDEA 4: Compile-Time Reflection for Dataclasses
// =============================================================================

/// The notes mention wanting dataclass-like codegen. Here's a concrete proposal:

/// @dataclass directive causes the compiler to:
/// 1. Generate -[initWith<Field>:<type>...] initializer
/// 2. Generate -[description] using field names
/// 3. Generate -[isEqual:] comparing all fields
/// 4. Generate -[copyWithZone:] if requested
/// 5. Generate -[encodeWithCoder:] and -[initWithCoder:] if requested

@dataclass @codable Person {
    String *name;
    int age;
    Array [String *] *tags;
}

/// Expands to something like:
@class Person : Object <Codable, Copyable> {
    String *name;
    int age;
    Array [String *] *tags;

    /// Auto-generated:
    + Person *[withName: String *name age: int age tags: Array [String *] *tags];
    - String *description;
    - bool [isEqual: id other];
    - id [copyWithZone: void *zone];
    - void [encodeWithCoder: Coder *coder];
    + Person *[initWithCoder: Coder *coder];
}

/// The implementations use compile-time knowledge of field names/types.
/// No runtime reflection needed for basic functionality.


// =============================================================================
// IDEA 5: Algebraic Data Types (Tagged Unions)
// =============================================================================

/// C has unions but they're unsafe. Could add safe tagged unions:

@enum Result [T, E] {
    case ok(T *value);
    case err(E *error);
}

/// Usage:
Result [Data *, Error *] *result = fetchData();

switch (result) {
    case .ok(auto data):
        printf("Got %d bytes\n", data.[length]);
        break;
    case .err(auto error):
        printf("Error: %s\n", error.[description].[UTF8String]);
        break;
}

/// This is basically Swift's enum with associated values.
/// Very powerful but adds significant complexity to the type system.

/// OBSERVATION: This might be too much. The "keep it simple" philosophy
/// suggests just using NSError* out-params or a Result class.


// =============================================================================
// IDEA 6: String Interpolation
// =============================================================================

/// The notes mention @f"..." syntax. Let's define it precisely:

auto name = @"World";
auto count = 42;

/// String interpolation with %{expr}
auto greeting = @f"Hello, %{name}! Count: %{count}";

/// Desugars to:
auto greeting = @"Hello, %@! Count: %d".[format: name, count];

/// With expressions:
auto msg = @f"Sum: %{a + b}, Product: %{a * b}";

/// With format specifiers:
auto precise = @f"Pi: %{pi:.4f}";

/// OBSERVATION: This is straightforward sugar. Worth adding.
/// The %{} syntax is distinct from C's % format specifiers.


// =============================================================================
// IDEA 7: Better For-Loop Syntax
// =============================================================================

/// The notes mention `loopc` and `range`. Here are some options:

/// Option A: Python-like range
for (int i in range(10)) { ... }
for (int i in range(5, 10)) { ... }
for (int i in range(10, 0, -1)) { ... }

/// Option B: Swift-like range operators
for (int i in 0..<10) { ... }
for (int i in 0...9) { ... }

/// Option C: Just make `for...in` work with integers
for (int i : 10) { ... }            /// 0 to 9

/// Option D: Keep C syntax, use macros for common cases
#define times(n) for (int _i = 0; _i < (n); _i++)
#define range(i, n) for (int i = 0; i < (n); i++)

times(10) { printf("hello\n"); }
range(i, array.[count]) { ... }

/// OBSERVATION: Option D (macros) fits the "minimal language, good library" philosophy.
/// range() is already possible in C today.


// =============================================================================
// IDEA 8: Implicit Self in Methods
// =============================================================================

/// In ObjC/Swuft, you often write self->field or self.[method].
/// Could make self implicit like in Python classes?

@class Counter {
    int count;

    - void increment {
        count++;                    /// Implicit self->count
    }

    - void [incrementBy: int n] {
        count += n;                 /// Implicit self->count
    }

    - int doubled {
        return count * 2;           /// Implicit self->count
    }
}

/// OBSERVATION: ObjC already does this for ivars. Just formalize it.
/// Local variables shadow ivars (like current ObjC).


// =============================================================================
// IDEA 9: Namespaced Standard Library
// =============================================================================

/// To avoid NS prefix but prevent conflicts:

@namespace std {
    @class String { ... }
    @class Array [T] { ... }
    @class Dictionary [K, V] { ... }
}

/// Usage:
std::String *s = @"hello";

/// Or with using:
using namespace std;
String *s = @"hello";

/// OBSERVATION: Maybe overkill. Just dropping NS and using short names
/// (String, Array, Dict) is probably fine for a standard library.
/// Conflicts can be resolved with module prefixes.


// =============================================================================
// IDEA 10: Property Observers
// =============================================================================

/// Swift has willSet/didSet. Could be useful:

@class Person {
    @property String *name {
        willSet(newName) {
            printf("Changing name from %s to %s\n",
                   name.[UTF8String], newName.[UTF8String]);
        }
        didSet(oldName) {
            self.[notifyNameChanged];
        }
    }
}

/// Or simpler: just let people override setters
@class Person {
    @property String *name;

    - void [setName: String *newName] {
        printf("Changing name\n");
        name = newName;
        self.[notifyNameChanged];
    }
}

/// OBSERVATION: The second approach (override setter) already works in ObjC.
/// Property observers are sugar but not essential.


// =============================================================================
// SUMMARY: Which ideas are worth the complexity?
// =============================================================================

/*
DEFINITELY ADD:
- String interpolation @f"..."          (Simple, high value)
- Implicit void->self for builders      (Simple, common pattern)
- range() macro in stdlib               (Zero language change)

PROBABLY ADD:
- @dataclass with codegen               (Valuable, medium complexity)
- Property observers                    (Already possible, just sugar)

MAYBE ADD:
- Basic destructuring for tuples        (Useful, moderate complexity)
- Async syntax sugar for GCD            (Complex but common need)

PROBABLY NOT:
- Full algebraic data types             (Big complexity, Swift territory)
- Pattern matching on dicts             (Too dynamic, runtime cost)
- Namespaces                            (Just use short names)
- Generic methods                       (Defer until needed)
*/
