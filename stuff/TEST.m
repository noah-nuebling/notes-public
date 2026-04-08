
// Claude's version:
  - (void)fetchAll:(NSArray<NSURL *> *)urls completion:(void(^)(NSArray *))completion {
      dispatch_group_t group = dispatch_group_create();
      NSMutableArray *results = [NSMutableArray arrayWithCapacity:urls.count];

      for (NSUInteger i = 0; i < urls.count; i++) {
          [results addObject:[NSNull null]];
      }

      [urls enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
          dispatch_group_enter(group);
          [[NSURLSession sharedSession] dataTaskWithURL:url
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
              @synchronized(results) {
                  results[idx] = data ?: [NSNull null];
              }
              dispatch_group_leave(group);
          }];
      }];

      dispatch_group_notify(group, dispatch_get_main_queue(), ^{
          completion(results);
      });
  }

// Trying to simplify Swuft-style:
NSData *[NSArray *] fetchAll: (NSString *[NSArray *] urls) { // Putting the name in the parens along with the type simplifies block args a bit (Update: I removed the completion block arg – so you can't see this anymore)|| Not sure about the new `NSData *[NSArray *]` syntax, but I wanted to see what it looks like.
    
    auto group = NSThreadGroup.[new]; // New primitive in the stdlib
    
    auto results = @(NSNull.[null] for range(i, urls.count)); // Creates an NSArray. NSArray is mutable, NSMutableArray is deprecated / an alias || range() is a very simple macro I'm already using in objc for some code – not sure it should be part of objc 3? Let's go with it for now.

    for range(i, urls.count) { // Didn't change this too much – just used dot-bracket syntax
        group.[enter];
        NSURLSession.[sharedSession].[dataTaskWithURL: urls[i] completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            @synchronized(results) results[i] = data ?: NSNull.[null];
            group.[leave];
        }];
    }
    group.[wait];
    return results; /// The return semantics are simplified to just be blocking – not sure that's a fair comparison? I don't understand when you'd use the original semantics.
}