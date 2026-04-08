/// Written by Claude (Opus 4.5) - revised after discussion with Noah
///
/// Revised Examples: Simpler Philosophy
///
/// Core principles:
///   1. Clean up ObjC syntax noise (dot-bracket, shorter names)
///   2. Add list comprehensions
///   3. Stay a strict C superset
///   4. Don't add safety mechanisms (no ?, no optionals, no new closure syntax)
///   5. == on objects desugars to isEqual: (cast to void* for pointer equality)

// =============================================================================
// Nil handling - just keep ObjC's behavior
// =============================================================================

/// ObjC's nil messaging is actually fine. Messages to nil return nil/0/NO.
/// No need for Swift's elaborate optional system.

void nil_handling() {

    String *maybeString = dict.[objectForKey: @"missing"];  /// nil

    /// This just works - nil messaging returns 0
    int len = maybeString.[length];     /// 0, not a crash

    /// Chaining also just works
    String *upper = maybeString.[uppercaseString];  /// nil

    /// Checking for nil is just C
    if (maybeString) {
        printf("Got: %s\n", maybeString.[UTF8String]);
    }

    /// No ?. or ?? operators needed. The language is simpler.
}


// =============================================================================
// Equality - == desugars to isEqual:
// =============================================================================

void equality() {

    String *a = @"hello";
    String *b = @"hello";
    String *c = a;

    /// Value equality (calls isEqual:)
    if (a == b) {
        printf("Equal values\n");       /// This prints
    }

    /// Pointer equality - cast to void*
    if ((void *)a == (void *)b) {
        printf("Same pointer\n");       /// May or may not print (string interning)
    }

    if ((void *)a == (void *)c) {
        printf("Same pointer\n");       /// This prints
    }

    /// This is explicit and obvious. No 'is' keyword needed.
    /// The cast makes it clear you're doing something lower-level.
}


// =============================================================================
// Blocks - just C function pointer syntax, prefer comprehensions
// =============================================================================

void blocks_and_comprehensions() {

    Array [Number *] *numbers = @( @1, @2, @3, @4, @5 );

    /// PREFER: List comprehension
    auto doubled = @[ @(auto)(n.[intValue] * 2) for (Number *n in numbers) ];
    auto evens = @[ n for (Number *n in numbers) if (n.[intValue] % 2 == 0) ];

    /// PREFER: Simple loops for complex logic
    auto results = Array.[new];
    for (Number *n in numbers) {
        int val = n.[intValue];
        if (val > 2 && val < 5) {
            results.[add: @(auto)(val * val)];
        }
    }

    /// Blocks exist but are just for callbacks/dispatch, not everyday transforms
    dispatch_async(queue, ^{
        printf("Background work\n");
    });

    /// If you must use map, blocks work - they're just C syntax
    auto mapped = numbers.[map: ^id(Number *n) {
        return @(auto)(n.[intValue] * 2);
    }];

    /// But the comprehension is cleaner for this case
}


// =============================================================================
// Revised complete example - simpler, no new features
// =============================================================================

/// Parse /etc/passwd - showing the simple, pragmatic style

Array [Dictionary *] *parse_passwd() {

    String *contents = String.[contentsOfFile: @"/etc/passwd"];
    if (!contents) return Array.[new];

    auto lines = contents.[componentsSeparatedByString: @"\n"];
    /// ^ Could use shorter name like [split:] but keeping Apple's name works too

    auto result = Array.[new];

    for (String *line in lines) {
        if (line.[length] == 0) continue;

        auto parts = line.[componentsSeparatedByString: @":"];
        if (parts.[count] < 7) continue;

        /// Dictionary literal - clean and simple
        auto entry = @{
            @"username": parts[0],
            @"uid":      @(auto)(parts[2].[intValue]),
            @"gid":      @(auto)(parts[3].[intValue]),
            @"home":     parts[5],
            @"shell":    parts[6]
        };

        result.[add: entry];
    }

    return result;
}


// =============================================================================
// Unix scripting - the killer use case
// =============================================================================

#include <dirent.h>
#include <sys/stat.h>

int main() {

    /// Call C APIs directly, box results into ARC'd collections
    DIR *dir = opendir("/etc");
    if (!dir) return 1;
    defer closedir(dir);

    struct dirent *entry;

    /// List comprehension over C iteration - this is the magic
    auto files = @[ @(String *)entry->d_name
                    while ((entry = readdir(dir)))
                    if (entry->d_name[0] != '.') ];

    /// Now we have an ARC'd array of strings from raw C APIs
    printf("Found %d files\n", (int)files.[count]);

    /// Filter further with another comprehension
    auto configs = @[ f for (String *f in files) if (f.[hasSuffix: @".conf"]) ];

    /// Build JSON output
    auto output = @{
        @"path": @"/etc",
        @"count": @(auto)(files.[count]),
        @"configs": configs
    };

    printf("%s\n", output.[toJSONString].[UTF8String]);

    return 0;
}


// =============================================================================
// What we DON'T add (keeping it simple)
// =============================================================================

/*
NOT adding:
- Optional types (String?)           -> nil messaging already works
- Optional chaining (?.)             -> nil messaging already works
- Guard/if-let                       -> just use if (x) { }
- New closure syntax (|x| ...)       -> use comprehensions or loops
- Result<T, E> types                 -> use NSError** or just return nil
- Pattern matching                   -> use if/switch
- Async/await                        -> use GCD blocks

The goal is a SMALL delta from ObjC that makes it pleasant to write.
Not a new language with new paradigms to learn.

Someone who knows ObjC can read and write Swuft immediately.
The syntax is cleaner but the semantics are identical.
*/


// =============================================================================
// Side-by-side: ObjC vs Swuft (minimal changes, big readability win)
// =============================================================================

/// ObjC
- (NSArray *)filterAndTransform:(NSArray<NSNumber *> *)numbers {
    NSMutableArray *result = [NSMutableArray array];
    for (NSNumber *n in numbers) {
        if (n.intValue % 2 == 0) {
            [result addObject:@(n.intValue * n.intValue)];
        }
    }
    return result;
}

/// Swuft - same semantics, cleaner syntax
- Array *[filterAndTransform: Array [Number *] *numbers] {
    return @[ @(auto)(n.[intValue] * n.[intValue])
              for (Number *n in numbers)
              if (n.[intValue] % 2 == 0) ];
}

/// The Swuft version:
/// - Dot-bracket instead of nested brackets
/// - List comprehension instead of manual loop
/// - @(auto) for boxing instead of @()
/// - No NS prefix on types
///
/// But it's the SAME language semantically. Same runtime. Same ARC.
/// Just nicer to read and write.
