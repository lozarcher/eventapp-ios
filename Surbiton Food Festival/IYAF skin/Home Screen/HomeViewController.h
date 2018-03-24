//
//  HomeViewController.h
//  IYAF 2015
//
//  Created by Loz Archer on 08/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RearViewController.h"

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIImageView *performersImage;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UIImageView *galleryImage;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
@property (strong, nonatomic) RearViewController *rearViewController;
@property (weak, nonatomic) IBOutlet UIImageView *aboutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapBeforeMenu;
-(void)setUpButtons;
-(void)loadHome;

@end
