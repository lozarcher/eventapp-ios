//
//  VenueAnnotation.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h> 

@interface VenueAnnotation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;
- (NSString *)title;

@end
