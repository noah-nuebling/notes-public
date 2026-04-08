
Claude's version:
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

Trying to simplify Swuft-style:
- void fetchAll: (NSString *[NSArray *] urls) completion: (void ^completion(NSArray *)) { // Putting the name in the parens along with the type simplifies block args a bit
    auto group = [NSThreadGroup new]; // New primitive in the stdlib
    NSArray *results = [NSArray new]; // NSArray is mutable, NSMutableArray is deprecated / an alias

    for range(i, urls.count) results += [NSNull null]; // range() is a very simple macro I'm already using in objc for some code – not sure it should be part of objc 3? Let's go with it for now || `+=` might desugar to __add_object__ or something. Also not sure if worth adding.

    for (NSURL *url in urls)
        NSURLSession.[sharedSession].[dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            @synchronized(results) results[idx] = data ?: [NSNull null];
            dispatch_group_leave(group);
        }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(results);
    });
}