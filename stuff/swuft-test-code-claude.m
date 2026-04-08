/// Written by Claude (Opus 4.5) - April 2026
/// Test code exploring the "Swuft" / objc3 language design from "Idea – objc3 aka Swuft.m"
///
/// This file contains side-by-side comparisons of the same code in:
///   - Current Objective-C (compiles today)
///   - Swuft "dot-bracket" syntax
///   - Swuft "full smalltalk" syntax
///   - Python (for reference)
///   - Swift (for reference)
///   - Rust (for reference)

// =============================================================================
// MARK: - Example 1: Simple Collection Operations
// =============================================================================

/// Task: Filter a list of numbers, keep evens, double them, sum the result

// --- Current ObjC ---
- (NSInteger)processNumbers_objc:(NSArray<NSNumber *> *)numbers {
    NSInteger sum = 0;
    for (NSNumber *n in numbers) {
        if (n.integerValue % 2 == 0) {
            sum += n.integerValue * 2;
        }
    }
    return sum;
}

// --- Swuft Dot-Bracket ---
- (NSInteger)processNumbers_dotbracket:(NSArray<NSNumber *> *)numbers {
    NSInteger sum = 0;
    for (NSNumber *n in numbers) {
        if (n.[integerValue] % 2 == 0) {
            sum += n.[integerValue] * 2;
        }
    }
    return sum;
}

// With list comprehension:
- (NSInteger)processNumbers_dotbracket_v2:(NSArray<NSNumber *> *)numbers {
    auto evensDoubled = @[ @(n.[integerValue] * 2) for (NSNumber *n in numbers) if (n.[integerValue] % 2 == 0) ];
    NSInteger sum = 0;
    for (NSNumber *n in evensDoubled) sum += n.[integerValue];
    return sum;
    // Or with a hypothetical reduce:
    // return evensDoubled.[reduce: 0 with: ^(NSInteger acc, NSNumber *n) { return acc + n.[integerValue]; }];
}

// --- Swuft Full Smalltalk ---
- (NSInteger)processNumbers_smalltalk:(NSArray<NSNumber *> *)numbers {
    NSInteger sum = 0;
    for (NSNumber *n in numbers) {
        if (n integerValue % 2 == 0) {
            sum += n integerValue * 2;
        }
    }
    return sum;
}

// --- Python ---
/*
def process_numbers(numbers):
    return sum(n * 2 for n in numbers if n % 2 == 0)
*/

// --- Swift ---
/*
func processNumbers(_ numbers: [Int]) -> Int {
    numbers.filter { $0 % 2 == 0 }.map { $0 * 2 }.reduce(0, +)
}
*/

// --- Rust ---
/*
fn process_numbers(numbers: &[i32]) -> i32 {
    numbers.iter().filter(|n| *n % 2 == 0).map(|n| n * 2).sum()
}
*/


// =============================================================================
// MARK: - Example 2: JSON-like Data Construction
// =============================================================================

/// Task: Build a nested data structure representing a user

// --- Current ObjC ---
- (NSDictionary *)buildUser_objc {
    return @{
        @"name": @"Alice",
        @"age": @30,
        @"address": @{
            @"street": @"123 Main St",
            @"city": @"Springfield",
            @"zip": @12345
        },
        @"tags": @[@"admin", @"verified", @"premium"]
    };
}

// --- Swuft Dot-Bracket ---
// (Same as ObjC - literals don't change)
- (NSDictionary *)buildUser_dotbracket {
    return @{
        @"name": @"Alice",
        @"age": @30,
        @"address": @{
            @"street": @"123 Main St",
            @"city": @"Springfield",
            @"zip": @12345
        },
        @"tags": @[@"admin", @"verified", @"premium"]
    };
}

// --- Swuft with proposed @() tuple/array syntax ---
- (NSDictionary *)buildUser_swuft_tuple {
    // Using @() for arrays (matches old plist style per Apr 2026 notes)
    return @{
        @"name": @"Alice",
        @"age": @30,
        @"address": @{
            @"street": @"123 Main St",
            @"city": @"Springfield",
            @"zip": @12345
        },
        @"tags": @(@"admin", @"verified", @"premium")  // <-- @() instead of @[]
    };
}

// --- Python ---
/*
def build_user():
    return {
        "name": "Alice",
        "age": 30,
        "address": {
            "street": "123 Main St",
            "city": "Springfield",
            "zip": 12345
        },
        "tags": ["admin", "verified", "premium"]
    }
*/

// --- Swift ---
/*
func buildUser() -> [String: Any] {
    [
        "name": "Alice",
        "age": 30,
        "address": [
            "street": "123 Main St",
            "city": "Springfield",
            "zip": 12345
        ],
        "tags": ["admin", "verified", "premium"]
    ]
}
*/


// =============================================================================
// MARK: - Example 3: Method Chaining
// =============================================================================

/// Task: Process a string - trim, lowercase, replace, split

// --- Current ObjC ---
- (NSArray<NSString *> *)processString_objc:(NSString *)input {
    NSString *trimmed = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lowered = [trimmed lowercaseString];
    NSString *replaced = [lowered stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSArray *parts = [replaced componentsSeparatedByString:@"_"];
    return parts;
}

// One-liner (the nesting hell):
- (NSArray<NSString *> *)processString_objc_oneline:(NSString *)input {
    return [[[[input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"] componentsSeparatedByString:@"_"];
}

// --- Swuft Dot-Bracket ---
- (NSArray<NSString *> *)processString_dotbracket:(NSString *)input {
    return input
        .[stringByTrimmingCharactersInSet: NSCharacterSet.[whitespaceCharacterSet]]
        .[lowercaseString]
        .[stringByReplacingOccurrencesOfString: @"-" withString: @"_"]
        .[componentsSeparatedByString: @"_"];
}

// --- Swuft Full Smalltalk ---
- (NSArray<NSString *> *)processString_smalltalk:(NSString *)input {
    return input
        [stringByTrimmingCharactersInSet: NSCharacterSet whitespaceCharacterSet]
        lowercaseString
        [stringByReplacingOccurrencesOfString: @"-" withString: @"_"]
        [componentsSeparatedByString: @"_"];
}

// --- Python ---
/*
def process_string(s):
    return s.strip().lower().replace("-", "_").split("_")
*/

// --- Swift ---
/*
func processString(_ input: String) -> [String] {
    input.trimmingCharacters(in: .whitespaces)
         .lowercased()
         .replacingOccurrences(of: "-", with: "_")
         .components(separatedBy: "_")
}
*/

// --- Rust ---
/*
fn process_string(input: &str) -> Vec<&str> {
    input.trim().to_lowercase().replace("-", "_").split("_").collect()
}
*/


// =============================================================================
// MARK: - Example 4: Error Handling with Optional Chaining
// =============================================================================

/// Task: Safely get a nested value from a dictionary

// --- Current ObjC ---
- (NSString *)getNestedValue_objc:(NSDictionary *)dict {
    NSDictionary *user = dict[@"user"];
    if (!user) return nil;
    NSDictionary *profile = user[@"profile"];
    if (!profile) return nil;
    NSString *name = profile[@"name"];
    return name;
}

// --- Swuft Dot-Bracket (with hypothetical ?. operator) ---
- (NSString *)getNestedValue_dotbracket:(NSDictionary *)dict {
    // If we add optional chaining like Swift:
    return dict[@"user"]?[@"profile"]?[@"name"];
    // Or with methods:
    // return dict.[objectForKey: @"user"]?.[objectForKey: @"profile"]?.[objectForKey: @"name"];
}

// --- Python ---
/*
def get_nested_value(d):
    return d.get("user", {}).get("profile", {}).get("name")
*/

// --- Swift ---
/*
func getNestedValue(_ dict: [String: Any]) -> String? {
    (dict["user"] as? [String: Any])?["profile"] as? [String: Any])?["name"] as? String
}
*/


// =============================================================================
// MARK: - Example 5: Async/Concurrent Code
// =============================================================================

/// Task: Fetch data from multiple URLs concurrently

// --- Current ObjC (with dispatch groups) ---
- (void)fetchAll_objc:(NSArray<NSURL *> *)urls completion:(void(^)(NSArray *))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:urls.count];
    for (NSUInteger i = 0; i < urls.count; i++) {
        [results addObject:[NSNull null]];
    }

    [urls enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(group);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @synchronized(results) {
                results[idx] = data ?: [NSNull null];
            }
            dispatch_group_leave(group);
        }];
        [task resume];
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(results);
    });
}

// --- Swuft Dot-Bracket ---
- (void)fetchAll_dotbracket:(NSArray<NSURL *> *)urls completion:(void(^)(NSArray *))completion {
    auto group = dispatch_group_create();
    auto results = NSMutableArray.[arrayWithCapacity: urls.[count]];
    for (NSUInteger i = 0; i < urls.[count]; i++) {
        results.[addObject: NSNull.[null]];
    }

    urls.[enumerateObjectsUsingBlock: ^(NSURL *url, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(group);
        auto task = NSURLSession.[sharedSession].[dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            @synchronized(results) {
                results[idx] = data ?: NSNull.[null];
            }
            dispatch_group_leave(group);
        }];
        task.[resume];
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(results);
    });
}

// --- Python (asyncio) ---
/*
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [session.get(url) for url in urls]
        return await asyncio.gather(*tasks)
*/

// --- Swift (async/await) ---
/*
func fetchAll(_ urls: [URL]) async throws -> [Data] {
    try await withThrowingTaskGroup(of: (Int, Data).self) { group in
        for (i, url) in urls.enumerated() {
            group.addTask {
                let (data, _) = try await URLSession.shared.data(from: url)
                return (i, data)
            }
        }
        var results = [Data?](repeating: nil, count: urls.count)
        for try await (i, data) in group {
            results[i] = data
        }
        return results.compactMap { $0 }
    }
}
*/


// =============================================================================
// MARK: - Example 6: Class Definition
// =============================================================================

/// Task: Define a simple Person class with properties and methods

// --- Current ObjC ---

// Person.h
@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong, nullable) Person *spouse;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
- (NSString *)greet;
- (BOOL)isAdult;
+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age;
@end

// Person.m
@implementation Person

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
    self = [super init];
    if (self) {
        _name = [name copy];
        _age = age;
    }
    return self;
}

- (NSString *)greet {
    return [NSString stringWithFormat:@"Hello, my name is %@ and I'm %ld years old.", self.name, (long)self.age];
}

- (BOOL)isAdult {
    return self.age >= 18;
}

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age {
    return [[self alloc] initWithName:name age:age];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Person(name=%@, age=%ld)", self.name, (long)self.age];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Person class]]) return NO;
    Person *other = object;
    return [self.name isEqualToString:other.name] && self.age == other.age;
}

- (NSUInteger)hash {
    return self.name.hash ^ self.age;
}

@end


// --- Swuft (using Mar 2026 syntax ideas) ---

@class Person : NSObject {
    @property NSString *name;
    @property NSInteger age;
    @property Person *spouse;  // nullable by default? or explicit @property Person? *spouse

    - (instancetype) initWithName: (NSString *name) age: (NSInteger age) {
        self = super.[init];
        if (self) {
            _name = name.[copy];
            _age = age;
        }
        return self;
    }

    - (NSString *) greet {
        return @"Hello, my name is %@ and I'm %ld years old.".[format: self.name, (long)self.age];
    }

    - (BOOL) isAdult {
        return self.age >= 18;
    }

    + (instancetype) personWithName: (NSString *name) age: (NSInteger age) {
        return self.[alloc].[initWithName: name age: age];
    }

    - (NSString *) description {
        return @"Person(name=%@, age=%ld)".[format: self.name, (long)self.age];
    }

    - (BOOL) isEqual: (id object) {
        if (!object.[isKindOfClass: Person]) return NO;
        Person *other = object;
        return self.name.[isEqualToString: other.name] && self.age == other.age;
    }

    - (NSUInteger) hash {
        return self.name.[hash] ^ self.age;
    }
}

// Or with operator overloading (Apr 2026 idea):
// if (personA == personB) ...  // desugars to personA.[isEqual: personB]


// --- Python ---
/*
from dataclasses import dataclass
from typing import Optional

@dataclass
class Person:
    name: str
    age: int
    spouse: Optional['Person'] = None

    def greet(self) -> str:
        return f"Hello, my name is {self.name} and I'm {self.age} years old."

    def is_adult(self) -> bool:
        return self.age >= 18
*/

// --- Swift ---
/*
class Person: Equatable, Hashable, CustomStringConvertible {
    var name: String
    var age: Int
    weak var spouse: Person?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func greet() -> String {
        "Hello, my name is \(name) and I'm \(age) years old."
    }

    var isAdult: Bool { age >= 18 }

    var description: String {
        "Person(name=\(name), age=\(age))"
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.name == rhs.name && lhs.age == rhs.age
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(age)
    }
}
*/

// --- Rust ---
/*
#[derive(Debug, PartialEq, Eq, Hash)]
struct Person {
    name: String,
    age: i32,
}

impl Person {
    fn new(name: String, age: i32) -> Self {
        Self { name, age }
    }

    fn greet(&self) -> String {
        format!("Hello, my name is {} and I'm {} years old.", self.name, self.age)
    }

    fn is_adult(&self) -> bool {
        self.age >= 18
    }
}
*/


// =============================================================================
// MARK: - Example 7: File System Operations (The Unix Scripting Use Case)
// =============================================================================

/// Task: List files in a directory, filter by extension, get their sizes

// --- Current ObjC ---
- (NSDictionary *)getFileSizes_objc:(NSString *)directory extension:(NSString *)ext {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSArray *contents = [fm contentsOfDirectoryAtPath:directory error:&error];
    if (error) return nil;

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *file in contents) {
        if (![[file pathExtension] isEqualToString:ext]) continue;

        NSString *path = [directory stringByAppendingPathComponent:file];
        NSDictionary *attrs = [fm attributesOfItemAtPath:path error:nil];
        if (attrs) {
            result[file] = attrs[NSFileSize];
        }
    }
    return result;
}

// --- Swuft Dot-Bracket ---
- (NSDictionary *)getFileSizes_dotbracket:(NSString *)directory extension:(NSString *)ext {
    auto fm = NSFileManager.[defaultManager];
    NSError *error;
    auto contents = fm.[contentsOfDirectoryAtPath: directory error: &error];
    if (error) return nil;

    auto result = NSMutableDictionary.[dictionary];
    for (NSString *file in contents) {
        if (!file.[pathExtension].[isEqualToString: ext]) continue;

        auto path = directory.[stringByAppendingPathComponent: file];
        auto attrs = fm.[attributesOfItemAtPath: path error: nil];
        if (attrs) {
            result[file] = attrs[NSFileSize];
        }
    }
    return result;
}

// --- Swuft with list comprehension ---
- (NSDictionary *)getFileSizes_swuft_comprehension:(NSString *)directory extension:(NSString *)ext {
    auto fm = NSFileManager.[defaultManager];
    NSError *error;
    auto contents = fm.[contentsOfDirectoryAtPath: directory error: &error];
    if (error) return nil;

    // Hypothetical comprehension returning dict entries:
    return @{
        file: fm.[attributesOfItemAtPath: directory.[stringByAppendingPathComponent: file] error: nil][NSFileSize]
        for (NSString *file in contents)
        if (file.[pathExtension].[isEqualToString: ext])
    };
}

// --- Swuft with raw C APIs (the "Unix scripting" pitch) ---
NSDictionary *getFileSizes_swuft_unix(const char *directory, const char *ext) {
    DIR *dir = opendir(directory);
    if (!dir) return nil;
    defer closedir(dir);

    struct dirent *entry;
    auto result = NSMutableDictionary.[new];

    while ((entry = readdir(dir))) {
        // Check extension
        char *dot = strrchr(entry->d_name, '.');
        if (!dot || strcmp(dot + 1, ext) != 0) continue;

        // Get file size via stat
        char path[PATH_MAX];
        snprintf(path, sizeof(path), "%s/%s", directory, entry->d_name);
        struct stat st;
        if (stat(path, &st) == 0) {
            result[@(entry->d_name)] = @(st.st_size);
        }
    }
    return result;
}

// --- Python ---
/*
import os
from pathlib import Path

def get_file_sizes(directory: str, ext: str) -> dict:
    return {
        f.name: f.stat().st_size
        for f in Path(directory).iterdir()
        if f.suffix == f'.{ext}'
    }
*/

// --- Rust ---
/*
use std::fs;
use std::collections::HashMap;

fn get_file_sizes(dir: &str, ext: &str) -> HashMap<String, u64> {
    fs::read_dir(dir)
        .unwrap()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().map_or(false, |x| x == ext))
        .map(|e| (e.file_name().to_string_lossy().to_string(), e.metadata().unwrap().len()))
        .collect()
}
*/


// =============================================================================
// MARK: - Example 8: Pattern Matching / Switch-Case
// =============================================================================

/// Task: Handle different message types

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeText,
    MessageTypeImage,
    MessageTypeVideo,
    MessageTypeFile,
};

// --- Current ObjC ---
- (NSString *)handleMessage_objc:(MessageType)type payload:(id)payload {
    switch (type) {
        case MessageTypeText:
            return [NSString stringWithFormat:@"Text: %@", payload];
        case MessageTypeImage:
            return [NSString stringWithFormat:@"Image: %@ bytes", @([payload length])];
        case MessageTypeVideo:
            return [NSString stringWithFormat:@"Video: %@ seconds", payload[@"duration"]];
        case MessageTypeFile:
            return [NSString stringWithFormat:@"File: %@", payload[@"name"]];
        default:
            return @"Unknown";
    }
}

// --- Swuft Dot-Bracket (same structure, cleaner calls) ---
- (NSString *)handleMessage_dotbracket:(MessageType)type payload:(id)payload {
    switch (type) {
        case MessageTypeText:
            return @"Text: %@".[format: payload];
        case MessageTypeImage:
            return @"Image: %@ bytes".[format: @(payload.[length])];
        case MessageTypeVideo:
            return @"Video: %@ seconds".[format: payload[@"duration"]];
        case MessageTypeFile:
            return @"File: %@".[format: payload[@"name"]];
        default:
            return @"Unknown";
    }
}

// --- Python (with match, 3.10+) ---
/*
def handle_message(msg_type, payload):
    match msg_type:
        case "text":
            return f"Text: {payload}"
        case "image":
            return f"Image: {len(payload)} bytes"
        case "video":
            return f"Video: {payload['duration']} seconds"
        case "file":
            return f"File: {payload['name']}"
        case _:
            return "Unknown"
*/

// --- Swift (with associated values - much more powerful) ---
/*
enum Message {
    case text(String)
    case image(Data)
    case video(duration: TimeInterval)
    case file(name: String)
}

func handleMessage(_ msg: Message) -> String {
    switch msg {
    case .text(let content):
        return "Text: \(content)"
    case .image(let data):
        return "Image: \(data.count) bytes"
    case .video(let duration):
        return "Video: \(duration) seconds"
    case .file(let name):
        return "File: \(name)"
    }
}
*/

// --- Rust (also with powerful enums) ---
/*
enum Message {
    Text(String),
    Image(Vec<u8>),
    Video { duration: f64 },
    File { name: String },
}

fn handle_message(msg: &Message) -> String {
    match msg {
        Message::Text(content) => format!("Text: {}", content),
        Message::Image(data) => format!("Image: {} bytes", data.len()),
        Message::Video { duration } => format!("Video: {} seconds", duration),
        Message::File { name } => format!("File: {}", name),
    }
}
*/


// =============================================================================
// MARK: - Example 9: Protocol / Interface Implementation
// =============================================================================

/// Task: Define a serializable protocol and implement it

// --- Current ObjC ---

@protocol Serializable <NSObject>
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;
@end

@interface SerializablePerson : NSObject <Serializable>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation SerializablePerson

- (NSDictionary *)toDictionary {
    return @{@"name": self.name, @"age": @(self.age)};
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    SerializablePerson *p = [[self alloc] init];
    p.name = dict[@"name"];
    p.age = [dict[@"age"] integerValue];
    return p;
}

@end

// --- Swuft ---

@protocol Serializable <NSObject> {
    - (NSDictionary *) toDictionary;
    + (instancetype) fromDictionary: (NSDictionary *dict);
}

@class SerializablePerson : NSObject <Serializable> {
    @property NSString *name;
    @property NSInteger age;

    - (NSDictionary *) toDictionary {
        return @{@"name": self.name, @"age": @(self.age)};
    }

    + (instancetype) fromDictionary: (NSDictionary *dict) {
        auto p = self.[alloc].[init];
        p.name = dict[@"name"];
        p.age = dict[@"age"].[integerValue];
        return p;
    }
}

// --- Python ---
/*
from abc import ABC, abstractmethod
from typing import TypeVar, Type

T = TypeVar('T', bound='Serializable')

class Serializable(ABC):
    @abstractmethod
    def to_dict(self) -> dict: ...

    @classmethod
    @abstractmethod
    def from_dict(cls: Type[T], d: dict) -> T: ...

class SerializablePerson(Serializable):
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def to_dict(self) -> dict:
        return {"name": self.name, "age": self.age}

    @classmethod
    def from_dict(cls, d: dict) -> 'SerializablePerson':
        return cls(d["name"], d["age"])
*/

// --- Swift ---
/*
protocol Serializable {
    func toDictionary() -> [String: Any]
    static func fromDictionary(_ dict: [String: Any]) -> Self
}

class SerializablePerson: Serializable {
    var name: String
    var age: Int

    required init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func toDictionary() -> [String: Any] {
        ["name": name, "age": age]
    }

    static func fromDictionary(_ dict: [String: Any]) -> Self {
        Self.init(name: dict["name"] as! String, age: dict["age"] as! Int)
    }
}
*/

// --- Rust ---
/*
use serde::{Serialize, Deserialize};

trait Serializable: Sized {
    fn to_dict(&self) -> std::collections::HashMap<String, serde_json::Value>;
    fn from_dict(dict: &std::collections::HashMap<String, serde_json::Value>) -> Self;
}

#[derive(Serialize, Deserialize)]
struct SerializablePerson {
    name: String,
    age: i32,
}

// In practice, you'd just use #[derive(Serialize, Deserialize)] and serde
*/


// =============================================================================
// MARK: - Example 10: Deeply Nested Method Calls (The Readability Test)
// =============================================================================

/// Task: Complex transformation pipeline (from the original notes)

// --- Current ObjC (the nesting hell) ---
- (void)nestedCalls_objc {
    [[parser parseDocument:[loader
        fetchURL:[config get:@"url"]
        withAuth:[credentials tokenFor:[service current]]
        andTimeout:[[settings get:@"timeout"] intValue]]]
    validateWith:[schema load:@"doc.xsd"]];
}

// --- Swuft Dot-Bracket (much more readable) ---
- (void)nestedCalls_dotbracket {
    parser
        .[parseDocument: loader.[
            fetchURL:   config.[get: @"url"]
            withAuth:   credentials.[tokenFor: service.[current]]
            andTimeout: settings.[get: @"timeout"].[intValue]
        ]]
        .[validateWith: schema.[load: @"doc.xsd"]];
}

// --- Swuft Full Smalltalk ---
- (void)nestedCalls_smalltalk {
    parser
        [parseDocument: loader [
            fetchURL:   config [get: @"url"]
            withAuth:   credentials [tokenFor: service current]
            andTimeout: settings [get: @"timeout"] intValue
        ]]
        [validateWith: schema [load: @"doc.xsd"]];
}

// --- Swift ---
/*
parser.parseDocument(loader.fetch(
    url:     config.get("url"),
    auth:    credentials.token(for: service.current),
    timeout: settings.get("timeout").intValue
))
.validate(with: schema.load("doc.xsd"))
*/


// =============================================================================
// MARK: - OBSERVATIONS AND GAPS
// =============================================================================

/*

## What Swuft Does Well:

1. **Method Chaining**: The dot-bracket syntax `.[]` elegantly solves ObjC's biggest
   readability problem - nested brackets reading inside-out. You can now read left-to-right.

2. **C Interop**: Keeping full C compatibility while adding conveniences like `defer`,
   list comprehensions, and operator overloading is a sweet spot.

3. **Minimal Changes**: Unlike Swift which created a whole new language, most of Swuft
   is just syntactic sugar that maps cleanly to existing ObjC concepts.

4. **The Unix Scripting Pitch**: Being able to call C APIs directly (opendir, stat, etc.)
   while having ARC'd collections is genuinely useful. Python requires FFI; Go requires cgo.

5. **List Comprehensions**: `@[ expr for x in xs if cond ]` is more flexible than
   map/filter/reduce and feels natural.


## Gaps / Questions in the Design:

1. **Generics Syntax**: The notes mention both `NSArray<String *>` (current) and
   `Array [String *]` (proposed). The latter conflicts visually with method calls.
   Maybe stick with angle brackets?

2. **Optional Chaining**: Swift's `?.` is very useful. The notes mention `?` for optionals
   but don't detail how chaining would work. Proposal: `obj?.[method]` or `obj?[key]`?

3. **Block/Closure Syntax**: ObjC blocks are already verbose. Should Swuft have
   lighter-weight closures? E.g., `{ |x| x * 2 }` instead of `^(int x) { return x * 2; }`?

4. **Async/Await**: The notes don't address modern concurrency. Should Swuft adopt
   async/await like Swift 5.5+? Or stick with GCD patterns?

5. **Error Handling**: Swift has throws/try/catch. ObjC has NSError **. Neither is great.
   Should Swuft have something new? Result types?

6. **Associated Values in Enums**: Swift/Rust enums are much more powerful than C enums.
   This is a big gap for modeling state machines, message types, etc.

7. **Namespacing**: The notes mention keeping NS prefixes. But what about user code?
   Swift has modules. Should Swuft have something?

8. **Mutability**: The notes mention removing NSMutableArray distinction. But mutability
   semantics matter for threading. How would `@synchronized` work?

9. **Value Types**: Swift structs being value types is powerful (no accidental sharing).
   Should Swuft have opt-in value semantics for classes?

10. **Generic Constraints**: Swift's `where T: Comparable` is useful. How would this
    work in Swuft's type system?

*/


// =============================================================================
// MARK: - PROPOSED ADDITIONS (For Discussion)
// =============================================================================

/*

## 1. Lightweight Closure Syntax

Current ObjC:
    arr.[sortUsingComparator: ^NSComparisonResult(id a, id b) {
        return [a compare: b];
    }];

Proposed Swuft:
    arr.[sortUsingComparator: { a, b => a.[compare: b] }];
    // Or with types when needed:
    arr.[sortUsingComparator: { (id a, id b) => a.[compare: b] }];


## 2. Optional Chaining Syntax

    // Current - need to check each step
    NSDictionary *user = dict[@"user"];
    if (!user) return nil;
    NSString *name = user[@"profile"][@"name"];

    // Proposed Swuft
    auto name = dict?[@"user"]?[@"profile"]?[@"name"];
    // Or for methods:
    auto result = obj?.[foo]?.[bar: x]?.[baz];


## 3. Result Type (Alternative to NSError **)

    // Proposed: Result<T> type that's either .ok(value) or .err(NSError *)

    Result<NSData *> fetchData(NSURL *url) {
        NSError *error;
        auto data = NSData.[dataWithContentsOfURL: url error: &error];
        if (error) return Result.[err: error];
        return Result.[ok: data];
    }

    // Usage with pattern matching:
    auto result = fetchData(url);
    if (result.[isOk]) {
        auto data = result.[unwrap];
        // use data
    } else {
        NSLog(@"Error: %@", result.[error]);
    }


## 4. Simple Async/Await

    // Proposed: `async` functions return a "Promise" that can be awaited

    async NSData *fetchAsync(NSURL *url) {
        return NSData.[dataWithContentsOfURL: url];
    }

    async void processURLs(NSArray *urls) {
        for (NSURL *url in urls) {
            auto data = await fetchAsync(url);
            // process data
        }
    }

    // Parallel:
    async void fetchAllParallel(NSArray *urls) {
        auto futures = @[ fetchAsync(url) for (NSURL *url in urls) ];
        auto results = await Promise.[all: futures];
    }


## 5. Pattern Matching Enhancement

    // Swift-style if-let as expression
    if (auto user = dict[@"user"]) {
        // user is non-nil here
    }

    // Guard-let equivalent
    guard (auto data = response[@"data"]) else return nil;
    // data is non-nil for rest of scope

*/

