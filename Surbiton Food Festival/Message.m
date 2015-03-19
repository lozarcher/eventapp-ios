//
//  Message.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize name, text, createdDate, profilePic;

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.name,@"name",self.text, @"text",self.profilePic, @"profilePic", nil];
}

@end
