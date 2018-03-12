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
#import "UITableView+FDTemplateLayoutCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation PostViewCell

@synthesize messageLabel, delegate, linkLabel, dateLabel, cardView, postImageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.bounds = [UIScreen mainScreen].bounds;

    self.fd_enforceFrameLayout = YES;

    // Initialization code
    messageLabel.urlLinkTapHandler = ^(KILabel *label, NSString *urlString, NSRange range) {
        NSLog(@"Clicked link");
        [self.delegate loadURL:urlString];

    };
}

-(void)populateDataInCell:(Post *)post indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    //traderNameLabel.text = [trader name];
    self.tableView = tableView;
    self.indexPath = indexPath;
    
    self.textLabel.text = @"";
    NSString *message = @"";
    if (![[post message] isKindOfClass:[NSNull class]]) {
        message = [post message];
    }
    
    __weak typeof(self) weakSelf = self;

    if (![[post pictureUrl] isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if (self.postImageView.image == nil) {
            [manager downloadImageWithURL:[NSURL URLWithString:[post pictureUrl]] options:0
                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf setPostImage:image];
                    });
                                    
                }
                }];
        } else {
        }
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
    NSLog(@"POST %@", self.messageLabel.text);

    
                if (self.postImageView.frame.size.width < (self.postImageView.image.size.width)) {
                    self.imageHeightConstraint.constant = self.postImageView.frame.size.width / (self.postImageView.image.size.width) * (self.postImageView.image.size.height);
                } else {
                    self.imageHeightConstraint.constant = image.size.height;
                }
    
    [self.postImageView setImage:image];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat newFrameWidth = screenRect.size.width;
    CGFloat newFrameHeight = image.size.height * (newFrameWidth / image.size.width);
    CGRect newFrame = CGRectMake(0, 0, newFrameWidth, newFrameHeight);
    [self.postImageView setFrame:newFrame];
    
    NSLog(@"IMAGE SIZE %f %f", image.size.width, image.size.height);
    NSLog(@"FITTING INTO FRAME SIZE %f %f", newFrameWidth, newFrameHeight);
    
    self.imageHeightConstraint.constant = newFrameHeight;
    self.postImageHeight = newFrameHeight;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//    NSLog(@"OLD FRAME %f %f", self.postImageView.frame.size.width, self.postImageView.frame.size.height);
//    NSLog(@"IMAGE SIZE %f %f", image.size.width, image.size.height);
//
//    CGRect newFrame = AVMakeRectWithAspectRatioInsideRect(image.size, self.postImageView.frame);
//    NSLog(@"NEW FRAME %f %f", newFrame.size.width, newFrame.size.height);
//    [self.postImageView setFrame:newFrame];
//
//
//    NSLog(@"NEW FRAME AFTER SETTING %f %f", self.postImageView.frame.size.width, self.postImageView.frame.size.height);
//
//    //self.imageHeightConstraint.constant = newFrame.size.height;
//
//    //self.postImageHeight = newFrame.size.height;
//    //self.postImageHeight = self.imageHeightConstraint.constant;
//    NSLog(@"New Frame height %f", newFrame.size.height);
//    NSLog(@"New height constraint %f", self.postImageHeight);
//
//    self.imageHeightConstraint.constant = newFrame.size.height;
//    [self setNeedsLayout];
//    
//    [self.postImageView setImage:image];
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.dateLabel sizeThatFits:size].height;
    NSLog(@"Sizing datelabel : %f", [self.dateLabel sizeThatFits:size].height);
    totalHeight += [self.messageLabel sizeThatFits:size].height;
    NSLog(@"Sizing messageLabel : %f", [self.messageLabel sizeThatFits:size].height);

    totalHeight += self.postImageView.frame.size.height;
    NSLog(@"Sizing postImageView : %f", self.postImageView.frame.size.height);

//    totalHeight += self.postImageHeight;
//    NSLog(@"Sizing postImageHeight : %f", self.postImageHeight);
//
    //NSLog(@"Setting height %f", self.postImageHeight);
//    totalHeight += [self.postImageView sizeThatFits:size].height;
//    NSLog(@"Sizing postImageView : %f", [self.postImageView sizeThatFits:size].height);
//
    totalHeight += 40.0; // margins
    NSLog(@"Sizing margins : %f", 40.0);

    NSLog(@"Setting total height %f",totalHeight);

    return CGSizeMake(size.width, totalHeight);
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
