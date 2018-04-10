//
//  EventViewCell.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "BEMAnalogClock/BEMAnalogClockView.h"

@interface EventViewCell : UITableViewCell <BEMAnalogClockDelegate>
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *clockView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property BOOL favourited;
-(void)populateDataInCell:(Event *)event isFavourite:(BOOL)isFavourite;
@property Event *event;
@end
