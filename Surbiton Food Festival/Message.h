//
//  Message.h
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *profilePic;

-(NSDictionary *)dictionary;
@end
