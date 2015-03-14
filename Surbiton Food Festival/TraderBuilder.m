//
//  EventBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TraderBuilder.h"
#import "Trader.h"

@implementation TraderBuilder
+ (NSArray *)tradersFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *traders = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *traderDic in results) {
        Trader *trader = [[Trader alloc] init];
        
        for (NSString *key in traderDic) {
            if ([trader respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                // Avoid problems with fields called 'description'
                if ([mappedKey isEqualToString:@"description"]) {
                    mappedKey = @"desc";
                }
                [trader setValue:[traderDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [traders addObject:trader];
    }
    
    return traders;
}
@end
