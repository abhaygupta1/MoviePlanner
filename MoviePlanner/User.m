//
//  User.m
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "User.h"
#import "Movie.h"
#import "SherpaClient.h"
#import "NSDictionary+CPAdditions.h"


@implementation User
static NSString *uriPath;
static User *currentUser;

- (NSString *)name {
    return [self.data valueOrNilForKeyPath:@"key"];
}
- (NSArray *)confirmed {
    return [[self.data valueOrNilForKeyPath:@"confirmed"] valueOrNilForKeyPath:@"value"];
}

+ (NSMutableArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [movies addObject:[[Movie alloc] initWithDictionary:params]];
    }
    return movies;
}

- (NSString *)interested {
    return [[self.data valueOrNilForKeyPath:@"interested"] valueOrNilForKeyPath:@"value"];
}

+ (NSMutableArray *)usersWithArray:(NSArray *)array {
    NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [users addObject:[[User alloc] initWithDictionary:params]];
    }
    return users;
}
+ (void) setUriPath:(NSString *)uriPath{
    User.uriPath = uriPath;
}
+ (void) setCurrentUser:(User *)user{
    currentUser = user;
}

+ (User *) getCurrentUser {
    return currentUser;
}

+(void)loadCurrentUser: (NSString *)name {

[[SherpaClient instance] userWithName:@"abhay" success:^(AFHTTPRequestOperation *operation, id response) {
    id payload = [NSJSONSerialization JSONObjectWithData:response options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"The response is %@", payload);
    
    NSDictionary *params = [payload valueForKey:@"ydht"];
    NSLog(@"The params are %@", params);
    NSLog(@"The user fields are %@", [params valueForKey:@"fields"]);
    
    
    User.currentUser = [[User alloc] initWithDictionary:[params valueForKey:@"fields"]];
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    // Do nothing
    NSLog(@"The response is %@", error);
}];
}

+(void)saveCurrentUser {
    NSMutableDictionary *confirmed = [[NSMutableDictionary alloc] init];
    [confirmed setObject:[User getCurrentUser].confirmed forKey:@"value"];
    NSMutableDictionary *interested = [[NSMutableDictionary alloc] init];
    [interested setObject:[User getCurrentUser].confirmed forKey:@"value"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:confirmed forKey:@"confirmed"];
    [params setObject:interested forKey:@"interested"];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:params forKey:@"fields"];
    NSMutableDictionary *ydht = [[NSMutableDictionary alloc] init];
    [ydht setObject:fields forKey:@"ydht"];
   
    
    [[SherpaClient instance] saveUserWithName:@"sameer1" params:ydht success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"Successful");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"The response is %@", error);
    }];
}



+ (void)loadUsers {
    uriPath = @"YDHTWebService/V1/ordered_scan/MovieDB.MovieInterest?order=asc&start_key=a";
    for (int j = 0; j < 3; j++) {
        [[SherpaClient instance] userListWithCount:5 uriPath:uriPath success:^(AFHTTPRequestOperation *operation, id response) {
            id payload = [NSJSONSerialization JSONObjectWithData:response options:NSJSONWritingPrettyPrinted error:nil];
            NSLog(@"The response is %@", payload);
            
            NSDictionary *params = [payload valueForKey:@"ydht"];
            NSLog(@"The features are %@", [params valueForKey:@"records"]);
            NSMutableArray *users = [User  usersWithArray: [params valueForKey:@"records"]];
            
            
            NSLog(@"The length is %d", users.count);
            //for (int i = 0; i < self.users.count; i++) {
              //  NSLog(@"The key is %@", ((User *)(self.users[i])).name);
            //}
            
            //self.confirmedMovies = [User moviesWithArray:((User *)(self.users[0])).confirmed];
            //self.interestedMovies = [User moviesWithArray:((User *)(self.users[0])).interested];
            NSDictionary *continuation = [params valueForKey:@"continuation"];
            uriPath = [continuation valueForKey:@"uri_path"];
            id scanCompleted = [continuation valueForKey:@"scan_completed"];
            NSLog(@"URIPath is %@ status is %@", uriPath, scanCompleted);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // Do nothing
            NSLog(@"The response is %@", error);
        }];
    }
    
}

@end
