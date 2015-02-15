//
//  TweetBuilder.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetBuilder : NSObject
+ (NSArray *)tweetsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
