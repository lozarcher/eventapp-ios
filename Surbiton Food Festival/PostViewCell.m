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
    [super awakeFromNib];
    // Initialization code
    messageLabel.urlLinkTapHandler = ^(KILabel *label, NSString *urlString, NSRange range) {
        NSLog(@"Clicked link");
        [self.delegate loadURL:urlString];
        
    };
}

-(void)populateDataInCell:(Post *)post indexPath:(NSIndexPath *)indexPath {
    //traderNameLabel.text = [trader name];
    self.textLabel.text = @"";
    NSString *message = @"";
    if (![[post message] isKindOfClass:[NSNull class]]) {
        message = [post message];
    }
    if (![[post pictureUrl] isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[post pictureUrl]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [self setPostImage:image];
                            }];
    } else {
    }
    if (![[post link] isKindOfClass:[NSNull class]]) {
        if ([message isEqualToString:@""]) {
            message = [post link];
        } else {
            // dedupe links if already present in message
            if (![message containsString:[post link]]) {
                message = [NSString stringWithFormat:@"%@\n\n%@", message, [post link]];
            }
        }
    }
    
    if (![[post createdDate] isKindOfClass:[NSNull class]]) {
        NSTimeInterval createdSeconds = [post.createdDate doubleValue]/1000;
        NSDate *createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:createdSeconds];
        self.dateLabel.text = [self dateDiff:createdDate];
    }
    
    self.messageLabel.text = message;
}

-(void)setPostImage:(UIImage *)image {
    NSLog(@"Image width %f height %f", self.postImageView.image.size.width, self.postImageView.image.size.height);
    NSLog(@"ImageView width %f height %f", self.postImageView.frame.size.width, self.postImageView.frame.size.height);
    if (self.postImageView.frame.size.width < (self.postImageView.image.size.width)) {
        self.imageHeightConstraint.constant = self.postImageView.frame.size.width / (self.postImageView.image.size.width) * (self.postImageView.image.size.height);
    } else {
        self.imageHeightConstraint.constant = image.size.height;
    }
    [self.postImageView setImage:image];
    [self setNeedsUpdateConstraints];
    
}

-(NSString *)dateDiff:(NSDate *)date {
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"Just now";
    } else     if (ti < 60) {
        return @"Just now";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        if (diff == 1) {
            return [NSString stringWithFormat:@"%d minute ago", diff];
        } else {
            return [NSString stringWithFormat:@"%d minutes ago", diff];
        }
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if (diff == 1) {
            return[NSString stringWithFormat:@"%d hour ago", diff];
        } else {
            return[NSString stringWithFormat:@"%d hours ago", diff];
        }
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        if (diff == 1) {
            return[NSString stringWithFormat:@"%d day ago", diff];
        } else {
            return[NSString stringWithFormat:@"%d days ago", diff];
        }
    } else {
        int diff = round(ti / 60 / 60 / 24 / 30);
        if (diff == 1) {
            return[NSString stringWithFormat:@"%d month ago", diff];
        } else {
            return[NSString stringWithFormat:@"%d months ago", diff];
        }
    }
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
