/// 03-python-features.m
/// Written by Claude (Opus 4.5) – exploring Python-inspired Swuft features
///
/// List comprehensions, defer, boxing, slicing, operators on objects

// =============================================================================
// LIST COMPREHENSIONS
// =============================================================================

/// Python
files = [f for f in os.listdir(dir) if f.endswith('.txt')]
squares = [x*x for x in range(10)]
pairs = [(x, y) for x in range(3) for y in range(3)]

/// Current Objective-C 2.0 (manual loops)
NSMutableArray *files = [NSMutableArray array];
for (NSString *f in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil]) {
    if ([f hasSuffix:@".txt"]) {
        [files addObject:f];
    }
}

NSMutableArray *squares = [NSMutableArray array];
for (int x = 0; x < 10; x++) {
    [squares addObject:@(x*x)];
}

/// Swuft 2.0 - List comprehension syntax: @[expr for (loop-header)]
auto files = @[f for (NSString *f in NSFileManager.[defaultManager].[contentsOfDirectoryAtPath: dir error: nil])
                 if (f.[hasSuffix: @".txt"])];

auto squares = @[@(x*x) for range(x, 10)];

/// Your syntax from the notes using while:
struct dirent *entry;
auto names = @[@(NSString *)entry->d_name while ((entry = readdir(dir)))];

/// Alternative: @() for array literal (to not collide with method brackets)
auto files = @(f for (NSString *f in dirContents) if (f.[hasSuffix: @".txt"]));
auto squares = @(@(x*x) for range(x, 10));


/// Swift (for comparison - uses map/filter)
let files = try FileManager.default.contentsOfDirectory(atPath: dir)
    .filter { $0.hasSuffix(".txt") }
let squares = (0..<10).map { $0 * $0 }


/// OBSERVATION: List comprehensions are genuinely more readable than map/filter
/// when the logic is simple. The Swuft syntax @[expr for ...] feels natural.


// =============================================================================
// DEFER (cleanup that runs at scope exit)
// =============================================================================

/// Current Objective-C 2.0 (no defer - must remember cleanup)
- (NSData *)readFile:(NSString *)path {
    int fd = open([path UTF8String], O_RDONLY);
    if (fd < 0) return nil;

    struct stat st;
    if (fstat(fd, &st) < 0) {
        close(fd);  // Must remember!
        return nil;
    }

    void *buf = malloc(st.st_size);
    if (!buf) {
        close(fd);  // Must remember again!
        return nil;
    }

    if (read(fd, buf, st.st_size) != st.st_size) {
        free(buf);   // Must remember!
        close(fd);   // Must remember!
        return nil;
    }

    close(fd);  // Finally
    NSData *data = [NSData dataWithBytesNoCopy:buf length:st.st_size freeWhenDone:YES];
    return data;
}


/// Swuft 2.0 with defer
- (NSData *)readFile:(NSString *)path {
    int fd = open(path.[UTF8String], O_RDONLY);
    if (fd < 0) return nil;
    defer close(fd);  // Always runs, no matter how we exit

    struct stat st;
    if (fstat(fd, &st) < 0) return nil;

    void *buf = malloc(st.st_size);
    if (!buf) return nil;
    defer if (!data) free(buf);  // Only free if we don't transfer ownership

    if (read(fd, buf, st.st_size) != st.st_size) return nil;

    NSData *data = NSData.[dataWithBytesNoCopy: buf length: st.st_size freeWhenDone: YES];
    return data;
}


/// Go (for comparison)
func readFile(path string) ([]byte, error) {
    fd, err := os.Open(path)
    if err != nil { return nil, err }
    defer fd.Close()
    // ...
}


/// Swift (for comparison - uses defer too, copied from Go/Swuft?)
func readFile(path: String) -> Data? {
    let fd = open(path, O_RDONLY)
    guard fd >= 0 else { return nil }
    defer { close(fd) }
    // ...
}


// =============================================================================
// BOXING AND UNBOXING
// =============================================================================

/// Current Objective-C 2.0
int x = 42;
NSNumber *boxed = @(x);              // Box int -> NSNumber
int unboxed = [boxed intValue];      // Unbox NSNumber -> int

char *cstr = "hello";
NSString *str = [NSString stringWithUTF8String:cstr];  // Different API
const char *back = [str UTF8String];

/// Swuft 2.0 - Unified @(type)value syntax for conversion
int x = 42;
auto boxed = @(auto)x;               // Box int -> NSNumber (auto-detect)
int unboxed = @(int)boxed;           // Unbox NSNumber -> int

char *cstr = "hello";
auto str = @(NSString *)cstr;        // Box C string -> NSString
char *back = @(char *)str;           // Unbox NSString -> C string

/// Boxing C arrays (from your notes)
int carray[5] = {1, 2, 3, 4, 5};
auto boxed_array = @(auto)carray;    // -> NSArray<NSNumber *> with 5 elements

/// Boxing heap buffer with count
int *heap_ints = get_heap_ints(&count);
auto arr = @(__count(count) __free auto)heap_ints;  // Box and free original

/// Python (for comparison - everything is already boxed)
x = 42  // It's just an int object
boxed = x  // Same thing


/// OBSERVATION: The unified @(type)value syntax is elegant.
/// @(int)obj and @(NSString *)cstr are symmetric.
/// The __count/__free modifiers for heap buffers are a bit ugly but practical.


// =============================================================================
// SLICING (Python-style subscript ranges)
// =============================================================================

/// Python
arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
arr[2:5]     # [2, 3, 4]
arr[::2]     # [0, 2, 4, 6, 8]
arr[-3:]     # [7, 8, 9]
arr[::-1]    # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

s = "hello world"
s[0:5]       # "hello"
s[-5:]       # "world"

/// Current Objective-C 2.0
NSArray *arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
[arr subarrayWithRange:NSMakeRange(2, 3)];  // [2, 3, 4]
// No built-in for stride or negative indices

/// Swuft 2.0 - Add Python-style slicing via __getitem__ protocol
auto arr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
arr[2:5];      // @[@2, @3, @4]
arr[::2];      // @[@0, @2, @4, @6, @8]
arr[-3:];      // @[@7, @8, @9]
arr[::-1];     // @[@9, @8, ... @0]

auto s = @"hello world";
s[0:5];        // @"hello"
s[-5:];        // @"world"

/// These would desugar to method calls:
arr[2:5]   ->  arr.[__sliceFrom: 2 to: 5 step: 1]
arr[::-1]  ->  arr.[__sliceFrom: NSNotFound to: NSNotFound step: -1]


/// OBSERVATION: Slicing is genuinely useful and very readable.
/// The : syntax inside [] is unambiguous since it's not valid C.
/// Implementation via protocol (__sliceFrom:to:step:) is clean.


// =============================================================================
// OPERATOR OVERLOADING ON OBJECTS
// =============================================================================

/// Python
"hello" + " world"       # "hello world"
[1, 2] + [3, 4]         # [1, 2, 3, 4]
obj1 == obj2            # calls obj1.__eq__(obj2)

/// Current Objective-C 2.0
[@"hello" stringByAppendingString:@" world"];
[@[@1, @2] arrayByAddingObjectsFromArray:@[@3, @4]];
[obj1 isEqual:obj2];

/// Swuft 2.0 Option A: Short method names (your earlier idea)
@"hello".append(@" world");  // or .cat() or .plus()
@[@1, @2].concat(@[@3, @4]);
obj1.eq(obj2);

/// Swuft 2.0 Option B: Operator overloading (your later preference)
@"hello" + @" world";        // Desugars to __add__ call or stringByAppendingString:
@[@1, @2] + @[@3, @4];       // Desugars to arrayByAddingObjectsFromArray:
obj1 == obj2;                // Desugars to isEqual:

/// The operators would be defined via protocol methods:
/// + -> __add__  or existing API method
/// == -> __eq__ or isEqual:
/// < -> __lt__ or compare: returning NSOrderedAscending


/// Swift (for comparison)
"hello" + " world"
[1, 2] + [3, 4]
obj1 == obj2  // Equatable protocol


/// OBSERVATION: Operator overloading feels right for the common ops.
/// == for isEqual: is especially valuable - it's such a common operation.
/// The question is: how far to go? Just == and +? Or full Python set?

/// Your point about pointer equality is good:
/// If == means isEqual:, then how do you check pointer equality?
/// Answer: Cast to void* first:
(void *)obj1 == (void *)obj2  // Pointer equality, as in C


// =============================================================================
// STRING INTERPOLATION
// =============================================================================

/// Python
name = "world"
f"hello {name}"

/// Current Objective-C 2.0
[NSString stringWithFormat:@"hello %@", name];

/// Swuft 2.0 Option A: f-string style (from your notes)
@f"hello %{name}";
@f"count: %{arr.[count]}";

/// Swuft 2.0 Option B: .format() method (no language change needed)
@"hello %@".format(name);
@"count: %@".format(arr.[count]);

/// Swift
"hello \(name)"

/// OBSERVATION: .format() is simpler (no syntax change) and Pythonic.
/// f-strings are nicer for complex expressions but add parser complexity.
/// For a "pragmatic" language, maybe .format() is enough?


// =============================================================================
// PUTTING IT TOGETHER: REALISTIC EXAMPLE
// =============================================================================

/// Task: Read a directory, filter to .txt files, read each, return dict of name->content

/// Python
def read_txt_files(dir_path):
    result = {}
    for f in os.listdir(dir_path):
        if f.endswith('.txt'):
            with open(os.path.join(dir_path, f)) as fp:
                result[f] = fp.read()
    return result

/// Current Objective-C 2.0
- (NSDictionary *)readTxtFilesInDirectory:(NSString *)dirPath {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *f in files) {
        if ([f hasSuffix:@".txt"]) {
            NSString *path = [dirPath stringByAppendingPathComponent:f];
            NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            if (content) {
                result[f] = content;
            }
        }
    }
    return result;
}

/// Swuft 2.0
- NSDictionary *readTxtFilesInDirectory: (NSString *dirPath) {
    auto result = NSMutableDictionary.[new];
    auto files = NSFileManager.[defaultManager].[contentsOfDirectoryAtPath: dirPath error: nil];

    for (NSString *f in files) {
        if (f.[hasSuffix: @".txt"]) {
            auto path = dirPath.[stringByAppendingPathComponent: f];
            auto content = NSString.[stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: nil];
            if (content)
                result[f] = content;
        }
    }
    return result;
}

/// Swuft 2.0 with comprehension (more Pythonic but maybe too clever?)
- NSDictionary *readTxtFilesInDirectory: (NSString *dirPath) {
    auto files = NSFileManager.[defaultManager].[contentsOfDirectoryAtPath: dirPath error: nil];
    auto txtFiles = @[f for (NSString *f in files) if (f.[hasSuffix: @".txt"])];

    return @{
        f: NSString.[stringWithContentsOfFile: dirPath.[stringByAppendingPathComponent: f]
                                     encoding: NSUTF8StringEncoding
                                        error: nil]
        for (NSString *f in txtFiles)
    };  // Dict comprehension!
}

/// OBSERVATION: The incremental improvements add up to something much cleaner.
/// Not as terse as Python, but much more readable than current objc.

