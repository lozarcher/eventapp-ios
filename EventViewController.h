//
//  EventViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (retain,nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (retain,nonatomic) IBOutlet UILabel *eventDateLabel;
@property (retain,nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;

@property (retain,nonatomic) Event *event;
@end
