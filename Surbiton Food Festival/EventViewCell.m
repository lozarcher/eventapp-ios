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

@synthesize eventNameLabel, venueLabel, favouriteImage, favourited, event, clockView, timeLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.favourited = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.clockView.delegate = self;
    self.fd_enforceFrameLayout = YES;
    
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
        self.clockView.hours = 0;
        self.clockView.minutes = 0;
        NSLog(@"Set event %@ all day", event.name);

    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
        self.clockView.hours = [components hour];
        self.clockView.minutes = [components minute];
        NSLog(@"Set event %@ hours %ld minutes %ld", event.name, (long)[components hour], (long)[components minute]);
    }
    [self.clockView reloadClock];
    
    NSString *location = event.location;
    if ([location isKindOfClass:[NSNull class]]) {
        location = @"Surbiton";
    }
    venueLabel.text = location;
    
    timeLabel.text = startDateString;
    
    self.favourited = isFavourite;
    [self setFavouritedIcon:self.favourited];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.favouriteImage setUserInteractionEnabled:YES];
    [self.favouriteImage addGestureRecognizer:singleTap];
    
    [self setNeedsDisplay];
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
    CGFloat leftSideHeight = 91;
    
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
