//
//  User.h
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "RestObject.h"
#import "Movie.h"


@interface User : RestObject

- (NSString *)name;
- (NSMutableArray *)movies;
- (void)addWithInterest: (Movie *)Movie;

// current user functions
+ (void)setCurrentUser:(User *)user;
+ (User *)getCurrentUser;
+ (void)addMovieToCurrentUserWithTitle:(NSString *)title tmsId:(NSString *)movieId
                               theatre:(NSString *)theatre dateTime:(NSString *)dateTime;
+ (void)saveCurrentUser;

// all users functions
+ (User *)emptyUser;
+ (void)setUsers: (NSArray *)users;
+ (int)confirmCountForMovie:(NSString *)tile;
+ (int)interestCountForMovie:(NSString *)tile;
+ (NSString *)userListForMovieShowtime:(NSString *)title theatre:(NSString *)theatre time:(NSString *)time;
+ (NSString *)userFullListForMovieShowtime:(NSString *)title theatre:(NSString *)theatre time:(NSString *)time;
+ (void)usersWithArray:(NSArray *)array;
+ (NSMutableArray *)moviesWithArray:(NSArray *)array;
+ (void)reloadfromTableView:(UITableView *)tableView;


@end
