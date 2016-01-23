//
//  PostBuilder.m
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "PostBuilder.h"
#import "Post.h"

@implementation PostBuilder
+ (NSArray *)postsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Post *post = [[Post alloc] init];
        
        for (NSString *key in eventDic) {
            if ([post respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                [post setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [posts addObject:post];
    }
    
    return posts;
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
