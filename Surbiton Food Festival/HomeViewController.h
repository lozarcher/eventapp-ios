//
//  HomeViewController.h
//  Surbiton Food Festival
//
//  Created by Loz Archer on 08/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "RearViewController.h"

@interface HomeViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UIImageView *greenPlate;
@property (weak, nonatomic) IBOutlet UIImageView *indigoPlate;
@property (weak, nonatomic) IBOutlet UIImageView *magentaPlate;
@property (weak, nonatomic) IBOutlet UIImageView *orangePlate;
@property (weak, nonatomic) IBOutlet UIImageView *redPlate;
@property (weak, nonatomic) IBOutlet UIImageView *yellowPlate;
@property (strong, nonatomic) RearViewController *rearViewController;
-(void)setUpButtons;

@end
