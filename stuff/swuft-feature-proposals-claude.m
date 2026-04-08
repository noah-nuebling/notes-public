/// Written by Claude (Opus 4.5) - April 2026
/// Feature proposals for gaps in the Swuft design
/// Exploring: Async/Await, Rich Enums, Dataclasses, Error Handling

// =============================================================================
// MARK: - Feature 1: Async/Await
// =============================================================================

/*
The original notes don't address modern concurrency.
Here's a proposal that stays close to C/ObjC semantics.

Design principles:
- Should feel like a natural extension, not a new paradigm
- Should interop cleanly with existing GCD code
- Should be implementable as syntactic sugar over existing primitives
*/

// --- Proposal: `async` functions return NSTask (a promise-like object) ---

// Declaration: `async` keyword before return type
async NSData *fetchData(NSURL *url);

// Implementation
async NSData *fetchData(NSURL *url) {
    // `await` pauses this function and resumes when result is ready
    NSURLResponse *response;
    NSError *error;
    NSData *data = await NSURLSession.[sharedSession]
        .[dataTaskWithURL: url response: &response error: &error];

    if (error) {
        return nil;  // or throw? see error handling section
    }
    return data;
}

// Usage
async void processURLs(NSArray<NSURL *> *urls) {
    for (NSURL *url in urls) {
        NSData *data = await fetchData(url);
        if (data) {
            process(data);
        }
    }
}

// Calling async function from sync context - get the task object
void syncCaller() {
    NSTask *task = fetchData(someURL);  // Returns immediately with task

    // Option 1: Callback
    task.[onComplete: ^(NSData *data) {
        NSLog(@"Got data: %@", data);
    }];

    // Option 2: Block and wait (careful - can deadlock!)
    NSData *data = task.[wait];
}

// Parallel execution
async NSArray *fetchAllParallel(NSArray<NSURL *> *urls) {
    // Create tasks for all URLs
    NSMutableArray *tasks = NSMutableArray.[new];
    for (NSURL *url in urls) {
        tasks.[addObject: fetchData(url)];  // doesn't await, just creates task
    }

    // Wait for all
    return await NSTask.[all: tasks];
}

// Or with list comprehension!
async NSArray *fetchAllParallel_v2(NSArray<NSURL *> *urls) {
    auto tasks = @[ fetchData(url) for (NSURL *url in urls) ];
    return await NSTask.[all: tasks];
}

// Under the hood, this could desugar to GCD:
// - async functions are compiled to return an NSTask
// - NSTask wraps dispatch_async + continuation
// - await transforms the rest of the function into a completion block
// - Similar to how C# async/await works under the hood


// =============================================================================
// MARK: - Feature 2: Rich Enums (Sum Types)
// =============================================================================

/*
C enums are just integers. Swift/Rust enums can hold associated values.
This is incredibly useful for modeling states, results, messages, etc.

Proposal: @enum keyword for rich enums with associated values
*/

// Declaration
@enum Result<T> {
    case ok(T value);
    case err(NSError *error);
}

@enum Optional<T> {
    case some(T value);
    case none;
}

@enum Message {
    case text(NSString *content);
    case image(NSData *data, NSString *mimeType);
    case video(NSURL *url, NSTimeInterval duration);
    case location(double latitude, double longitude);
}

// Construction
Result<NSData *> r1 = Result.[ok: data];
Result<NSData *> r2 = Result.[err: error];

Message m1 = Message.[text: @"Hello"];
Message m2 = Message.[image: imgData mimeType: @"image/png"];
Message m3 = Message.[location: 37.7749 longitude: -122.4194];

// Pattern matching with switch
NSString *handleMessage(Message msg) {
    switch (msg) {
        case .text(NSString *content):
            return @"Text: %@".[format: content];

        case .image(NSData *data, NSString *mimeType):
            return @"Image (%@): %lu bytes".[format: mimeType, data.[length]];

        case .video(NSURL *url, NSTimeInterval duration):
            return @"Video: %.1fs at %@".[format: duration, url];

        case .location(double lat, double lon):
            return @"Location: (%.4f, %.4f)".[format: lat, lon];
    }
}

// `if case` for single-case matching
void processIfText(Message msg) {
    if case .text(NSString *content) = msg {
        NSLog(@"It's text: %@", content);
    }
}

// Result type for error handling
Result<NSData *> loadFile(NSString *path) {
    NSError *error;
    NSData *data = NSData.[dataWithContentsOfFile: path error: &error];
    if (error) {
        return Result.[err: error];
    }
    return Result.[ok: data];
}

void useResult() {
    auto result = loadFile(@"/etc/hosts");

    switch (result) {
        case .ok(NSData *data):
            process(data);
            break;
        case .err(NSError *error):
            NSLog(@"Error: %@", error);
            break;
    }

    // Or with if-case:
    if case .ok(NSData *data) = result {
        process(data);
    }

    // Convenience methods on Result:
    if (result.[isOk]) {
        NSData *data = result.[unwrap];  // crashes if err!
    }

    NSData *data = result.[unwrapOr: defaultData];  // safe
    NSData *data2 = result.[unwrapOrElse: ^{ return loadDefault(); }];
}

// Implementation notes:
// - @enum compiles to a tagged union (like Rust)
// - The tag is an integer, associated values are stored inline or boxed
// - Pattern matching compiles to switch on tag + unpacking
// - Methods can be added to @enum types (like Swift)


// =============================================================================
// MARK: - Feature 3: Dataclasses
// =============================================================================

/*
The notes mention wanting Python-like dataclasses.
Proposal: @dataclass directive for automatic:
- Designated initializer
- isEqual:/hash
- description
- Serialization (optional)
*/

// Declaration
@dataclass Person {
    NSString *name;
    NSInteger age;
    NSArray<NSString *> *tags;
    Person *spouse;  // nullable by default for objects
}

// This auto-generates:

// 1. Designated initializer
- (instancetype)initWithName:(NSString *)name
                         age:(NSInteger)age
                        tags:(NSArray<NSString *> *)tags
                      spouse:(Person *)spouse;

// 2. Convenience factory
+ (instancetype)personWithName:(NSString *)name
                           age:(NSInteger)age
                          tags:(NSArray<NSString *> *)tags
                        spouse:(Person *)spouse;

// 3. isEqual: comparing all fields
- (BOOL)isEqual:(id)object;

// 4. hash combining all field hashes
- (NSUInteger)hash;

// 5. description showing all fields
- (NSString *)description;

// Usage
Person *alice = Person.[new: @"Alice" age: 30 tags: @[@"admin"] spouse: nil];
Person *bob = Person.[new: @"Bob" age: 32 tags: @[@"user"] spouse: alice];

NSLog(@"%@", bob);
// Output: Person(name="Bob", age=32, tags=["user"], spouse=Person(name="Alice", ...))

if (alice.[eq: anotherAlice]) {
    // same content
}

// --- Advanced: Customization options ---

@dataclass(eq=NO, hash=NO) Point {
    // Don't generate eq/hash
    double x;
    double y;
}

@dataclass(init=NO) CustomInit {
    // Don't generate init, we'll provide our own
    NSString *value;

    - (instancetype)initWithRawValue:(int)raw {
        self = super.[init];
        _value = @"%d".[format: raw];
        return self;
    }
}

@dataclass(serializable=YES) Config {
    // Generate NSCoding and JSON serialization
    NSString *apiKey;
    NSURL *endpoint;
    NSInteger timeout;
}

// With serializable=YES, adds:
// - NSCoding protocol (encodeWithCoder:/initWithCoder:)
// - toDictionary/fromDictionary methods
// - toJSON/fromJSON methods

Config *config = Config.[fromJSON: jsonData];
NSData *json = config.[toJSON];

// --- Implementation approach ---

// Option A: Compiler magic (like Swift's synthesized conformances)
// Pros: Efficient, can optimize
// Cons: More compiler complexity

// Option B: Runtime reflection + macros (like MFDataClass in mac-mouse-fix)
// Pros: Can be done today with ObjC runtime
// Cons: Slightly less efficient, no autocomplete for generated methods

// Option C: Source code generation tool (like protobuf)
// Pros: Transparent, debuggable
// Cons: Extra build step

// Recommendation: Option A for a "real" Swuft, Option B as a polyfill


// =============================================================================
// MARK: - Feature 4: Error Handling
// =============================================================================

/*
Current ObjC error handling: NSError **outError
This is verbose and easy to forget to check.

Options:
A) Keep NSError ** (current)
B) Add throws/try/catch (like Swift)
C) Use Result<T> type (like Rust)
D) Combination
*/

// --- Option A: Current NSError ** ---

NSData *loadFile_current(NSString *path, NSError **outError) {
    FILE *f = fopen(path.[UTF8String], "r");
    if (!f) {
        if (outError) {
            *outError = NSError.[errorWithDomain: NSPOSIXErrorDomain
                                            code: errno
                                        userInfo: nil];
        }
        return nil;
    }
    defer fclose(f);
    // ... read file ...
    return data;
}

// Problem: Easy to forget to check error
// NSData *data = loadFile_current(@"missing.txt", nil);  // ignores error!

// --- Option B: throws/try/catch ---

// Declaration marks function as throwing
NSData *loadFile_throws(NSString *path) throws {
    FILE *f = fopen(path.[UTF8String], "r");
    if (!f) {
        throw NSError.[errorWithDomain: NSPOSIXErrorDomain
                                   code: errno
                               userInfo: nil];
    }
    defer fclose(f);
    // ... read file ...
    return data;
}

// Usage requires try
void useThrows() {
    try {
        NSData *data = try loadFile_throws(@"test.txt");
        process(data);
    } catch (NSError *error) {
        NSLog(@"Error: %@", error);
    }

    // Or propagate
    NSData *wrapper(NSString *path) throws {
        return try loadFile_throws(path);  // propagates throw
    }

    // Or with try? for optional result
    NSData *data = try? loadFile_throws(@"test.txt");  // nil on error
}

// --- Option C: Result<T> type ---

Result<NSData *> loadFile_result(NSString *path) {
    FILE *f = fopen(path.[UTF8String], "r");
    if (!f) {
        return Result.[err: NSError.[errorWithDomain: NSPOSIXErrorDomain
                                                code: errno
                                            userInfo: nil]];
    }
    defer fclose(f);
    // ... read file ...
    return Result.[ok: data];
}

// Usage requires handling
void useResult() {
    auto result = loadFile_result(@"test.txt");
    if case .ok(NSData *data) = result {
        process(data);
    } else if case .err(NSError *error) = result {
        NSLog(@"Error: %@", error);
    }
}

// --- Option D: Combination (Recommended) ---

// - Keep NSError ** for compatibility with existing APIs
// - Add Result<T> as a stdlib type for new code
// - Add try? syntax to convert throwing/NSError functions to Result

// Interop:
Result<NSData *> result = try? oldFunctionWithError(path, &error);

// And backwards:
NSError *error;
NSData *data = result.[unwrapError: &error];


// =============================================================================
// MARK: - Feature 5: String Interpolation
// =============================================================================

/*
The notes mention @f"..." for string interpolation.
Let's flesh this out.
*/

// Proposed syntax: @f"literal %{expr} more literal"
// (Similar to Python f-strings but with %{} instead of {})

void testStringInterpolation() {
    NSString *name = @"Alice";
    NSInteger age = 30;

    // Current ObjC
    NSString *s1 = [NSString stringWithFormat:@"Name: %@, Age: %ld", name, (long)age];

    // Swuft with .format
    NSString *s2 = @"Name: %@, Age: %ld".[format: name, (long)age];

    // Swuft with interpolation
    NSString *s3 = @f"Name: %{name}, Age: %{age}";

    // Complex expressions work too
    NSString *s4 = @f"Upper: %{name.[uppercaseString]}, Next year: %{age + 1}";

    // Nested objects
    Person *p = Person.[new: @"Bob" age: 25];
    NSString *s5 = @f"Person: %{p.name} is %{p.age} years old";

    // Format specifiers?
    double pi = 3.14159;
    NSString *s6 = @f"Pi: %{pi:.2f}";  // "Pi: 3.14"
    // The :.2f syntax inside %{} specifies format

    // Implementation: desugars to stringWithFormat:
    // @f"Name: %{name}, Age: %{age}"
    // becomes:
    // [NSString stringWithFormat:@"Name: %@, Age: %@", name, @(age)]
    // (primitives auto-boxed to use %@)
}


// =============================================================================
// MARK: - Feature 6: Slicing Syntax
// =============================================================================

/*
Python's slice syntax is very expressive: arr[1:5], arr[::2], arr[::-1]
Can we add this to Swuft?
*/

// Proposed: arr[start:end:step] with Python semantics

@extend NSArray<T> {
    - (NSArray<T> *) __getitem_slice__:(NSInteger)start
                                    to:(NSInteger)end
                                  step:(NSInteger)step;
}

void testSlicing() {
    NSArray *arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];

    // Basic slicing
    auto a = arr[2:5];      // @[@2, @3, @4] (indices 2,3,4)
    auto b = arr[:3];       // @[@0, @1, @2] (first 3)
    auto c = arr[7:];       // @[@7, @8, @9] (from index 7)
    auto d = arr[:-2];      // @[@0, ... @7] (all but last 2)

    // With step
    auto e = arr[::2];      // @[@0, @2, @4, @6, @8] (every other)
    auto f = arr[1::2];     // @[@1, @3, @5, @7, @9] (odd indices)
    auto g = arr[::-1];     // @[@9, @8, ... @0] (reversed)
    auto h = arr[5:2:-1];   // @[@5, @4, @3] (backwards from 5 to 3)

    // Strings too
    NSString *s = @"Hello, World!";
    auto t = s[7:12];       // @"World"
    auto u = s[::-1];       // @"!dlroW ,olleH"

    // Implementation:
    // arr[i:j:k] desugars to arr.[__getitem_slice__: i to: j step: k]
    // Default values: i=0, j=count, k=1
    // Negative indices wrap: -1 means last element

    // Parsing consideration:
    // `arr[i:j]` could conflict with C syntax... but does it?
    // In C, `arr[i]` is subscript. `arr[i:j]` is not valid C.
    // So we can add it without breaking anything!

    // What about ternary? `arr[cond ? a : b]`
    // This is `arr[(cond ? a : b)]` - subscript with ternary value
    // Not a slice! The `:` is inside `? :` not bare.
    // Parser can distinguish.
}


// =============================================================================
// MARK: - Feature 7: Named Parameters for C Functions
// =============================================================================

/*
ObjC methods have named parameters. C functions don't.
Could we add optional named params to C function calls?
*/

// Current C
void drawRect(int x, int y, int width, int height, int color);
drawRect(10, 20, 100, 50, 0xFF0000);  // what does each mean?

// Proposed: Allow naming params at call site (like Python)
drawRect(x: 10, y: 20, width: 100, height: 50, color: 0xFF0000);

// Or mixed:
drawRect(10, 20, width: 100, height: 50, color: 0xFF0000);

// Rules:
// - Names are optional at call site
// - If used, must match parameter names in declaration
// - Named params can be in any order (like Python) - MAYBE too complex
// - Actually, let's keep them in order but just allow names for clarity
//   (Simpler to implement, still helps readability)

// This is purely syntactic - names are checked at compile time,
// then discarded. No runtime overhead.

// Another idea: _ for deliberately unnamed
setPixel(100, 200, _, _, 255);  // skip alpha and flags with defaults?
// This requires default parameter values too...

// Default parameter values:
void drawCircle(int x, int y, int radius, int color = 0x000000, int lineWidth = 1);
drawCircle(100, 100, 50);  // uses default color and lineWidth
drawCircle(100, 100, 50, color: 0xFF0000);  // explicit color, default lineWidth

// This is a significant C extension but very useful.


// =============================================================================
// MARK: - Summary: Complete Feature Set
// =============================================================================

/*

## Core Swuft (From Original Notes):
- Dot-bracket method syntax: obj.[method: arg]
- Property syntax unchanged: obj.property
- `defer` statement
- `auto` for type inference
- List comprehensions: @[ expr for (x in xs) if (cond) ]
- Shorter stdlib names (optional)

## Proposed Extensions:
1. **Async/Await** - for modern concurrency without callback hell
2. **Rich Enums** (@enum) - sum types with associated values
3. **Dataclasses** (@dataclass) - automatic init/eq/hash/description
4. **Result<T>** type - explicit error handling
5. **String Interpolation** - @f"Hello %{name}"
6. **Slice Syntax** - arr[1:5], arr[::-1]
7. **Named C Parameters** - func(x: 10, y: 20)
8. **Lighter Block Syntax** - ^(a, b) { a + b } with type inference

## NOT Proposed (Keeping C Compatible):
- Changing == operator semantics
- Radical closure syntax changes
- Breaking changes to existing code
- Removing NS prefixes (optional modernization only)

## Philosophy:
Swuft should feel like "Objective-C with the rough edges sanded off"
rather than a new language. Every feature should:
1. Be implementable as syntactic sugar where possible
2. Interop cleanly with existing ObjC/C code
3. Not break existing mental models
4. Have a clear implementation path

The goal is to make Objective-C competitive with Swift/Kotlin/Python
in terms of expressiveness, while keeping its unique strengths:
- True C superset (call any C API directly)
- Dynamic runtime (introspection, swizzling)
- Simple object model (everything is a pointer)
- Predictable ARC memory management

*/

