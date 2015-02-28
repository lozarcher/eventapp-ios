//
//  VoucherBuilder.m
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VoucherBuilder.h"
#import "Voucher.h"

@implementation VoucherBuilder

+ (NSArray *)vouchersFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *vouchers = [[NSMutableArray alloc] init];
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *eventDic in results) {
        Voucher *voucher = [[Voucher alloc] init];
        
        for (NSString *key in eventDic) {
            if ([voucher respondsToSelector:NSSelectorFromString(key)]) {
                NSString *mappedKey = key;
                // Avoid problems with fields called 'description'
                if ([mappedKey isEqualToString:@"description"]) {
                    mappedKey = @"desc";
                }
                [voucher setValue:[eventDic valueForKey:key] forKey:mappedKey];
            }
        }
        
        [vouchers addObject:voucher];
    }
    
    return vouchers;
}

@end
