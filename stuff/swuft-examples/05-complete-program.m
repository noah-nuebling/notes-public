/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// A Complete Program
/// A small but realistic CLI tool to see how all the pieces fit together
///
/// Task: A "todo" command line tool that stores tasks in JSON

#import <SwuftFoundation/Foundation.h>
#include <stdio.h>
#include <string.h>

// =============================================================================
// Swuft Version (dot-bracket syntax)
// =============================================================================

/// --- Data model ---

@dataclass Task {
    String *id;
    String *title;
    bool done;
    String *created;    /// ISO date string
}

/// --- Storage ---

@class TaskStore {
    String *path;
    Array [Task *] *tasks;

    + TaskStore *[withPath: String *p] {
        auto store = TaskStore.[new];
        store->path = p;
        store->tasks = Array.[new];
        store.[load];
        return store;
    }

    - void load {
        if (!FileManager.[default].[fileExistsAtPath: path])
            return;

        Error *err = nil;
        auto data = Data.[contentsOfFile: path error: &err];
        if (err) return;

        auto json = JSON.[parse: data error: &err];
        if (err) return;

        tasks = @[ Task.[fromDict: d] for (Dictionary *d in json) ];
    }

    - void save {
        auto json = @[ t.[toDict] for (Task *t in tasks) ];
        auto data = JSON.[serialize: json pretty: true error: nil];
        data.[writeToFile: path atomically: true];
    }

    - void [add: String *title] {
        auto task = Task.[new];
        task->id = UUID.[new].[string];
        task->title = title;
        task->done = false;
        task->created = Date.[now].[isoString];

        tasks.[add: task];
        self.[save];

        printf("Added: %s\n", title.[UTF8String]);
    }

    - void list {
        if (tasks.[count] == 0) {
            printf("No tasks.\n");
            return;
        }

        for (Task *t in tasks) {
            auto status = t->done ? @"[x]" : @"[ ]";
            printf("%s %s %s\n",
                   status.[UTF8String],
                   t->id.[substringTo: 8].[UTF8String],
                   t->title.[UTF8String]);
        }
    }

    - void [done: String *idPrefix] {
        for (Task *t in tasks) {
            if (t->id.[hasPrefix: idPrefix]) {
                t->done = true;
                self.[save];
                printf("Completed: %s\n", t->title.[UTF8String]);
                return;
            }
        }
        printf("Task not found: %s\n", idPrefix.[UTF8String]);
    }

    - void [remove: String *idPrefix] {
        for (int i = 0; i < tasks.[count]; i++) {
            Task *t = tasks[i];
            if (t->id.[hasPrefix: idPrefix]) {
                printf("Removed: %s\n", t->title.[UTF8String]);
                tasks.[removeAtIndex: i];
                self.[save];
                return;
            }
        }
        printf("Task not found: %s\n", idPrefix.[UTF8String]);
    }
}

/// --- Main ---

int main(int argc, char *argv[]) {

    auto storePath = @"~/.todo.json".[expandTilde];
    auto store = TaskStore.[withPath: storePath];

    if (argc < 2) {
        store.[list];
        return 0;
    }

    auto cmd = @(String *)argv[1];

    if (cmd.[eq: @"add"] && argc >= 3) {
        /// Join remaining args as title
        auto parts = @[ @(String *)argv[i] for (int i = 2; i < argc; i++) ];
        auto title = parts.[joinedBy: @" "];
        store.[add: title];
    }
    else if (cmd.[eq: @"done"] && argc >= 3) {
        store.[done: @(String *)argv[2]];
    }
    else if (cmd.[eq: @"rm"] && argc >= 3) {
        store.[remove: @(String *)argv[2]];
    }
    else if (cmd.[eq: @"list"]) {
        store.[list];
    }
    else {
        printf("Usage: todo [add <title> | done <id> | rm <id> | list]\n");
        return 1;
    }

    return 0;
}


// =============================================================================
// Same program in Full Smalltalk syntax
// =============================================================================

int main_smalltalk(int argc, char *argv[]) {

    auto storePath = @"~/.todo.json" expandTilde;
    auto store = TaskStore [withPath: storePath];

    if (argc < 2) {
        store list;
        return 0;
    }

    auto cmd = @(String *)argv[1];

    if (cmd [eq: @"add"] && argc >= 3) {
        auto parts = @[ @(String *)argv[i] for (int i = 2; i < argc; i++) ];
        auto title = parts [joinedBy: @" "];
        store [add: title];
    }
    else if (cmd [eq: @"done"] && argc >= 3) {
        store [done: @(String *)argv[2]];
    }
    else if (cmd [eq: @"rm"] && argc >= 3) {
        store [remove: @(String *)argv[2]];
    }
    else if (cmd [eq: @"list"]) {
        store list;
    }
    else {
        printf("Usage: todo [add <title> | done <id> | rm <id> | list]\n");
        return 1;
    }

    return 0;
}


// =============================================================================
// Original Objective-C Version (for comparison)
// =============================================================================

@interface Task : NSObject
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL done;
@property (nonatomic, strong) NSString *created;
- (NSDictionary *)toDict;
+ (instancetype)fromDict:(NSDictionary *)dict;
@end

@implementation Task
- (NSDictionary *)toDict {
    return @{
        @"id": self.taskId,
        @"title": self.title,
        @"done": @(self.done),
        @"created": self.created
    };
}
+ (instancetype)fromDict:(NSDictionary *)dict {
    Task *t = [[Task alloc] init];
    t.taskId = dict[@"id"];
    t.title = dict[@"title"];
    t.done = [dict[@"done"] boolValue];
    t.created = dict[@"created"];
    return t;
}
@end

@interface TaskStore : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableArray<Task *> *tasks;
+ (instancetype)storeWithPath:(NSString *)path;
- (void)addTaskWithTitle:(NSString *)title;
- (void)listTasks;
- (void)markDoneWithIdPrefix:(NSString *)prefix;
- (void)removeWithIdPrefix:(NSString *)prefix;
@end

@implementation TaskStore

+ (instancetype)storeWithPath:(NSString *)path {
    TaskStore *store = [[TaskStore alloc] init];
    store.path = path;
    store.tasks = [NSMutableArray array];
    [store load];
    return store;
}

- (void)load {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.path])
        return;

    NSError *err = nil;
    NSData *data = [NSData dataWithContentsOfFile:self.path options:0 error:&err];
    if (err) return;

    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if (err) return;

    for (NSDictionary *d in json) {
        [self.tasks addObject:[Task fromDict:d]];
    }
}

- (void)save {
    NSMutableArray *json = [NSMutableArray array];
    for (Task *t in self.tasks) {
        [json addObject:[t toDict]];
    }

    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&err];
    [data writeToFile:self.path atomically:YES];
}

- (void)addTaskWithTitle:(NSString *)title {
    Task *task = [[Task alloc] init];
    task.taskId = [[NSUUID UUID] UUIDString];
    task.title = title;
    task.done = NO;
    task.created = [[NSISO8601DateFormatter new] stringFromDate:[NSDate date]];

    [self.tasks addObject:task];
    [self save];

    printf("Added: %s\n", [title UTF8String]);
}

- (void)listTasks {
    if (self.tasks.count == 0) {
        printf("No tasks.\n");
        return;
    }

    for (Task *t in self.tasks) {
        NSString *status = t.done ? @"[x]" : @"[ ]";
        printf("%s %s %s\n",
               [status UTF8String],
               [[t.taskId substringToIndex:8] UTF8String],
               [t.title UTF8String]);
    }
}

- (void)markDoneWithIdPrefix:(NSString *)prefix {
    for (Task *t in self.tasks) {
        if ([t.taskId hasPrefix:prefix]) {
            t.done = YES;
            [self save];
            printf("Completed: %s\n", [t.title UTF8String]);
            return;
        }
    }
    printf("Task not found: %s\n", [prefix UTF8String]);
}

- (void)removeWithIdPrefix:(NSString *)prefix {
    for (NSInteger i = 0; i < self.tasks.count; i++) {
        Task *t = self.tasks[i];
        if ([t.taskId hasPrefix:prefix]) {
            printf("Removed: %s\n", [t.title UTF8String]);
            [self.tasks removeObjectAtIndex:i];
            [self save];
            return;
        }
    }
    printf("Task not found: %s\n", [prefix UTF8String]);
}

@end

int main_objc(int argc, char *argv[]) {
    @autoreleasepool {
        NSString *storePath = [@"~/.todo.json" stringByExpandingTildeInPath];
        TaskStore *store = [TaskStore storeWithPath:storePath];

        if (argc < 2) {
            [store listTasks];
            return 0;
        }

        NSString *cmd = [NSString stringWithUTF8String:argv[1]];

        if ([cmd isEqualToString:@"add"] && argc >= 3) {
            NSMutableArray *parts = [NSMutableArray array];
            for (int i = 2; i < argc; i++) {
                [parts addObject:[NSString stringWithUTF8String:argv[i]]];
            }
            NSString *title = [parts componentsJoinedByString:@" "];
            [store addTaskWithTitle:title];
        }
        else if ([cmd isEqualToString:@"done"] && argc >= 3) {
            [store markDoneWithIdPrefix:[NSString stringWithUTF8String:argv[2]]];
        }
        else if ([cmd isEqualToString:@"rm"] && argc >= 3) {
            [store removeWithIdPrefix:[NSString stringWithUTF8String:argv[2]]];
        }
        else if ([cmd isEqualToString:@"list"]) {
            [store listTasks];
        }
        else {
            printf("Usage: todo [add <title> | done <id> | rm <id> | list]\n");
            return 1;
        }
    }
    return 0;
}


// =============================================================================
// Python Version (for comparison)
// =============================================================================

/*
import json
import os
import sys
import uuid
from datetime import datetime
from dataclasses import dataclass, asdict

@dataclass
class Task:
    id: str
    title: str
    done: bool
    created: str

class TaskStore:
    def __init__(self, path):
        self.path = os.path.expanduser(path)
        self.tasks = []
        self.load()

    def load(self):
        if not os.path.exists(self.path):
            return
        with open(self.path) as f:
            data = json.load(f)
            self.tasks = [Task(**d) for d in data]

    def save(self):
        with open(self.path, 'w') as f:
            json.dump([asdict(t) for t in self.tasks], f, indent=2)

    def add(self, title):
        task = Task(
            id=str(uuid.uuid4()),
            title=title,
            done=False,
            created=datetime.now().isoformat()
        )
        self.tasks.append(task)
        self.save()
        print(f"Added: {title}")

    def list(self):
        if not self.tasks:
            print("No tasks.")
            return
        for t in self.tasks:
            status = "[x]" if t.done else "[ ]"
            print(f"{status} {t.id[:8]} {t.title}")

    def done(self, id_prefix):
        for t in self.tasks:
            if t.id.startswith(id_prefix):
                t.done = True
                self.save()
                print(f"Completed: {t.title}")
                return
        print(f"Task not found: {id_prefix}")

    def remove(self, id_prefix):
        for i, t in enumerate(self.tasks):
            if t.id.startswith(id_prefix):
                print(f"Removed: {t.title}")
                del self.tasks[i]
                self.save()
                return
        print(f"Task not found: {id_prefix}")

def main():
    store = TaskStore("~/.todo.json")

    if len(sys.argv) < 2:
        store.list()
        return

    cmd = sys.argv[1]

    if cmd == "add" and len(sys.argv) >= 3:
        title = " ".join(sys.argv[2:])
        store.add(title)
    elif cmd == "done" and len(sys.argv) >= 3:
        store.done(sys.argv[2])
    elif cmd == "rm" and len(sys.argv) >= 3:
        store.remove(sys.argv[2])
    elif cmd == "list":
        store.list()
    else:
        print("Usage: todo [add <title> | done <id> | rm <id> | list]")
        sys.exit(1)

if __name__ == "__main__":
    main()
*/


// =============================================================================
// Line count comparison (approximate)
// =============================================================================

/*
Language          | Lines | Notes
------------------|-------|----------------------------------------------
Python            |  65   | Cleanest, dataclasses do heavy lifting
Swuft (dot-brkt)  |  85   | Close to Python, @dataclass helps a lot
Swuft (smalltalk) |  85   | Same LOC, slightly cleaner method chains
Objective-C       | 140   | Verbose class declarations, long method names
Swift             |  80   | (not shown) Similar to Swuft with Codable

Key differences:
- @dataclass eliminates ~30 lines of boilerplate
- List comprehensions eliminate explicit loops
- Shorter method names (eq: vs isEqualToString:) add up
- Boxing syntax @(String *) is more verbose than Python's implicit str()
*/
