//
//  PostViewCell.h
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "KILabel.h"

@protocol tweetLinkProtocol <NSObject>
-(void)loadURL:(NSString *)urlString;
@end

@interface PostViewCell : UITableViewCell
@property (nonatomic, retain) id<tweetLinkProtocol> delegate;
@property (weak, nonatomic) IBOutlet KILabel *messageLabel;
@property (weak, nonatomic) IBOutlet KILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end
