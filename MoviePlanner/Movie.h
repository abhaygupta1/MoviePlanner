//
//  Movie.h
//  MoviePlanner
//
//  Created by  on 8/22/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "RestObject.h"

@interface Movie : RestObject

- (NSString *)title;
- (NSString *)image;

+ (NSMutableArray *)moviesWithArray:(NSArray *)array;
@end
