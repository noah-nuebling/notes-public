/// 01-method-call-syntax.m
/// Written by Claude (Opus 4.5) – exploring Swuft method call syntax variations
///
/// This file compares the different method call syntax proposals side-by-side
/// to see how they feel in realistic code scenarios.

// =============================================================================
// SCENARIO 1: Simple method chaining (the core problem objc has)
// =============================================================================

/// Current Objective-C 2.0
/// Problem: You have to add [ on the LEFT when you want to chain on the RIGHT
NSString *result1 = [[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                      lowercaseString]
                     stringByReplacingOccurrencesOfString:@" " withString:@"-"];

/// Swuft 1.0 (Python-style)
auto result2 = string.trim(charset=NSCharacterSet.whitespace())
                     .lowercase()
                     .replace(target=@" ", with=@"-");

/// Swuft 2.0 (Dot-bracket)
auto result3 = string.[stringByTrimmingCharactersInSet: NSCharacterSet.[whitespaceCharacterSet]]
                     .[lowercaseString]
                     .[stringByReplacingOccurrencesOfString: @" " withString: @"-"];

/// Swuft 2.0 (Full Smalltalk)
auto result4 = string [stringByTrimmingCharactersInSet: NSCharacterSet whitespaceCharacterSet]
                      lowercaseString
                      [stringByReplacingOccurrencesOfString: @" " withString: @"-"];

/// Swift (for comparison)
let result5 = string.trimmingCharacters(in: .whitespaces)
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "-")


// =============================================================================
// SCENARIO 2: Nested calls (where current objc gets really ugly)
// =============================================================================

/// Current Objective-C 2.0
NSDictionary *config = [[NSDictionary alloc] initWithObjectsAndKeys:
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:
        [[NSBundle mainBundle] resourcePath] error:nil], @"files",
    [[[NSProcessInfo processInfo] environment] objectForKey:@"USER"], @"user",
    nil];

/// Swuft 1.0 (Python-style)
auto config = @dict(
    files=NSFileManager.default().contents_of_dir(path=NSBundle.main().resource_path(), err=nil),
    user=NSProcessInfo.info().environment().get(@"USER")
);

/// Swuft 2.0 (Dot-bracket)
auto config = @{
    @"files": NSFileManager.[defaultManager].[contentsOfDirectoryAtPath: NSBundle.[mainBundle].[resourcePath] error: nil],
    @"user": NSProcessInfo.[processInfo].[environment][@"USER"]
};

/// Swuft 2.0 (Full Smalltalk)
auto config = @{
    @"files": NSFileManager defaultManager [contentsOfDirectoryAtPath: NSBundle mainBundle resourcePath error: nil],
    @"user": NSProcessInfo processInfo environment [@"USER"]
};

/// Swift
let config = [
    "files": FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath!, error: nil),
    "user": ProcessInfo.processInfo.environment["USER"]
]


// =============================================================================
// SCENARIO 3: Blocks / closures (the real pain point)
// =============================================================================

/// Current Objective-C 2.0
[UIView animateWithDuration:0.3
                      delay:0.0
                    options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                     self.view.alpha = 1.0;
                     self.view.frame = CGRectMake(0, 0, 100, 100);
                 }
                 completion:^(BOOL finished) {
                     if (finished) {
                         [self.delegate viewDidAppear:self.view];
                     }
                 }];

/// Swuft 1.0 (Python-style)
UIView.animate(duration=0.3, delay=0.0, options=UIViewAnimationOptionCurveEaseOut,
    animations=^{
        self.view.alpha = 1.0;
        self.view.frame = CGRectMake(0, 0, 100, 100);
    },
    completion=^(BOOL finished) {
        if (finished)
            self.delegate.view_did_appear(view=self.view);
    }
);

/// Swuft 2.0 (Dot-bracket)
UIView.[animateWithDuration: 0.3
                      delay: 0.0
                    options: UIViewAnimationOptionCurveEaseOut
                 animations: ^{
                     self.[view].[setAlpha: 1.0];
                     self.[view].[setFrame: CGRectMake(0, 0, 100, 100)];
                 }
                 completion: ^(BOOL finished) {
                     if (finished)
                         self.[delegate].[viewDidAppear: self.[view]];
                 }];

/// Swuft 2.0 (Full Smalltalk)
UIView [animateWithDuration: 0.3
                      delay: 0.0
                    options: UIViewAnimationOptionCurveEaseOut
                 animations: ^{
                     self view [setAlpha: 1.0];
                     self view [setFrame: CGRectMake(0, 0, 100, 100)];
                 }
                 completion: ^(BOOL finished) {
                     if (finished)
                         self delegate [viewDidAppear: self view];
                 }];

/// Swift
UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
    animations: {
        self.view.alpha = 1.0
        self.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    },
    completion: { finished in
        if finished {
            self.delegate?.viewDidAppear(self.view)
        }
    }
)


// =============================================================================
// SCENARIO 4: Property access (getter/setter)
// =============================================================================

/// Current Objective-C 2.0 (with dot syntax sugar)
self.view.frame = CGRectMake(0, 0, self.view.superview.bounds.size.width, 100);
NSString *title = self.navigationController.topViewController.title;

/// Swuft 2.0 (Dot-bracket with .[prop] convention for properties)
self.[view].[frame] = CGRectMake(0, 0, self.[view].[superview].[bounds].size.width, 100);
auto title = self.[navigationController].[topViewController].[title];

/// Swuft 2.0 (Full Smalltalk)
self view [setFrame: CGRectMake(0, 0, self view superview bounds.size.width, 100)];
auto title = self navigationController topViewController title;

/// Question: Is the dot-bracket .[prop] better than keeping objc2's dot syntax for properties?
/// The .[prop] is more consistent (everything is a method call) but more verbose.
/// Maybe: Keep dot syntax for properties since they're so common?
self.view.frame = CGRectMake(0, 0, self.view.superview.bounds.size.width, 100);  // Keep this


// =============================================================================
// SCENARIO 5: Error handling pattern
// =============================================================================

/// Current Objective-C 2.0
NSError *error = nil;
NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
if (error) {
    NSLog(@"Failed to load: %@", [error localizedDescription]);
    return;
}
NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
if (error) {
    NSLog(@"Failed to parse: %@", [error localizedDescription]);
    return;
}

/// Swuft 2.0 (Dot-bracket) - not much different, the pattern is the same
NSError *error = nil;
auto data = NSData.[dataWithContentsOfFile: path options: 0 error: &error];
if (error) {
    NSLog(@"Failed to load: %@", error.[localizedDescription]);
    return;
}
auto json = NSJSONSerialization.[JSONObjectWithData: data options: 0 error: &error];
if (error) {
    NSLog(@"Failed to parse: %@", error.[localizedDescription]);
    return;
}

/// Swift (for comparison - the do/try/catch is actually nice here)
do {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let json = try JSONSerialization.jsonObject(with: data)
} catch {
    print("Failed: \(error.localizedDescription)")
    return
}


// =============================================================================
// OBSERVATIONS / DESIGN NOTES
// =============================================================================

/// 1. DOT-BRACKET vs FULL SMALLTALK:
///    - Dot-bracket: More familiar to mainstream devs, unambiguous parsing
///    - Full Smalltalk: Cleaner for simple cases but `thing.field` C-syntax collision
///    - Verdict: Dot-bracket feels like the safer choice for a "pragmatic" language
///
/// 2. PROPERTY ACCESS:
///    - Maybe keep objc2's dot syntax for properties? It's ubiquitous and short.
///    - Alternative: .[prop] is consistent but 3 extra chars per access adds up.
///    - Could have both: .prop (shorthand) and .[prop] (explicit method call)?
///
/// 3. BLOCK SYNTAX:
///    - Blocks are already pretty good in objc - the ^{} syntax is fine
///    - The main win is just removing the nested brackets around the call
///
/// 4. SELECTOR NAMES:
///    - Your note evolved toward keeping long names - I agree.
///    - `stringByReplacingOccurrencesOfString:withString:` reads as one token
///    - The dot-bracket makes chaining better without changing the names

