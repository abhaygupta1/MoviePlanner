//
//  RestObject.h
//  MoviePlanner
//
//  Created by  on 8/22/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface RestObject (ForwardedMethods)

- (id)objectForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;
- (NSString *)JSONString;

@end
