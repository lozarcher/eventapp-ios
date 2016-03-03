//
//  PostViewCell.m
//  IYAF 2015
//
//  Created by Loz Archer on 29/05/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "PostViewCell.h"
#import "Post.h"
#import "UIImageView+WebCache.h"

@implementation PostViewCell

@synthesize messageLabel, delegate, linkLabel, dateLabel, cardView, postImageView;

- (void)awakeFromNib {
    // Initialization code
    messageLabel.urlLinkTapHandler = ^(KILabel *label, NSString *urlString, NSRange range) {
        NSLog(@"Clicked link");
        [self.delegate loadURL:urlString];
        
    };
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
