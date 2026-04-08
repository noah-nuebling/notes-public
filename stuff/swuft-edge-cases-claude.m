/// Written by Claude (Opus 4.5) - April 2026
/// Edge cases and stress tests for Swuft syntax design
/// Testing where the proposed syntax might break down or create ambiguities

// =============================================================================
// MARK: - Edge Case 1: Dot-Bracket vs C Struct Access
// =============================================================================

/*
Question: Does `obj.[foo]` ever conflict with C syntax?

C uses `.` for struct member access:  `myStruct.field`
C uses `->` for pointer member access: `myStructPtr->field`

Swuft proposes: `obj.[method]` for message send

Potential collision?
*/

// Example: A struct that happens to have an array member
struct CStruct {
    int values[10];      // C array member
    int *ptr;
};

void testStructAccess() {
    struct CStruct s;
    struct CStruct *sp = &s;

    // C syntax (unchanged in Swuft):
    int x = s.values[0];      // array subscript on struct member
    int y = sp->values[0];    // array subscript via pointer

    // Swuft syntax (new):
    NSArray *arr = NSArray.[new];
    id z = arr.[objectAtIndex: 0];

    // No collision! Because:
    // - `s.values[0]` - `s` is a struct, `.values` is member access, `[0]` is C subscript
    // - `arr.[objectAtIndex: 0]` - `arr` is an object, `.[` starts a method call
    //
    // The parser can distinguish because:
    // 1. Type of LHS: struct vs object pointer
    // 2. The `.[` token sequence vs `. ` then `identifier` then `[`
    //
    // Verdict: NO COLLISION - the `.[` is unambiguous
}


// =============================================================================
// MARK: - Edge Case 2: Full Smalltalk Syntax Ambiguities
// =============================================================================

/*
The "full smalltalk" syntax: `obj method` for no-arg calls, `obj [method: arg]` for calls with args

This is beautiful but has potential issues:
*/

void testSmalltalkAmbiguity() {

    // PROBLEM 1: What if method name looks like a C identifier being used?

    NSArray *arr = NSArray new;        // OK: sends `new` message
    int count = arr count;              // OK: sends `count` message

    // But what about:
    int x = 5;
    int count = 10;                     // `count` is a local variable
    // How do we distinguish `arr count` (message send) from `arr count` (two expressions)?
    // In C, `arr count` would be a syntax error (two expressions not separated by anything)
    // So the parser can assume: if it parses, it's a message send

    // PROBLEM 2: What about this?
    NSNumber *n = @5;
    NSNumber *m = @10;
    int result = n intValue + m intValue;  // Is this (n intValue) + (m intValue)?
                                            // Or n [intValue: +] [m: intValue]? (nonsense but parser doesn't know)

    // SOLUTION: Operator tokens like `+` terminate the message send
    // So `n intValue + m intValue` parses as `(n intValue) + (m intValue)`
    // This matches Smalltalk's actual precedence rules

    // PROBLEM 3: Nested unary messages
    NSString *s = obj description lowercaseString;
    // Parses left-to-right as: ((obj description) lowercaseString)
    // This is correct! Unary messages chain naturally.

    // PROBLEM 4: What about this monstrosity?
    // id result = obj foo bar baz qux;
    // Is this: ((((obj foo) bar) baz) qux)  ?
    // Yes! Unary messages associate left-to-right.
    // But is this readable? Debatable. At least it's unambiguous.

    // PROBLEM 5: Keyword messages vs unary messages
    // obj [foo: x] bar [baz: y] qux
    // Parses as: ((((obj [foo: x]) bar) [baz: y]) qux)
    // This works! Keyword messages and unary messages can interleave.

    // VERDICT: Full smalltalk syntax IS unambiguous, but might be confusing
    // for complex chains. The dot-bracket syntax is probably clearer.
}


// =============================================================================
// MARK: - Edge Case 3: Operator Overloading Conflicts
// =============================================================================

/*
Proposed: `a == b` desugars to `a.[isEqual: b]` for objects
But C already has `==` for pointer comparison!
*/

void testOperatorOverloading() {
    NSString *a = @"hello";
    NSString *b = @"hello";
    NSString *c = a;

    // Current ObjC:
    BOOL same_pointer = (a == c);           // YES - same pointer
    BOOL same_pointer2 = (a == b);          // MAYBE - depends on string interning
    BOOL same_content = [a isEqual: b];     // YES - same content

    // If we overload == for objects:
    // BOOL equal = (a == b);  // Would this be isEqual: or pointer comparison?

    // OPTION 1: Always use isEqual: for objects
    // Problem: Breaks existing code that relies on pointer comparison
    // Problem: How do you do pointer comparison when you need it?

    // OPTION 2: Use different operator, e.g., `===` for isEqual:
    BOOL equal = (a === b);       // isEqual:
    BOOL same_ptr = (a == b);     // pointer comparison (unchanged)
    // Problem: Inconsistent with how other languages use ===

    // OPTION 3: Keep == as pointer comparison, use method for equality
    BOOL equal = a.[eq: b];       // explicit method call
    BOOL same_ptr = (a == b);     // unchanged
    // This is the safest but least "Pythonic"

    // OPTION 4: New `@==` operator for object equality (from original notes)
    BOOL equal = (a @== b);       // isEqual:
    // Problem: Looks weird. "@==" looks like a fish.

    // RECOMMENDATION: Go with Option 3 (keep == unchanged, use .eq method)
    // Changing == semantics is too breaking and confusing.
}


// =============================================================================
// MARK: - Edge Case 4: List Comprehension Parsing
// =============================================================================

/*
Proposed: @[ expr for (x in xs) if (cond) ]

What are the edge cases?
*/

void testListComprehensionParsing() {

    NSArray *numbers = @[@1, @2, @3, @4, @5];

    // Basic - OK
    auto evens = @[ n for (NSNumber *n in numbers) if (n.[intValue] % 2 == 0) ];

    // Nested expression - OK?
    auto doubled = @[ @(n.[intValue] * 2) for (NSNumber *n in numbers) ];

    // Multiple conditions - how to express?
    auto filtered = @[ n for (NSNumber *n in numbers) if (n.[intValue] > 2) if (n.[intValue] < 5) ];
    // Or should it be:
    auto filtered2 = @[ n for (NSNumber *n in numbers) if (n.[intValue] > 2 && n.[intValue] < 5) ];
    // Recommendation: Just use `&&`, don't allow multiple `if` clauses

    // Nested loops - should this be supported?
    NSArray *matrix = @[@[@1, @2], @[@3, @4]];
    // Python: [x for row in matrix for x in row]
    // Swuft: @[ x for (NSArray *row in matrix) for (NSNumber *x in row) ] ?
    // This is getting complex. Maybe don't support nested comprehensions?

    // EDGE CASE: What if expression contains `for` keyword?
    // @[ search(query, for: options) for (id query in queries) ]
    //    ^^^ this `for:` is a selector, not comprehension syntax!
    // Parser needs to handle this. The `for (` with opening paren distinguishes
    // the comprehension `for` from selector `for:`.

    // EDGE CASE: What if expression contains `if` keyword?
    // @[ checkValid(x, if: cond) for (id x in xs) ]
    //    ^^^ this `if:` is a selector, not comprehension syntax!
    // Same solution: the `if (` with opening paren distinguishes.

    // EDGE CASE: Empty comprehension result type
    auto empty = @[ x for (id x in @[]) ];
    // What is the type of `empty`? NSArray<id> *?
    // With `auto`, this should be inferred from context.

    // VERDICT: List comprehensions work but should be kept simple.
    // - Don't support multiple `for` clauses (nested loops)
    // - Don't support multiple `if` clauses (use &&)
    // - The `for (` and `if (` patterns are unambiguous
}


// =============================================================================
// MARK: - Edge Case 5: defer Semantics
// =============================================================================

/*
`defer` is proposed but details are unclear.
Questions:
- Does defer capture variables by value or reference?
- What happens with multiple defers?
- What about exceptions/early returns?
*/

void testDeferSemantics() {

    // Basic defer
    FILE *f = fopen("test.txt", "r");
    defer fclose(f);  // Or is it `defer { fclose(f); }` ?

    // Multiple defers - LIFO order (like Go)
    int x = 0;
    defer printf("a: %d\n", x);  // prints last
    defer printf("b: %d\n", x);  // prints second
    defer printf("c: %d\n", x);  // prints first
    x = 100;
    // Output: c: 100, b: 100, a: 100  (if by reference)
    // Or:     c: 0, b: 0, a: 0        (if by value at defer site)

    // QUESTION: Capture semantics?
    // Go captures by reference (deferred func sees final value)
    // Swift's defer also captures by reference
    // RECOMMENDATION: Capture by reference (more useful, matches Go/Swift)

    // Early return
    NSData *loadFile(NSString *path) {
        FILE *f = fopen(path.[UTF8String], "r");
        if (!f) return nil;  // defer hasn't run yet? Or has it?
        defer fclose(f);

        // ... read file ...
        if (error) return nil;  // defer runs here

        return data;  // defer runs here too
    }
    // RECOMMENDATION: defer runs on ANY scope exit, including early returns

    // Exceptions / ObjC exceptions
    @try {
        FILE *f = fopen("test.txt", "r");
        defer fclose(f);
        @throw NSException new;
    }
    // Does defer run? It should!
    // RECOMMENDATION: defer should run even on exception
    // (This is complex to implement but necessary for correctness)

    // VERDICT: defer should work like Go/Swift:
    // - Capture by reference
    // - LIFO order for multiple defers
    // - Runs on any scope exit (return, exception, fall-through)
}


// =============================================================================
// MARK: - Edge Case 6: Generics Syntax Conflict
// =============================================================================

/*
Current ObjC: NSArray<NSString *> *
Proposed:     Array [String *] *     (from the notes)

But `[` is used for method calls! Conflict?
*/

void testGenericsSyntax() {

    // Proposed:
    Array [String *] *strings;
    strings.[addObject: @"hello"];  // method call

    // Is `Array [String *]` parsed as:
    //   A) Type: Array with generic parameter String *
    //   B) Message send: [Array String:*] (nonsense but syntactically?)

    // Answer: It must be context-dependent.
    // In a type position (after auto, as param type, etc.), `[` starts generics
    // After an expression, `.[` starts a method call

    // But what about this?
    Array [String *] *foo = Array [String *].[new];
    //    ^^^^^^^^^^                ^^^^^^^^^^
    //    generic type              also generic type, followed by .[new] method call

    // This is getting visually noisy.

    // ALTERNATIVE: Keep angle brackets
    NSArray<NSString *> *strings = NSArray<NSString *>.[new];

    // This is clearer because <> is only ever used for generics, never for anything else.

    // ANOTHER ALTERNATIVE: Type inference makes explicit generics rare
    auto strings = @[@"a", @"b", @"c"];  // inferred as NSArray<NSString *> *

    // VERDICT: Probably stick with angle brackets for generics.
    // The `[` for generics creates visual confusion with method calls.
}


// =============================================================================
// MARK: - Edge Case 7: Blocks/Closures in Method Calls
// =============================================================================

/*
ObjC blocks are verbose. How do they look in Swuft?
*/

void testBlockSyntax() {

    NSArray *numbers = @[@3, @1, @4, @1, @5];

    // Current ObjC - very verbose
    NSArray *sorted_objc = [numbers sortedArrayUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return [a compare:b];
    }];

    // Swuft dot-bracket - still verbose
    auto sorted_swuft = numbers.[sortedArrayUsingComparator: ^NSComparisonResult(NSNumber *a, NSNumber *b) {
        return a.[compare: b];
    }];

    // Could we have lighter syntax? Some ideas:

    // IDEA 1: Arrow syntax (like Swift/JS)
    auto sorted1 = numbers.[sortedArrayUsingComparator: (a, b) => a.[compare: b]];
    // Problem: Conflicts with nothing in C, could work!
    // Need to specify: how do you add types? (NSNumber *a, NSNumber *b) => ...

    // IDEA 2: Pipe syntax for simple transforms
    auto sorted2 = numbers | sort;  // using a function/block reference
    auto doubled = numbers | map({ n => n * 2 });
    // Problem: `|` is bitwise OR in C. Would need different operator.

    // IDEA 3: Trailing closure syntax (like Swift)
    auto sorted3 = numbers.[sortedArrayUsingComparator:] { a, b in
        a.[compare: b]
    };
    // Problem: This diverges significantly from C/ObjC syntax

    // IDEA 4: Just use shorter block syntax with type inference
    auto sorted4 = numbers.[sortedArrayUsingComparator: ^(a, b) { a.[compare: b] }];
    // If types can be inferred from the method signature, omit them
    // If return type is single expression, omit `return`

    // RECOMMENDATION: Idea 4 is the most conservative.
    // Allow type inference in blocks, allow implicit return for single expressions.
    // This is a small delta from current ObjC.

    // Example with full syntax vs inferred:
    // Full:
    numbers.[enumerateObjectsUsingBlock: ^void(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@", obj);
    }];
    // Inferred:
    numbers.[enumerateObjectsUsingBlock: ^(obj, idx, stop) {
        NSLog(@"%@", obj);
    }];
    // Even shorter if single expression (no braces needed?):
    numbers.[enumerateObjectsUsingBlock: ^(obj, idx, stop) NSLog(@"%@", obj)];
}


// =============================================================================
// MARK: - Edge Case 8: Property Access vs Method Call
// =============================================================================

/*
ObjC 2.0 introduced dot syntax for properties: obj.property
But Swuft uses .[] for methods.
How do properties work?
*/

void testPropertyAccess() {

    @interface Person : NSObject
    @property NSString *name;
    @property NSInteger age;
    @end

    Person *p = Person.[new];

    // OPTION 1: Properties use plain dot, methods use dot-bracket
    p.name = @"Alice";           // property setter
    NSString *n = p.name;        // property getter
    NSString *d = p.[description]; // method call

    // This is consistent with ObjC 2.0 and clear.
    // Properties: obj.prop
    // Methods: obj.[method] or obj.[method: arg]

    // POTENTIAL CONFUSION: Is `p.name` a property or an ivar?
    // In ObjC, properties generate getter/setter methods.
    // `p.name` calls `[p name]` under the hood.
    // So `p.name` is really just sugar for `p.[name]`.

    // Should we allow both?
    p.name;       // property access (sugar)
    p.[name];     // explicit method call (same effect)

    // RECOMMENDATION: Yes, allow both. They're equivalent.
    // Use `p.name` for simple accessors (reads like a field)
    // Use `p.[name]` when you want to emphasize it's a method call

    // But what about computed properties that take time?
    // NSArray *results = search.results;  // This might be expensive!
    // The dot syntax makes it look cheap.
    // This is a general problem with property syntax, not Swuft-specific.

    // VERDICT: Keep ObjC 2.0 property dot syntax for simple accessors.
    // Use .[] for all other methods. They can be mixed in chains:
    // p.name.[lowercaseString].[componentsSeparatedByString: @" "]
}


// =============================================================================
// MARK: - Edge Case 9: nil/NULL Handling
// =============================================================================

/*
ObjC's nil messaging (sending message to nil returns nil/0) is unique.
How does this interact with Swuft features?
*/

void testNilHandling() {

    NSString *s = nil;

    // Current ObjC - nil messaging returns nil/0
    NSUInteger len = [s length];  // len = 0, no crash
    NSString *upper = [s uppercaseString];  // upper = nil, no crash

    // Swuft dot-bracket - should work the same
    NSUInteger len2 = s.[length];  // should be 0
    NSString *upper2 = s.[uppercaseString];  // should be nil

    // List comprehension with nil?
    NSArray *maybeNil = nil;
    auto result = @[ x for (id x in maybeNil) ];  // What happens?
    // In ObjC, `for (id x in nil)` just doesn't iterate (0 iterations)
    // So result should be empty array @[]
    // This is correct and useful behavior.

    // What about optional chaining?
    NSDictionary *dict = nil;
    // dict?[@"key"]?[@"nested"]
    // With nil dict, the whole chain should return nil.
    // This is standard optional chaining behavior.

    // Operator overloading with nil?
    NSString *a = @"hello";
    NSString *b = nil;
    // If == is overloaded to call isEqual:
    // BOOL eq = (a == b);  // [a isEqual: nil] returns NO
    // This is correct!

    // But what about:
    // BOOL eq2 = (b == a);  // [nil isEqual: a] returns... NO (nil messaging)
    // This is also correct but might be surprising.

    // VERDICT: Keep ObjC's nil messaging semantics. They're useful.
    // Just need to document that operators on nil follow message send rules.
}


// =============================================================================
// MARK: - Edge Case 10: C Preprocessor Interaction
// =============================================================================

/*
Swuft is a C superset, so the preprocessor still exists.
How do macros interact with new syntax?
*/

void testPreprocessorInteraction() {

    // Define a macro that uses ObjC syntax
    #define SAFE_CALL(obj, method) ((obj) ? [obj method] : nil)

    // In Swuft, should this be:
    #define SAFE_CALL_SWUFT(obj, method) ((obj) ? (obj).[method] : nil)

    // Problem: Macro expansion happens before parsing
    // So `obj.[method]` in a macro is just text substitution
    // This should work fine.

    // But what about:
    #define LOG_CALL(obj, sel) NSLog(@"%@", obj.[sel])
    // LOG_CALL(myArray, count)
    // Expands to: NSLog(@"%@", myArray.[count])
    // This works!

    // Problem case - method with arguments:
    #define CALL_WITH_ARG(obj, sel, arg) obj.[sel: arg]
    // CALL_WITH_ARG(dict, objectForKey, @"key")
    // Expands to: dict.[objectForKey: @"key"]
    // This works!

    // But multi-arg methods are tricky:
    #define CALL_TWO_ARGS(obj, s1, a1, s2, a2) obj.[s1: a1 s2: a2]
    // This is getting ugly. Variadic macros might help:
    #define CALL_METHOD(obj, ...) obj.[__VA_ARGS__]
    // CALL_METHOD(dict, setObject: @"val" forKey: @"key")
    // Expands to: dict.[setObject: @"val" forKey: @"key"]
    // This actually works quite nicely!

    // VERDICT: Preprocessor macros work fine with Swuft syntax.
    // Variadic macros are particularly useful for wrapping method calls.
}


// =============================================================================
// MARK: - Summary of Recommendations
// =============================================================================

/*

Based on these edge cases, here are recommendations for Swuft:

1. **Method Syntax**: Use dot-bracket `obj.[method]` - it's unambiguous and readable.
   The "full smalltalk" syntax is elegant but may confuse C developers.

2. **Operators**: Don't overload == for isEqual:. Keep == as pointer comparison.
   Use explicit `.eq:` method or add a new operator like `===` if needed.

3. **Generics**: Keep angle brackets `NSArray<NSString *>` - less confusion with `[]`.

4. **List Comprehensions**: Keep them simple.
   - Single `for` clause
   - Single `if` clause (use && for multiple conditions)
   - `for (` and `if (` disambiguate from selectors

5. **defer**: Follow Go/Swift semantics:
   - Capture by reference
   - LIFO order
   - Runs on all scope exits including exceptions

6. **Blocks**: Allow type inference and implicit return for single expressions.
   Don't introduce radically new closure syntax - incremental improvement is better.

7. **Properties**: Keep ObjC 2.0 dot syntax for properties.
   Allow both `obj.prop` and `obj.[prop]` - they're equivalent.

8. **nil**: Keep ObjC's nil messaging semantics. Document how operators interact with nil.

9. **Preprocessor**: Works fine with new syntax. Variadic macros are useful.

10. **Philosophy**: Swuft should be conservative. Small syntax changes that don't break
    existing code or mental models. The goal is to make ObjC more pleasant to write,
    not to create a new language.

*/

