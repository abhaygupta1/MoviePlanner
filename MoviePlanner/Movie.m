//
//  Movie.m
//  MoviePlanner
//
//  Created by  on 8/22/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "Movie.h"

#import "NSDictionary+CPAdditions.h"

@implementation Movie

- (id)movieId {
    return [self.data valueOrNilForKeyPath:@"tmsId"];
}


- (NSString *)title {
    return [self.data valueOrNilForKeyPath:@"title"];
}
- (NSString *)image {
    NSString *uri = @"file:///Users/abhayg/Desktop/142799H1.jpg";
    return uri;
}

+ (NSMutableArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [movies addObject:[[Movie alloc] initWithDictionary:params]];
    }
    return movies;
}


@end

