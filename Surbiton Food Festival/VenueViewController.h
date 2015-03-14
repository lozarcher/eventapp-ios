//
//  VenueViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 13/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import <MapKit/MapKit.h>

@interface VenueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)closeButtonPressed:(id)sender;

@end
