//
//  Post.h
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Post : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *pictureUrl;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) UIImage *cachedImage;

@end
