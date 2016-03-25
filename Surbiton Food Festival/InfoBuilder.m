//
//  EventBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "InfoBuilder.h"
#import "Info.h"

@implementation InfoBuilder
+ (NSArray *)infoFromJson:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *infoItems = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *infoDic in results) {
        Info *info = [[Info alloc] init];
        
        for (NSString *key in infoDic) {
            if ([info respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                // Avoid problems with fields called 'description'
                if ([mappedKey isEqualToString:@"description"]) {
                    mappedKey = @"desc";
                }
                [info setValue:[infoDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [infoItems addObject:info];
    }
    
    return infoItems;
}
@end
