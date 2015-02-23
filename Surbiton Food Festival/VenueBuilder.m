//
//  VenueBuilder.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VenueBuilder.h"
#import "Venue.h"

@implementation VenueBuilder

+ (NSArray *)venuesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *venues = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Venue *venue = [[Venue alloc] init];
        
        for (NSString *key in eventDic) {
            if ([venue respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                // Avoid problems with fields called 'description'
                if ([mappedKey isEqualToString:@"description"]) {
                    mappedKey = @"desc";
                }
                [venue setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [venues addObject:venue];
    }
    
    return venues;
}

@end
