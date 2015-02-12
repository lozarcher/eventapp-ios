//
//  Event.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *start_time;
@property (strong, nonatomic) NSString *cover;

@end
