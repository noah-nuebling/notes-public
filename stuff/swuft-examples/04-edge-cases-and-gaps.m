/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// Edge Cases and Design Gaps
/// Testing tricky scenarios to find rough edges

// =============================================================================
// GAP 1: Unnamed parameters / first parameter naming
// =============================================================================

/// The notes mention: "Not sure how to declare a method with unnamed params"
///
/// In ObjC, the first parameter is often "unnamed" in that it's part of the selector:
///     [array objectAtIndex:5]     // "objectAtIndex:" is the selector, 5 is unnamed
///     [str hasPrefix:@"foo"]      // first param has no external label
///
/// In Swuft dot-bracket syntax:
///     array.[objectAtIndex: 5]    // This works fine
///     array.[at: 5]               // Shortened version, also fine
///
/// But what about methods where you want NO label at all?

/// Option A: Use underscore like Swift
- String *[uppercase: _];           /// Declaration with unnamed param
str.[uppercase: @"hello"];          /// Call - but this looks weird

/// Option B: Just make the first param always part of selector (current ObjC behavior)
/// This means every method has at least a name before the first colon.
/// arrayOfStrings.[map: ^(String *s) { return s.[uppercase]; }]

/// Option C: Allow truly anonymous params only for single-param methods
- String *[: String *input];        /// Weird but explicit
str.[: @"hello"];                   /// Call syntax - very weird

/// RECOMMENDATION: Just keep ObjC's approach where first param is always named
/// via the selector. The cost of this verbosity is low.


// =============================================================================
// GAP 2: Blocks / Closures syntax
// =============================================================================

/// ObjC block syntax is notoriously ugly:
///     void (^myBlock)(int, NSString *) = ^(int x, NSString *s) { ... };

/// In Swuft, how do we improve this?

/// Option A: Keep block syntax but with type inference
auto myBlock = ^(int x, String *s) {
    printf("%d: %s\n", x, s.[UTF8String]);
};

/// Option B: Use a more lambda-like syntax (but this might conflict with C)
auto myBlock = (int x, String *s) => {
    printf("%d: %s\n", x, s.[UTF8String]);
};

/// Option C: Python-like lambda for simple cases
auto double = ^(int x) { return x * 2; };
/// vs
auto double = \x -> x * 2;          /// Haskell-ish
auto double = |x| x * 2;            /// Rust-ish

/// For map/filter/reduce, you need blocks. How ugly is it?

/// Current ObjC (very ugly):
NSArray *doubled = [numbers map:^id(NSNumber *n) {
    return @(n.intValue * 2);
}];

/// Swuft with minimal changes:
auto doubled = numbers.[map: ^(Number *n) { return @(auto)(n.[intValue] * 2); }];

/// Swuft with => syntax:
auto doubled = numbers.[map: (n) => @(auto)(n.[intValue] * 2)];

/// OBSERVATION: The block syntax is still verbose compared to Swift/Python/Rust
/// but it's workable. Maybe worth adding a shorthand for single-expression blocks.


// =============================================================================
// GAP 3: Generics and type parameters
// =============================================================================

/// The notes propose: Array [String *] * instead of NSArray<NSString *> *
/// This is nice because it mirrors usage (you use [] to access elements)

/// But what about methods that take type parameters?

/// How do you declare a generic method?
- T *[first: Array [T] *arr where: ^bool(T *item) predicate];

/// Or a generic class?
@class Stack [T] {
    Array [T] *items;

    - void [push: T *item] {
        items.[add: item];
    }

    - T *pop {
        auto item = items.[last];
        items.[removeLast];
        return item;
    }
}

/// Usage:
Stack [String *] *stringStack = Stack.[new];
stringStack.[push: @"hello"];
auto s = stringStack.[pop];         /// Type is String *

/// OBSERVATION: The [T] syntax for generics is nice and consistent.
/// But declaring generic methods/classes needs more thought.
/// ObjC's lightweight generics are limited - Swuft could potentially do better.


// =============================================================================
// GAP 4: Nullable types and optional chaining
// =============================================================================

/// Notes mention adding ? for optionals with compiler warnings

String *? maybeString = dict[@"key"];   /// Might be nil

/// How does optional chaining work?

/// Option A: Use ? like Swift
auto length = maybeString?.[length];    /// Returns int? (boxed optional int?)

/// Problem: What's the type of length? In Swift it's Int? but Swuft uses C ints
/// Do we need to box the result? That's expensive and awkward.

/// Option B: Just use nil checks (C-style)
int length = 0;
if (maybeString) {
    length = maybeString.[length];
}

/// Option C: Provide a default value operator
auto length = (maybeString ?: @"").[length];    /// GCC extension ?: already exists

/// Option D: Add a [length_or: default] style method
auto length = maybeString.[length_or: 0];

/// OBSERVATION: Optional chaining is tricky because Swuft mixes objects and
/// C primitives. Maybe just accept that you need explicit nil checks for
/// primitive results, and only support chaining for object results?

String *? desc = maybeObj?.[description];       /// Works, returns String *?
int length = maybeStr ? maybeStr.[length] : 0;  /// Must be explicit for primitives


// =============================================================================
// GAP 5: Operator overloading details
// =============================================================================

/// The notes discuss using ==, <, >, etc. for objects
/// But there are edge cases:

/// What about comparing object to nil?
if (obj == nil) { ... }     /// Should this call .[isEqual:] or pointer compare?

/// Probably pointer compare for nil specifically. But what about:
if (obj == NSNull.[null]) { ... }   /// isEqual: or pointer compare?

/// What about mixed types?
Number *n = @42;
if (n == 42) { ... }        /// Does this auto-box 42 and call isEqual:?
                             /// Or is this a compile error?

/// RECOMMENDATION: Keep == as pointer equality by default.
/// Add a separate operator for value equality, maybe ===
if (obj === other) { ... }   /// Calls [obj isEqual: other]
if (obj == other) { ... }    /// Pointer equality (fast)

/// Or follow Python: == is value equality (isEqual:), `is` for identity
if (obj == other) { ... }    /// Calls isEqual:
if (obj is other) { ... }    /// Pointer equality


// =============================================================================
// GAP 6: List comprehension edge cases
// =============================================================================

/// Basic comprehension:
auto squares = @[ @(auto)(i*i) for (int i = 0; i < 10; i++) ];

/// Nested comprehension - how does this work?
auto matrix = @[ @[ @(auto)(i*j) for (int j = 0; j < 3; j++) ]
                 for (int i = 0; i < 3; i++) ];

/// With condition:
auto evens = @[ @(auto)i for (int i = 0; i < 10; i++) if (i % 2 == 0) ];

/// Multiple for clauses (like Python's [(x,y) for x in xs for y in ys])?
/// This might make the grammar too complex.

/// OBSERVATION: Simple comprehensions are great. Nested ones get tricky.
/// Maybe limit to single loop + optional filter?


// =============================================================================
// GAP 7: Error handling
// =============================================================================

/// ObjC uses NSError ** out-parameters. How does Swuft handle this?

/// Option A: Keep NSError ** (current approach)
Error *err = nil;
auto data = Data.[contentsOfFile: @"/etc/passwd" error: &err];
if (err) {
    printf("Error: %s\n", err.[description].[UTF8String]);
    return;
}

/// Option B: Return tuple/struct (if we add multi-return)
struct { Data *data; Error *err; } = Data.[contentsOfFile: @"/etc/passwd"];

/// Option C: Result type (like Rust)
Result [Data *, Error *] result = Data.[contentsOfFile: @"/etc/passwd"];
if (result.[isErr]) {
    printf("Error: %s\n", result.[err].[description].[UTF8String]);
    return;
}
auto data = result.[ok];

/// OBSERVATION: NSError ** is ugly but well-understood and has tooling support.
/// Maybe just keep it and ensure the syntax isn't too painful?


// =============================================================================
// GAP 8: Protocol / interface syntax
// =============================================================================

/// How do you declare a protocol in Swuft?

/// Option A: @protocol keyword (like ObjC)
@protocol Printable {
    - String *description;
    - void [printTo: Stream *stream];
}

@class MyClass : Object <Printable> {
    ...
}

/// Option B: Just use @class with all methods unimplemented
/// (Protocols are just classes with no implementation)
@class @abstract Printable {
    - String *description;
    - void [printTo: Stream *stream];
}


// =============================================================================
// GAP 9: The "full smalltalk" ambiguity
// =============================================================================

/// In "full smalltalk" syntax:  obj method arg
/// Chaining: obj method1 method2
/// With args: obj [method1: arg1] method2

/// But what about this:
///     config get @"timeout" intValue
/// Does this mean:
///     (config get @"timeout") intValue     /// Two method calls
///     config [get: @"timeout" intValue: ???]  /// One method call with two args?

/// In real Smalltalk, unary messages bind tighter than keyword messages.
/// So: config get timeout intValue
///     = ((config get) timeout) intValue    /// Three unary messages
///
/// And: config [get: timeout] intValue
///     = (config [get: timeout]) intValue   /// Keyword then unary

/// This actually works! Unary messages (no colon) chain left-to-right.
/// Keyword messages (with colon) must be bracketed.

/// OBSERVATION: The full-smalltalk syntax could work with these rules:
/// 1. Unary messages (no args): obj msg1 msg2 msg3 = ((obj msg1) msg2) msg3
/// 2. Keyword messages (with args): must use brackets obj [key: val]
/// 3. Keywords in the middle: obj unary [key: val] unary2


// =============================================================================
// GAP 10: Module system / imports
// =============================================================================

/// The notes don't discuss modules/imports much.
/// ObjC uses #import (preprocessor). Swift has `import Module`.

/// Options:
/// 1. Keep #import (it works, tooling exists)
/// 2. Add a @import directive that's more semantic
/// 3. Build implicit modules like Swift

/// For cross-platform appeal (mentioned goal), probably need something
/// that works outside Apple's ecosystem.

#import <SwuftFoundation/Foundation.h>  /// Like ObjC
@import SwuftFoundation;                 /// Like Swift modules

/// Also: how do you mark things as public/private for modules?
/// ObjC relies on header files. If we want single-file modules...

@public @class MyPublicClass { ... }
@private @class MyInternalHelper { ... }

/// Or at module level:
@module MyModule {
    @export MyPublicClass;
    @export myPublicFunction;
}
