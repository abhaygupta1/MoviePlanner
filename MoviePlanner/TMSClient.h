//
//  TMSClient.h
//  MoviePlanner
//
//  Created by  on 8/20/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "AFHTTPClient.h"

@interface TMSClient : AFHTTPClient

+ (TMSClient *)instance;

// Statuses API

- (void)movieListWithZipCode:(NSString *)zipCode success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
