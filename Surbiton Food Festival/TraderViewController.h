//
//  EventViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trader.h"

@interface TraderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (retain,nonatomic) IBOutlet UILabel *traderTitleLabel;
@property (retain,nonatomic) IBOutlet UIImageView *traderImageView;
@property (weak, nonatomic) IBOutlet UILabel *traderDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *websiteLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *kingstonPoundImage;

@property (retain,nonatomic) Trader *trader;
@end
