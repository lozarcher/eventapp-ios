//
//  MessageViewCell.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "MessageViewCell.h"
#import "Message.h"
#import "UIImageView+WebCache.h"

@implementation MessageViewCell

@synthesize nameLabel, profilePic, textLabel, dateCreatedLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Message *) message {
    
    nameLabel.text = message.name;
    textLabel.text = message.text;
    
    profilePic.frame = self.imageView.bounds;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSLog(@"Setting pic image %@", message.profilePic);
    [manager downloadImageWithURL:[NSURL URLWithString:[message profilePic]] options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [profilePic setImage:image];
                        }];
    
    NSTimeInterval createdSeconds = [message.createdDate doubleValue]/1000;
    NSDate *createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:createdSeconds];
    
    dateCreatedLabel.text = [self dateDiff:createdDate];
}

-(NSString *)dateDiff:(NSDate *)date {
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if (ti < 60) {
        return @"now";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%dd", diff];
    } else {
        return @"";
    }
}
@end
