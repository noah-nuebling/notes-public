
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
- void fetchAll: (NSString *[NSArray *] urls) completion: (void(^)(NSArray *))completion {
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