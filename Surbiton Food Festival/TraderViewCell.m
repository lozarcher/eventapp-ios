//
//  EventViewCell.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TraderViewCell.h"
#import "Trader.h"
#import "UIImageView+WebCache.h"

@implementation TraderViewCell

@synthesize traderNameLabel, traderImage, kingstonPoundImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)populateDataInCell:(Trader *)trader {
    //traderNameLabel.text = [trader name];
    [kingstonPoundImage setHidden:([trader.kingstonPound intValue] != 1)];
    traderNameLabel.text = [trader name];
        
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (![[trader profileImg] isKindOfClass:[NSNull class]]) {
        [manager downloadImageWithURL:[NSURL URLWithString:[trader profileImg]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [traderImage setImage:image];
                            }];
    } else {
        [traderImage setImage:[UIImage imageNamed:@"logo.jpg"]];
    }

}


@end
