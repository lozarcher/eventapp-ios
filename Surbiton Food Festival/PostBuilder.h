//
//  PostBuilder.h
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostBuilder : NSObject

+ (NSArray *)postsFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSString *)nextPageFromJSON:(NSData *)objectNotation;

@end