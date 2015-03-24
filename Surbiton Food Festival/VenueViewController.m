//
//  VenueViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 13/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VenueViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h> 

#define METERS_PER_MILE 1609.344

@interface VenueViewController ()

@end

@implementation VenueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Venue View";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonPressed:(id)sender {
           [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)createVenue:(Venue *)venueDic location:(NSString *)location {
    self.venue = [[Venue alloc] init];
    self.venue.location = location;
    self.venue.street = [venueDic valueForKey:@"street"];
    self.venue.city = [venueDic valueForKey:@"city"];
    self.venue.latitude = [venueDic valueForKey:@"latitude"];
    self.venue.longitude = [venueDic valueForKey:@"longitude"];
    if ([self.venue.street isKindOfClass:[NSNull class]]) {
        self.venue.street = @"";
    }
    if ([self.venue.city isKindOfClass:[NSNull class]]) {
        self.venue.city = @"";
    }
    self.navBar.topItem.title = location;
    self.streetLabel.text = self.venue.street;
    self.cityLabel.text = self.venue.city;

    [self goToCoordinate:self.venue.latitude  longitude:self.venue.longitude];

}
-(void)goToCoordinate:(NSString *)latitudeStr longitude:(NSString *)longitudeStr {
    BOOL showPin = YES;
    if ([latitudeStr isKindOfClass:[NSNull class]] || [longitudeStr isKindOfClass:[NSNull class]]) {
        showPin = NO;
        latitudeStr = @"51.394698417784";
        longitudeStr = @"-0.30764091236066";
    }
    double latitude = [latitudeStr doubleValue];
    double longitude = [longitudeStr doubleValue];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude;
    zoomLocation.longitude = longitude;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1*METERS_PER_MILE, 1*METERS_PER_MILE);

    [_mapView setRegion:viewRegion animated:YES];
    
    if (showPin) {
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = zoomLocation;
        point.title = self.venue.location;
        point.subtitle = self.venue.street;
        
    
        [self.mapView addAnnotation:point];
        [self.mapView selectAnnotation:point animated:YES];
    }

    self.mapView.showsUserLocation = YES;

}



@end
