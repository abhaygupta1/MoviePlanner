//
//  SherpaClient.m
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "SherpaClient.h"
#import "AFNetworking.h"


#define SHERPA_BASE_URL [NSURL URLWithString:@"http://gamma-usnc1.dht.yahoo.com:4080/"]


@implementation SherpaClient

+ (SherpaClient *)instance{
    static dispatch_once_t once;
    static SherpaClient *instance;
    
    dispatch_once(&once, ^{instance = [[SherpaClient alloc] initWithBaseURL:SHERPA_BASE_URL];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
    }
    return self;
}

// Sherpa API

- (void)userListWithUriPath:(NSString *)uriPath success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    // do nothing
    NSLog(@"Im here");
    NSMutableDictionary *params = nil;
    [self getPath:uriPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:failure];
    
}

- (void)userWithName:(NSString *)name success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"Im here");
    NSMutableDictionary *params = nil;
    NSMutableString *uriPath = [NSMutableString stringWithFormat:@"YDHTWebService/V1/get/MovieDB.MovieInterest/%@", name ];
    [self getPath:uriPath parameters:params success:success failure:failure];
    
}

- (void)saveUserWithName:(NSString *)name params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSLog(@"Im here");
    
    NSMutableString *uriPath = [NSMutableString stringWithFormat:@"YDHTWebService/V1/set/MovieDB.MovieInterest2/%@", name ];
    self.parameterEncoding = AFJSONParameterEncoding;
    [self postPath:uriPath parameters:params success:success failure:failure];
    
}

@end

