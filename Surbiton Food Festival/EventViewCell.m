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

@implementation EventViewCell

@synthesize eventNameLabel, eventTimeLabel, venueLabel, eventImage, favouriteImage, favourited, event;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.favourited = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Event *)event isFavourite:(BOOL)isFavourite {
    self.event = event;
    eventNameLabel.text = [event name];
    
    NSTimeInterval seconds = [event.startTime doubleValue]/1000;
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *startDateString = [formatter stringFromDate:startDate];
    
    if ([startDateString isEqualToString:@"01:00"]) {
        startDateString = @"All day";
    }
    
    NSString *location = event.location;
    if ([location isKindOfClass:[NSNull class]]) {
        location = @"Surbiton";
    }
    venueLabel.text = [NSString stringWithFormat:@"%@ @ %@",startDateString, location];

    self.favourited = isFavourite;
    [self setFavouritedIcon:self.favourited];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favouriteImage setUserInteractionEnabled:YES];
    [self.favouriteImage addGestureRecognizer:singleTap];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (![[event profileUrl] isKindOfClass:[NSNull class]]) {
        [manager downloadImageWithURL:[NSURL URLWithString:[event profileUrl]] options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [eventImage setImage:image];
                        }];
    } else {
        [eventImage setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
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
    }

-(void)setFavouritedIcon:(BOOL)favourited {
    FAKFontAwesome *favIcon;
    self.event.isFavourite = favourited;
    if (favourited) {
        favIcon = [FAKFontAwesome heartIconWithSize:21];
    } else {
        favIcon = [FAKFontAwesome heartOIconWithSize:21];
    }
    [self.favouriteImage setImage:[favIcon imageWithSize:CGSizeMake(21,21)]];
}

@end
