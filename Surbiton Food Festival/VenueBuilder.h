//
//  VenueBuilder.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueBuilder : NSObject
+ (NSArray *)venuesFromJSON:(NSData *)objectNotation error:(NSError **)error;
@end
