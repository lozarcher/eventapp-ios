//
//  TweetBuilder.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TweetBuilder.h"
#import "Tweet.h"

@implementation TweetBuilder
+ (NSArray *)tweetsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    //NSDictionary *eventObject = [parsedObject valueForKey:@"events"];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Tweet *tweet = [[Tweet alloc] init];
        
        for (NSString *key in eventDic) {
            if ([tweet respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                [tweet setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [tweets addObject:tweet];
    }
    
    return tweets;
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
