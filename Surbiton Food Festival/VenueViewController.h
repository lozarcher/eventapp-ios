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

@interface VenueViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)closeButtonPressed:(id)sender;
-(void)createVenue:(Venue *)venueDic location:(NSString *)location;
@property Venue *venue;
-(void)goToCoordinate:(NSString *)latitude longitude:(NSString *)longitude;

@end
