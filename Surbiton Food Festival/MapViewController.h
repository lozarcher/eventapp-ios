//
//  MapViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <NSURLConnectionDelegate, MKMapViewDelegate> {
    NSString *storePath;
    NSArray *_venues;
    NSMutableData *receivedData;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
