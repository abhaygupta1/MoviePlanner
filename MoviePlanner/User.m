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
static NSMutableArray *_users;
static NSString *myName = @"abhay";

- (NSString *)name {
    return [self.data valueOrNilForKeyPath:@"key"];
}
- (NSMutableArray *)movies {
    return [self.data valueOrNilForKeyPath:@"movies"];
}
-(void)addWithInterest: (Movie *)Movie {
    NSLog(@"Adding new movie");
    [[self movies] insertObject:Movie atIndex:1];
    NSLog(@"Added New Movie");
}

// current user functions

+ (User *) emptyUser {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    [movies addObject:[Movie emptyMovie]];
    NSDictionary *params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:myName, @"key", movies,  @"movies", nil];
    return [[User alloc] initWithDictionary:params];
}

+ (void) setCurrentUser:(User *)user{
    NSLog(@"Set user called with %@", user);
    currentUser = user;
}

+ (User *) getCurrentUser {
    return currentUser;
}

+(void)addMovieToCurrentUserWithTitle:(NSString *)title tmsId:(NSString *)movieId
                              theatre:(NSString *)theatre dateTime:(NSString *)dateTime {
    NSMutableArray *movies = [User getCurrentUser].movies;
    for (Movie *movie in movies) {
        if ([title isEqualToString:movie.title] && [theatre isEqualToString:movie.theatre]
            && [dateTime isEqualToString:movie.dateTime])
            return;
    }
    Movie *movie = [[Movie alloc] initWithDictionary: [[NSDictionary alloc]
                                                       initWithObjectsAndKeys:title, @"title", movieId, @"tmsId",
                                                       theatre, @"theatre", dateTime, @"dateTime", nil]];
    NSLog(@"The new movie is %@", movie);
    [movies insertObject:movie atIndex:1];
}

+(void)saveCurrentUser {
    NSMutableDictionary *movies = [[NSMutableDictionary alloc] init];
    [movies setObject:[Movie data:[User getCurrentUser].movies] forKey:@"value"];
    //[movies setObject:@"Hello" forKey:@"value"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:movies forKey:@"movies"];
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:params forKey:@"fields"];
    NSMutableDictionary *ydht = [[NSMutableDictionary alloc] init];
    [ydht setObject:fields forKey:@"ydht"];
    
    [[SherpaClient instance] saveUserWithName:myName params:ydht success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"Successful");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"The response is %@", error);
    }];
}

// all users functions
+ (void)setUsers:(NSMutableArray *)users {
    _users = users;
}


+(int)confirmCountForMovie:(NSString *)title {
    int confirmedCounter = 0;
    for (User *user in _users){
        Movie *confirmedMovie = user.movies[0];
        if ([title isEqualToString:confirmedMovie.title]) {
            confirmedCounter++;
        }
    }
    return confirmedCounter;
}

+(int)interestCountForMovie:(NSString *)title {
    int interestedCounter = 0;
    for (User *user in _users){
        for (int movieId = 1; movieId < user.movies.count; movieId++) {
            Movie *interestedMovie = user.movies[movieId];
            if ([title isEqualToString:interestedMovie.title]) {
                interestedCounter++;
            }
        }
    }
    return interestedCounter;
}

+(NSString *)userListForMovieShowtime:(NSString *)title theatre:(NSString *)theatre time:(NSString *)time {
    NSMutableArray *confirmed = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *interested = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (User *user in _users){
        Movie *confirmedMovie = user.movies[0];
        if ([title isEqualToString:confirmedMovie.title] && [theatre isEqualToString:confirmedMovie.theatre]
            && [time isEqualToString:confirmedMovie.dateTime]) {
            [confirmed addObject:user.name];
        }
    }
    for (User *user in _users){
        for (int i = 1; i < user.movies.count; i++) {
            Movie *interestedMovie = user.movies[i];
            if ([title isEqualToString:interestedMovie.title] && [theatre isEqualToString:interestedMovie.theatre]
                && [time isEqualToString:interestedMovie.dateTime]) {
                [interested addObject:user.name];
            }
        }
    }
    
    NSString *userList = @"No interest yet";
    switch (confirmed.count) {
        case 0:
            switch (interested.count) {
                case 0:
                    userList = [NSString stringWithFormat:@"No interest yet"];
                    break;
                case 1:
                    userList = [NSString
                                stringWithFormat:@"%@ is interested",
                                interested[0]];
                    break;
                case 2:
                    userList = [NSString
                                stringWithFormat:@"%@ and %@ are interested",
                                interested[0], interested[1]];
                    break;
                    
                default:
                    userList = [NSString
                                stringWithFormat:@"%@, %@ and %d more are interested",
                                interested[0], interested[1], interested.count - 2];
                    break;
                    
            }
            break;
        case 1:
            switch (interested.count) {
                case 0:
                    userList = [NSString stringWithFormat:@"%@ is confirmed", confirmed[0]];
                    break;
                case 1:
                    userList = [NSString
                                stringWithFormat:@"%@ is confirmed and %@ is interested",
                                confirmed[0], interested[0]];
                    break;
                case 2:
                    userList = [NSString
                                stringWithFormat:@"%@ is confirmed, %@ and %@ are interested",
                                confirmed[0], confirmed[1], interested[0], interested[1]];
                    break;
                    
                default:
                    userList = [NSString
                                stringWithFormat:@"%@ is confirmed, %@, %@ and %d more are interested",
                                confirmed[0], interested[0], interested[1], interested.count - 2];
                    break;
                    
            }
            break;
        case 2:
            switch (interested.count) {
                case 0:
                    userList = [NSString stringWithFormat:@"%@ and %@ are confirmed", confirmed[0], confirmed[1]];
                    break;
                case 1:
                    userList = [NSString
                                stringWithFormat:@"%@ and %@ are confirmed and %@ is interested",
                                confirmed[0], confirmed[1], interested[0]];
                    break;
                case 2:
                    userList = [NSString
                                stringWithFormat:@"%@ and %@ are confirmed and %@ and %@ are interested",
                                confirmed[0], confirmed[1], interested[0], interested[1]];
                    break;
                    
                default:
                    userList = [NSString
                                stringWithFormat:@"%@ and %@ are confirmed and %@ and %d more are interested",
                                confirmed[0], confirmed[1], interested[0], interested.count - 1];
                    break;
                    
            }
            break;
        default:
            switch (interested.count) {
                case 0:
                    userList = [NSString stringWithFormat:@"%@, %@ and %d are confirmed", confirmed[0], confirmed[1],
                                confirmed.count - 2];
                    break;
                case 1:
                    userList = [NSString
                                stringWithFormat:@"%@, %@ and %d more are confirmed and 1 is interested", confirmed[0], confirmed[1],
                                confirmed.count - 2];
                    break;
                case 2:
                    userList = [NSString
                                stringWithFormat:@"%@, %@ and %d more are confirmed and 2 are interested",
                                confirmed[0], confirmed[1],
                                confirmed.count - 2];
                    break;
                    
                default:
                    userList = [NSString
                                stringWithFormat:@"%@, %@ and %d more are confirmed and %d are interested",
                                confirmed[0], confirmed[1],
                                confirmed.count - 2, interested.count];
                    break;
                    
            }
            break;
    }
    NSLog(@"The user list is %@", userList);
    return userList;
}

+(NSString *)userFullListForMovieShowtime:(NSString *)title theatre:(NSString *)theatre time:(NSString *)time {
    NSMutableString *confirmed = [[NSMutableString alloc] init];
    NSMutableString *interested = [[NSMutableString alloc] init];
    bool foundConfirmed = NO;
    bool foundInterested = NO;
    for (User *user in _users){
        Movie *confirmedMovie = user.movies[0];
        if ([title isEqualToString:confirmedMovie.title] && [theatre isEqualToString:confirmedMovie.theatre]
            && [time isEqualToString:confirmedMovie.dateTime]) {
            if (foundConfirmed) {
                [confirmed appendString:@", "];
            }
            [confirmed appendString:user.name];
            foundConfirmed = YES;
        }
    }
    for (User *user in _users){
        for (int i = 1; i < user.movies.count; i++) {
            Movie *interestedMovie = user.movies[i];
            if ([title isEqualToString:interestedMovie.title] && [theatre isEqualToString:interestedMovie.theatre]
                && [time isEqualToString:interestedMovie.dateTime]) {
                if (foundInterested) {
                    [interested appendString:@", "];
                }
                [interested appendString:user.name];
                foundInterested = YES;
            }
        }
    }
    
    NSString *userList = nil;
    if (foundConfirmed && foundInterested) {
        userList = [NSString stringWithFormat:@"Confirmed: %@\nInterested: %@", confirmed, interested];
    }
    else if (foundConfirmed && !foundInterested) {
        userList = [NSString stringWithFormat:@"Confirmed: %@", confirmed];
    }
    else if (!foundConfirmed && foundInterested) {
        userList = [NSString stringWithFormat:@"Interested: %@", interested];
    }
    else {
        userList = @"No interest yet";
    }
    return userList;
}

+ (void)usersWithArray:(NSArray *)array {
    if (_users == nil) {
        _users = [[NSMutableArray alloc] initWithCapacity:array.count];
    }
    
    for (NSDictionary *params in array) {
        NSMutableDictionary *userParams = [NSMutableDictionary dictionaryWithDictionary:@{@"key": [params valueForKey:@"key"]}];
        NSDictionary *fields = [params valueForKey:@"fields"];
        NSMutableArray *movies = [[NSMutableArray alloc] initWithArray:[User moviesWithArray:[[fields valueForKey:@"movies"] valueForKey:@"value"]]];
        NSLog(@"The count of movies is %d", movies.count);
        [userParams setObject:movies forKey:@"movies"];
        User *user = [[User alloc] initWithDictionary:userParams];
        
        NSLog(@"The user is %@", [userParams valueForKey:@"key"]);
        
        if ([myName isEqualToString:[userParams valueForKey:@"key"]]) {
            [User setCurrentUser:user];
            NSLog(@"The current user is %@", [User getCurrentUser]);
        }
        else {
            [_users addObject:[[User alloc] initWithDictionary:userParams]];
        }
    }
}

+ (NSMutableArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        //NSLog(@"Adding Movie %@", params);
        [movies addObject:[[Movie alloc] initWithDictionary:params]];
    }
    return movies;
}

#pragma mark - Reload Services

+ (void)reloadWithUriPath:(NSString *)uriPath  tableView:(UITableView *)tableView {
    
    static NSString *localPath;
    localPath = uriPath;
    
    [[SherpaClient instance] userListWithUriPath:(NSString *)localPath success:^(AFHTTPRequestOperation *operation, id response){
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:response
                                                                options:NSJSONReadingMutableContainers error:nil];
        
        //NSLog(@"Response is %@", payload);
        NSDictionary *params = [payload valueForKey:@"ydht"];
        NSDictionary *records = [params valueForKey:@"records"];
        if (records.count != 0) {
            [User usersWithArray: (NSArray *)records];
        }
        
        NSDictionary *continuation = [params valueForKey:@"continuation"];
        NSNumber *scanComplete = [continuation valueForKey:@"scan_completed"];
        NSLog(@"Continuation: %@", scanComplete);
        
        
        
        if ([scanComplete intValue] == 0) {
            NSLog(@"Continuing");
            localPath = [continuation valueForKey:@"uri_path"];
            [User reloadWithUriPath:localPath tableView:tableView];
        }
        else {
            [User saveCurrentUser];
            NSLog(@"Called Reload");
            NSLog(@"Current User: %@", [User getCurrentUser]);
            [tableView reloadData];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        // Do nothing
    }];
    
    
}

// wrapper function
+ (void)reloadfromTableView:(UITableView *)tableView {
    
    // Initialize current user to be an empty user
    [User setCurrentUser:[User emptyUser]];
    
    NSString *uriPath = @"/YDHTWebService/V1/ordered_scan/MovieDB.MovieInterest2?order=asc&start_key=a";
    [User setUsers:(NSMutableArray *)nil];
    [self reloadWithUriPath: uriPath tableView:(UITableView *)tableView];
}


@end
