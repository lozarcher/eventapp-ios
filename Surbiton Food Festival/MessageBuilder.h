//
//  MessageBuilder.h
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBuilder : NSObject
+ (NSArray *)messagesFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSString *)nextPageFromJSON:(NSData *)objectNotation;

@end
