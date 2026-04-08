/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// Collections Rosetta Stone
/// Comparing the same operations across Swuft, ObjC, Swift, Python, Rust

// =============================================================================
// TASK: Filter a list of numbers, square them, sum the result
// =============================================================================

/// --- Swuft (dot-bracket syntax) ---

int sum_of_squared_evens_swuft(Array [Number *] *numbers) {

    /// List comprehension version
    auto squared = @[ @(auto)(n.[intValue] * n.[intValue])
                      for (Number *n in numbers)
                      if (n.[intValue] % 2 == 0) ];

    int sum = 0;
    for (Number *n in squared)
        sum += n.[intValue];
    return sum;

    /// Or with reduce (if we added it):
    /// return numbers
    ///     .[filter: ^(Number *n) { return n.[intValue] % 2 == 0; }]
    ///     .[map: ^(Number *n) { return @(auto)(n.[intValue] * n.[intValue]); }]
    ///     .[reduce: @0 with: ^(Number *acc, Number *n) { return @(auto)(acc.[intValue] + n.[intValue]); }]
    ///     .[intValue];
}

/// --- Swuft (full smalltalk syntax) ---

int sum_of_squared_evens_smalltalk(Array [Number *] *numbers) {

    auto squared = @[ @(auto)(n intValue * n intValue)
                      for (Number *n in numbers)
                      if (n intValue % 2 == 0) ];

    int sum = 0;
    for (Number *n in squared)
        sum += n intValue;
    return sum;
}


/// --- Original Objective-C ---

- (int)sumOfSquaredEvens:(NSArray<NSNumber *> *)numbers {

    NSMutableArray<NSNumber *> *squared = [NSMutableArray array];
    for (NSNumber *n in numbers) {
        if (n.intValue % 2 == 0) {
            [squared addObject:@(n.intValue * n.intValue)];
        }
    }

    int sum = 0;
    for (NSNumber *n in squared) {
        sum += n.intValue;
    }
    return sum;
}


/// --- Swift ---

func sumOfSquaredEvens(_ numbers: [Int]) -> Int {
    return numbers
        .filter { $0 % 2 == 0 }
        .map { $0 * $0 }
        .reduce(0, +)
}


/// --- Python ---

def sum_of_squared_evens(numbers):
    return sum(n * n for n in numbers if n % 2 == 0)


/// --- Rust ---

fn sum_of_squared_evens(numbers: &[i32]) -> i32 {
    numbers.iter()
        .filter(|n| *n % 2 == 0)
        .map(|n| n * n)
        .sum()
}


// =============================================================================
// TASK: Build a dictionary from a list of tuples
// =============================================================================

/// --- Swuft ---

Dictionary [String *, Number *] *build_dict_swuft() {

    /// Literal syntax
    auto dict = @{
        @"one": @1,
        @"two": @2,
        @"three": @3
    };

    /// From array of pairs (if we had tuple support)
    /// auto pairs = @( (@"one", @1), (@"two", @2), (@"three", @3) );
    /// auto dict = Dictionary.[fromPairs: pairs];

    /// Access
    Number *val = dict[@"two"];           /// subscript syntax (existing objc)
    Number *val2 = dict.[get: @"two"];    /// method syntax

    /// Mutation (Dictionary is mutable by default in this design)
    dict[@"four"] = @4;

    return dict;
}


/// --- Objective-C ---

- (NSDictionary<NSString *, NSNumber *> *)buildDict {

    NSDictionary *dict = @{
        @"one": @1,
        @"two": @2,
        @"three": @3
    };

    NSNumber *val = dict[@"two"];

    NSMutableDictionary *mutable = [dict mutableCopy];
    mutable[@"four"] = @4;

    return mutable;
}


/// --- Swift ---

func buildDict() -> [String: Int] {
    var dict = [
        "one": 1,
        "two": 2,
        "three": 3
    ]

    let val = dict["two"]
    dict["four"] = 4

    return dict
}


/// --- Python ---

def build_dict():
    d = {
        "one": 1,
        "two": 2,
        "three": 3
    }

    val = d["two"]
    d["four"] = 4

    return d


// =============================================================================
// TASK: String manipulation - join, split, format
// =============================================================================

/// --- Swuft ---

void string_ops_swuft() {

    /// Join
    auto words = @( @"hello", @"world", @"from", @"swuft" );
    auto joined = words.[joinedBy: @" "];                     /// "hello world from swuft"

    /// Split
    auto parts = @"one,two,three".[split: @","];              /// (@"one", @"two", @"three")

    /// Format
    auto name = @"World";
    auto greeting = @"Hello, %@!".[format: name];             /// "Hello, World!"

    /// Or with string interpolation (if added):
    /// auto greeting = @f"Hello, %{name}!";

    /// Substring (python-style slicing if added)
    auto str = @"Hello World";
    auto sub = str[0:5];                                      /// "Hello"
    auto sub2 = str[-5:];                                     /// "World"
}


/// --- Objective-C ---

- (void)stringOps {

    NSArray *words = @[@"hello", @"world", @"from", @"objc"];
    NSString *joined = [words componentsJoinedByString:@" "];

    NSArray *parts = [@"one,two,three" componentsSeparatedByString:@","];

    NSString *name = @"World";
    NSString *greeting = [NSString stringWithFormat:@"Hello, %@!", name];

    NSString *str = @"Hello World";
    NSString *sub = [str substringToIndex:5];
    NSString *sub2 = [str substringFromIndex:str.length - 5];
}


/// --- Swift ---

func stringOps() {

    let words = ["hello", "world", "from", "swift"]
    let joined = words.joined(separator: " ")

    let parts = "one,two,three".split(separator: ",")

    let name = "World"
    let greeting = "Hello, \(name)!"

    let str = "Hello World"
    let sub = String(str.prefix(5))
    let sub2 = String(str.suffix(5))
}


/// --- Python ---

def string_ops():

    words = ["hello", "world", "from", "python"]
    joined = " ".join(words)

    parts = "one,two,three".split(",")

    name = "World"
    greeting = f"Hello, {name}!"

    s = "Hello World"
    sub = s[:5]
    sub2 = s[-5:]
