//
//  Movie.h
//  MoviePlanner
//
//  Created by  on 8/22/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "RestObject.h"

@interface Movie : RestObject

- (BOOL) isEmpty;
- (NSString *)movieId;
- (NSString *)title;
- (NSString *)image;
- (NSString *)theatre;
- (NSString *)dateTime;
- (NSMutableArray *)arrayWithShowtimesRaw;
- (NSMutableArray *)arrayWithShowtimeStrings;
- (NSString *)stringWithShowtime;

+ (Movie *)emptyMovie;
+ (NSMutableArray *)moviesWithArray:(NSArray *)array;
+ (NSArray *)data:(NSArray *)movies;


@end
