//
//  EventViewCell.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "InfoViewCell.h"
#import "Info.h"
#import "UIImageView+WebCache.h"
#import <Crashlytics/Crashlytics.h>

@implementation InfoViewCell

@synthesize infoTitle, infoImage;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)populateDataInCell:(Info *)info {

    infoTitle.text = [info title];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (![[info thumb] isKindOfClass:[NSNull class]]) {
        [manager downloadImageWithURL:[NSURL URLWithString:[info thumb]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [infoImage setImage:image];
                                if (error != nil) {
                                    [CrashlyticsKit recordError:error];
                                }
                            }];
    } else {
        [infoImage setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
}


@end
