//
//  VoucherBuilder.h
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoucherBuilder : NSObject
+ (NSArray *)vouchersFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
