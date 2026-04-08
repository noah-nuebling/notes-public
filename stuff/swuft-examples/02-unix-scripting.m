/// Written by Claude (Opus 4.5) exploring Noah's Swuft/objc3 language design
///
/// Unix Scripting Examples
/// This is where Swuft could really shine - calling C APIs directly
/// with automatic memory management and nice collections.

#include <dirent.h>
#include <sys/stat.h>
#include <pwd.h>
#include <grp.h>
#include <unistd.h>

// =============================================================================
// TASK: List files with metadata (like ls -l)
// =============================================================================

/// --- Swuft ---

int main() {

    auto path = @"/etc";
    DIR *dir = opendir(path.[UTF8String]);
    if (!dir) {
        printf("Failed to open %s\n", path.[UTF8String]);
        return 1;
    }
    defer closedir(dir);

    struct dirent *entry;
    auto files = @[ @(String *)entry->d_name while ((entry = readdir(dir))) ];

    /// Filter out . and ..
    files = @[ f for (String *f in files) if (!f.[hasPrefix: @"."]) ];

    /// Get stat info for each file
    for (String *filename in files) {

        auto fullpath = @"%@/%@".[format: path, filename];

        struct stat st;
        if (stat(fullpath.[UTF8String], &st) != 0)
            continue;

        /// Get user/group names
        struct passwd *pw = getpwuid(st.st_uid);
        struct group *gr = getgrgid(st.st_gid);

        auto user = pw ? @(String *)pw->pw_name : @"?";
        auto group = gr ? @(String *)gr->gr_name : @"?";

        /// Format permissions
        auto perms = @(String *)((S_ISDIR(st.st_mode) ? "d" : "-"));
        perms = perms.[append: (st.st_mode & S_IRUSR) ? @"r" : @"-"];
        perms = perms.[append: (st.st_mode & S_IWUSR) ? @"w" : @"-"];
        perms = perms.[append: (st.st_mode & S_IXUSR) ? @"x" : @"-"];
        /// ... etc for group and other

        printf("%s %s %s %8lld %s\n",
               perms.[UTF8String],
               user.[UTF8String],
               group.[UTF8String],
               (long long)st.st_size,
               filename.[UTF8String]);
    }

    return 0;
}


/// --- Python equivalent ---

import os
import stat
import pwd
import grp

def main():
    path = "/etc"

    try:
        files = os.listdir(path)
    except OSError as e:
        print(f"Failed to open {path}")
        return 1

    files = [f for f in files if not f.startswith(".")]

    for filename in files:
        fullpath = os.path.join(path, filename)

        try:
            st = os.stat(fullpath)
        except OSError:
            continue

        try:
            user = pwd.getpwuid(st.st_uid).pw_name
        except KeyError:
            user = "?"

        try:
            group = grp.getgrgid(st.st_gid).gr_name
        except KeyError:
            group = "?"

        perms = "d" if stat.S_ISDIR(st.st_mode) else "-"
        perms += "r" if st.st_mode & stat.S_IRUSR else "-"
        perms += "w" if st.st_mode & stat.S_IWUSR else "-"
        perms += "x" if st.st_mode & stat.S_IXUSR else "-"
        # ... etc

        print(f"{perms} {user} {group} {st.st_size:8d} {filename}")


// =============================================================================
// TASK: Parse /etc/passwd into structured data
// =============================================================================

/// --- Swuft ---

Array [Dictionary [String *, id] *] *parse_passwd_swuft() {

    auto contents = String.[contentsOfFile: @"/etc/passwd"];
    auto lines = contents.[split: @"\n"];

    auto result = Array.[new];

    for (String *line in lines) {
        if (line.[length] == 0) continue;

        auto parts = line.[split: @":"];
        if (parts.[count] < 7) continue;

        auto entry = @{
            @"username": parts[0],
            @"password": parts[1],
            @"uid":      @(auto)(parts[2].[intValue]),
            @"gid":      @(auto)(parts[3].[intValue]),
            @"gecos":    parts[4],
            @"home":     parts[5],
            @"shell":    parts[6]
        };

        result.[add: entry];
    }

    return result;
}


/// --- Python ---

def parse_passwd():
    with open("/etc/passwd") as f:
        contents = f.read()

    result = []
    for line in contents.split("\n"):
        if not line:
            continue

        parts = line.split(":")
        if len(parts) < 7:
            continue

        result.append({
            "username": parts[0],
            "password": parts[1],
            "uid": int(parts[2]),
            "gid": int(parts[3]),
            "gecos": parts[4],
            "home": parts[5],
            "shell": parts[6]
        })

    return result


// =============================================================================
// TASK: HTTP request (showing how you'd wrap a C library)
// =============================================================================

/// --- Swuft (using hypothetical curl wrapper or NSURLSession) ---

void fetch_json_swuft() {

    /// Using Foundation (existing)
    auto url = URL.[with: @"https://api.example.com/data"];
    auto request = URLRequest.[with: url];

    /// Synchronous for simplicity (real code would be async)
    Error *err = nil;
    auto response = URLSession.[shared].[sendSync: request error: &err];

    if (err) {
        printf("Error: %s\n", err.[description].[UTF8String]);
        return;
    }

    /// Parse JSON
    auto json = JSON.[parse: response.[data] error: &err];

    /// Access like a dict
    auto name = json[@"user"][@"name"];
    printf("User: %s\n", name.[UTF8String]);
}


/// --- Python ---

import requests
import json

def fetch_json():
    try:
        response = requests.get("https://api.example.com/data")
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"Error: {e}")
        return

    data = response.json()
    name = data["user"]["name"]
    print(f"User: {name}")


// =============================================================================
// TASK: Recursive file search (like find)
// =============================================================================

/// --- Swuft ---

Array [String *] *find_files_swuft(String *dir, String *pattern) {

    auto results = Array.[new];

    DIR *d = opendir(dir.[UTF8String]);
    if (!d) return results;
    defer closedir(d);

    struct dirent *entry;
    while ((entry = readdir(d))) {
        auto name = @(String *)entry->d_name;

        if (name.[eq: @"."] || name.[eq: @".."])
            continue;

        auto fullpath = @"%@/%@".[format: dir, name];

        struct stat st;
        if (stat(fullpath.[UTF8String], &st) != 0)
            continue;

        if (S_ISDIR(st.st_mode)) {
            /// Recurse
            auto subresults = find_files_swuft(fullpath, pattern);
            results.[addAll: subresults];
        }
        else if (name.[matches: pattern]) {   /// glob or regex match
            results.[add: fullpath];
        }
    }

    return results;
}

/// Usage:
void example() {
    auto cfiles = find_files_swuft(@"/usr/include", @"*.h");
    for (String *f in cfiles) {
        printf("%s\n", f.[UTF8String]);
    }
}


/// --- Python ---

import os
import fnmatch

def find_files(directory, pattern):
    results = []
    for root, dirs, files in os.walk(directory):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                results.append(os.path.join(root, name))
    return results
