//
//  TMSClient.m
//  MoviePlanner
//
//  Created by  on 8/20/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "TMSClient.h"
#import "AFNetworking.h"


#define TMS_BASE_URL [NSURL URLWithString:@"http://data.tmsapi.com/"]
#define TMS_CONSUMER_KEY @"kw2835r382zwka2r6fnjhun2"
#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@implementation TMSClient

+ (TMSClient *)instance{
    static dispatch_once_t once;
    static TMSClient *instance;
    
    dispatch_once(&once, ^{instance = [[TMSClient alloc] initWithBaseURL:TMS_BASE_URL];
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



// Statuses API

- (void)movieListWithZipCode:(NSString *)zipCode success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    // do nothing
    NSLog(@"Im here");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": TMS_CONSUMER_KEY}];
    [params setObject:zipCode forKey:@"zip"];
    [params setObject:@"3" forKey:@"radius"];
    [params setObject:@"mi" forKey:@"units"];
    [params setObject:@"2013-08-23" forKey:@"startDate"];

    [self getPath:@"v1/movies/showings" parameters:params success:success failure:failure];
    
}

@end
