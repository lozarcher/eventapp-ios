//
//  EventBuilder.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoBuilder : NSObject
+ (NSArray *)infoFromJson:(NSData *)objectNotation error:(NSError **)error;

@end
