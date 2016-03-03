//
//  Post.h
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gallery : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *createdDate;

@end
