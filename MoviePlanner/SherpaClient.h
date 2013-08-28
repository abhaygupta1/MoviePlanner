//
//  SherpaClient.h
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SherpaClient : AFHTTPClient

+ (SherpaClient *)instance;

// Statuses API

- (void)userListWithCount:(int)count uriPath: (NSString *)uriPath success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)userWithName:(NSString *)name success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)saveUserWithName:(NSString *)name params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
