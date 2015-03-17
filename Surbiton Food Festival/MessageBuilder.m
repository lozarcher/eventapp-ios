//
//  MessageBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "Message.h"
#import "MessageBuilder.h"

@implementation MessageBuilder
+ (NSArray *)messagesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    //NSDictionary *eventObject = [parsedObject valueForKey:@"events"];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Message *message = [[Message alloc] init];
        
        for (NSString *key in eventDic) {
            if ([message respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                [message setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [messages addObject:message];
    }
    
    return messages;
}

+ (NSString *)nextPageFromJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        return nil;
    }
    
    NSString *nextPage = [parsedObject valueForKey:@"next"];
    NSLog(@"Got next page url: %@", nextPage);
    
    return nextPage;
}

@end
