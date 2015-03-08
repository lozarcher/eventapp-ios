//
//  VenueViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 05/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface VenueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;

@end
