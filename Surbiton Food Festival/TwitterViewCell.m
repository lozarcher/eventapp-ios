//
//  TwitterViewCell.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 02/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TwitterViewCell.h"
#import "UIImageView+WebCache.h"
#import "TweetLinkViewController.h"

@implementation TwitterViewCell

@synthesize nameLabel, profilePic, textLabel, screennameLabel, dateCreatedLabel, delegate;

- (void)awakeFromNib {
    // Initialization code
    textLabel.linkURLTapHandler = ^(KILabel *label, NSString *urlString, NSRange range) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];//Load the url in Safari
        NSLog(@"Clicked link");
        [self.delegate loadURL:urlString];
        
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Tweet *)tweet {
    
    nameLabel.text = tweet.name;
    screennameLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    textLabel.text = tweet.text;
    
    profilePic.frame = self.imageView.bounds;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSLog(@"Setting pic image %@", tweet.profilePic);
    [manager downloadImageWithURL:[NSURL URLWithString:[tweet profilePic]] options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [profilePic setImage:image];
                        }];
    
    NSTimeInterval createdSeconds = [tweet.createdDate doubleValue]/1000;
    NSDate *createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:createdSeconds];
    
    dateCreatedLabel.text = [self dateDiff:createdDate];
}

-(NSString *)dateDiff:(NSDate *)date {
    NSDate *todayDate = [NSDate date];
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
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
