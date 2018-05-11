//
//  EventBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventBuilder.h"
#import "Event.h"
#import "Category.h"

@implementation EventBuilder
+ (NSDictionary *)eventsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    NSArray *eventResults = [parsedObject valueForKey:@"events"];
    NSLog(@"Count %lu events", (unsigned long)eventResults.count);
    
    int index = 0;
    for (NSDictionary *eventDic in eventResults) {
        Event *event = [[Event alloc] init];
        
        for (NSString *key in eventDic) {
            if ([event respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                // Avoid problems with fields called 'description'
                if ([mappedKey isEqualToString:@"description"]) {
                    mappedKey = @"desc";
                }
                [event setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        event.ordinal = index;
        [events addObject:event];
        index++;
    }
    
    NSArray *categoryResults = [parsedObject valueForKey:@"categories"];
    NSLog(@"Count %lu categories", (unsigned long)categoryResults.count);
    for (NSDictionary *categoryDic in categoryResults) {
        Category *category = [[Category alloc] init];
        
        for (NSString *key in categoryDic) {
            if ([category respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                [category setValue:[categoryDic valueForKey:key] forKey:mappedKey];
            }
        }
        [categories addObject:category];
    }
    
    NSDictionary *eventFeed = [[NSDictionary alloc] initWithObjectsAndKeys:events, @"events", categories, @"categories", nil];
    return eventFeed;
}
@end
