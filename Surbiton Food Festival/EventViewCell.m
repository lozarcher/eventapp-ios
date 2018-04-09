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

@implementation EventViewCell

@synthesize eventNameLabel, venueLabel, favouriteImage, favourited, event, clockView;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.favourited = false;
    self.clockView.delegate = self;
    self.fd_enforceFrameLayout = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Event *)event isFavourite:(BOOL)isFavourite {
    self.event = event;
    //eventNameLabel.text = [event name];
    eventNameLabel.text = [NSString stringWithFormat:@"%@ Really really really really really really really really really really long title", [event name]];

    
    NSTimeInterval seconds = [event.startTime doubleValue]/1000;
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *startDateString = [formatter stringFromDate:startDate];
    
    if ([startDateString isEqualToString:@"01:00"]) {
        startDateString = @"All day";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    self.clockView.hours = [components hour];
    self.clockView.minutes = [components minute];
    self.clockView.seconds = 0;
    self.clockView.secondHandAlpha = 0;
    self.clockView.borderColor = UIColor.grayColor;
    self.clockView.faceBackgroundColor = UIColor.lightGrayColor;
    self.clockView.faceBackgroundAlpha = 0.2;
    self.clockView.borderWidth = 2;
    
    self.clockView.minuteHandColor = UIColor.grayColor;
    self.clockView.minuteHandWidth = 2;
    self.clockView.minuteHandOffsideLength = 5;

    self.clockView.hourHandColor = UIColor.grayColor;
    self.clockView.hourHandWidth = 2;
    self.clockView.hourHandOffsideLength = 5;
    self.clockView.hourHandLength = 15;
    
    NSString *location = event.location;
    if ([location isKindOfClass:[NSNull class]]) {
        location = @"Surbiton";
    }
    venueLabel.text = [NSString stringWithFormat:@"Really really really really really really really really really really long%@ @ %@",startDateString, location];
    [venueLabel sizeToFit];

    self.favourited = isFavourite;
    [self setFavouritedIcon:self.favourited];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favouriteImage setUserInteractionEnabled:YES];
    [self.favouriteImage addGestureRecognizer:singleTap];
}

- (UIColor *)analogClock:(BEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    if ((index % 5) == 0){
        return UIColor.lightGrayColor;
    } else {
        return UIColor.whiteColor;
    }
}

- (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationAlphaForIndex:(NSInteger)index {
    if ((index % 5) == 0){
        return 1;
    } else {
        return 0.2;
    }
}

- (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationOffsetForIndex:(NSInteger)index {
    return 0;
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
    CGFloat totalHeight = 0;
    NSLog(@"eventNameLabel size %f", [self.eventNameLabel sizeThatFits:size].height);
    NSLog(@"venueLabel size %f", [self.venueLabel sizeThatFits:size].height);
    totalHeight += [self.eventNameLabel sizeThatFits:size].height;
    totalHeight += [self.venueLabel sizeThatFits:size].height;
    totalHeight += 21;
    return CGSizeMake(size.width, totalHeight);
}

@end
