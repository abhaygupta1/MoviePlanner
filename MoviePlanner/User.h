//
//  User.h
//  MoviePlanner
//
//  Created by  on 8/24/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "RestObject.h"

@interface User : RestObject

+ (NSMutableArray *)users;
- (NSString *)name;
- (NSArray *)confirmed;
+ (NSMutableArray *)moviesWithArray:(NSArray *)array;
- (NSArray *)interested;

+ (NSMutableArray *)usersWithArray:(NSArray *)array;
+ (void)loadUsers;

+ (void)setCurrentUser:(User *)user;
+ (User *) getCurrentUser;
+(void)loadCurrentUser: (NSString *)name;
+(void)saveCurrentUser;
//+ (NSString *)uriPath;

@end
