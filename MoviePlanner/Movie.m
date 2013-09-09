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


- (BOOL) isEmpty {
    return[[self title] isEqualToString:@" "];
}

- (id)movieId {
    if ([self.data valueOrNilForKeyPath:@"tmsId"] != nil) {
        return [self.data valueOrNilForKeyPath:@"tmsId"];
    }
    else
        return @"dummy id";
}

- (NSString *)title {
    return [self.data valueOrNilForKeyPath:@"title"];
}

- (NSString *)image {
    NSString *uri = @"file:///Users/abhayg/Desktop/142799H1.jpg";
    return uri;
}

- (NSString *)theatre {
    return [self.data valueOrNilForKeyPath:@"theatre"];
}

- (NSString *)dateTime {
    return [self.data valueOrNilForKeyPath:@"dateTime"];
}


-(NSMutableArray *)arrayWithShowtimesRaw {
    NSMutableArray *_showtimesArray = [self.data valueOrNilForKeyPath:@"showtimes"];
    return  _showtimesArray;
}

-(NSMutableArray *)arrayWithShowtimeStrings {
    NSMutableArray *_showtimes = [self.data valueOrNilForKeyPath:@"showtimes"];
    NSMutableArray *showTimeArray = [[NSMutableArray alloc] initWithCapacity:_showtimes.count];
    
    for (NSDictionary *showtime in  _showtimes) {
        NSString *datetime = [showtime valueOrNilForKeyPath:@"dateTime"];
        NSDictionary *theatre = [showtime valueOrNilForKeyPath:@"theatre"];
        NSString *theatreName = [theatre valueOrNilForKeyPath:@"name"];
        NSString *time = [datetime substringFromIndex:11];
        [showTimeArray addObject:[NSString stringWithFormat:@"%@ at %@", theatreName, time]];
    }
    return  showTimeArray;
}


-(NSString *)stringWithShowtime {
    
    NSString *datetime = [self valueOrNilForKeyPath:@"dateTime"];
    NSString *theatreName = [self valueOrNilForKeyPath:@"theatre"];
    NSString *time = [datetime substringFromIndex:11];
    return [NSString stringWithFormat:@"%@ at %@", theatreName, time];
}


+ (Movie *)emptyMovie {
    NSDictionary *params = [[NSDictionary alloc]
                                   initWithObjectsAndKeys:@" ", @"title", @" ",  @"theatre", @" ", @"dateTime",
                            @" ", @"tmsId", nil];
    return [[Movie alloc] initWithDictionary:params];
}

+ (NSMutableArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [movies addObject:[[Movie alloc] initWithDictionary:params]];
    }
    return movies;
}

+ (NSArray *)data:(NSArray *)movies {
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:movies.count];
    for (Movie *movie in movies) {
        [dataArray addObject:movie.data];
    }
    return dataArray;
}




@end

