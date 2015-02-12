//
//  EventBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventBuilder.h"
#import "Event.h"

@implementation EventBuilder
+ (NSArray *)eventsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSDictionary *eventObject = [parsedObject valueForKey:@"events"];
    NSArray *results = [eventObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
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
        
        [events addObject:event];
    }
    
    return events;
}
@end
