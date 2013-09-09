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
//#define TMS_CONSUMER_KEY @"kw2835r382zwka2r6fnjhun2"
//#define TMS_CONSUMER_KEY @"cxtgyen3r6k8dd44rmhcgyqa"
#define TMS_CONSUMER_KEY @"tpnb5uykmaqdbhc5pjzjb5mp"
//#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"


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



// TMS API to get the movies

- (void)movieListWithZipCode:(NSString *)zipCode success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"api_key": TMS_CONSUMER_KEY}];
    [params setObject:zipCode forKey:@"zip"];
    [params setObject:@"3" forKey:@"radius"];
    [params setObject:@"mi" forKey:@"units"];
    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSLog(@"The date is %@", [dateFormatter stringFromDate:[NSDate date]]);
    [params setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"startDate"];

    [self getPath:@"v1/movies/showings" parameters:params success:success failure:failure];
    
}

@end
