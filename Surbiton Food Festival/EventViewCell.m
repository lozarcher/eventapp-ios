//
//  EventViewCell.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "EventViewCell.h"
#import "Event.h"
#import "UIImageView+WebCache.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <Crashlytics/Crashlytics.h>

@implementation EventViewCell

@synthesize eventNameLabel, venueLabel, favouriteImage, favourited, event, eventImage;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.favourited = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.fd_enforceFrameLayout = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Event *)event isFavourite:(BOOL)isFavourite {
    self.event = event;
    
    self.eventImage.layer.cornerRadius = 5.0;
    self.eventImage.layer.masksToBounds = YES;
    
    if (![[event coverUrl] isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[event coverUrl]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [self.eventImage setImage:image];
                                if (error != nil) {
                                    [CrashlyticsKit recordError:error];
                                }
                            }];
    }

    
    eventNameLabel.text = [event name];
    
    NSTimeInterval seconds = [event.startTime doubleValue]/1000;
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *startDateString = [formatter stringFromDate:startDate];
    
    if ([startDateString isEqualToString:@"01:00"]) {
        startDateString = @"All day";
        NSLog(@"Set event %@ all day", event.name);
    }
    
    NSString *location = event.location;
    if ([location isKindOfClass:[NSNull class]]) {
        location = @"Surbiton";
    }
    venueLabel.text = [NSString stringWithFormat:@"%@ @ %@", startDateString, location];
    
    self.favourited = isFavourite;
    [self setFavouritedIcon:self.favourited];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favouriteImage setUserInteractionEnabled:YES];
    [self.favouriteImage addGestureRecognizer:singleTap];
    
}


-(void)favouriteTapDetected{
    self.favourited = !self.favourited;
    [self setFavouritedIcon:self.favourited];
    //trigger event

    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.event forKey:@"event"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"favouriteEvent"
     object:dict
     userInfo:dict];
    [Answers logContentViewWithName:[NSString stringWithFormat:@"Favourite: %@",event.name]
                        contentType:@"Favourite"
                          contentId:[NSString stringWithFormat:@"f%@",event.id]
                   customAttributes:@{}];
    }

-(void)setFavouritedIcon:(BOOL)favourited {
    FAKFontAwesome *favIcon;
    self.event.isFavourite = favourited;
    if (favourited) {
        favIcon = [FAKFontAwesome heartIconWithSize:21];
        [favIcon addAttribute:NSForegroundColorAttributeName value:[UIColor
                                                                     redColor]];
    } else {
        favIcon = [FAKFontAwesome heartOIconWithSize:21];
        [favIcon addAttribute:NSForegroundColorAttributeName value:[UIColor
                                                                     grayColor]];
    }
    [self.favouriteImage setImage:[favIcon imageWithSize:CGSizeMake(21,21)]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat leftSideHeight = 81;

    CGFloat rightSideHeight = 0;
    size.width = size.width - 140;
    rightSideHeight += [self.eventNameLabel sizeThatFits:size].height;
    rightSideHeight += [self.venueLabel sizeThatFits:size].height;
    rightSideHeight += 21;
    
    CGFloat totalHeight;
    if (rightSideHeight > leftSideHeight) {
        totalHeight = rightSideHeight;
    } else {
        totalHeight = leftSideHeight;
    }
    return CGSizeMake(size.width, totalHeight);
}

@end
