//
//  Venue.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *location;

@end
