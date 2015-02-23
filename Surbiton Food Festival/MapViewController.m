//
//  MapViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 23/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "MapViewController.h"
#import "VenueBuilder.h"
#import <MapKit/MapKit.h>
#import "Venue.h"
#import "VenueAnnotation.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

@synthesize mapView;

-(void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.392476574943;
    zoomLocation.longitude= -0.30439213051241;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView.delegate=self;

    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Venues.plist", aCachesDirectory];
    
    //Delete the cache file
    //[[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
    NSError *parseError;
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *readError;
        NSData *data = [NSData dataWithContentsOfFile:storePath options:NSDataReadingMappedIfSafe error:&readError];
        if (readError != nil) {
            NSLog(@"Could not read from file: %@", [readError localizedDescription]);
        } else {
            NSLog(@"Using cached data");
            parseError = [self getVenuesFromData:data];
            [self plotVenues];
        }
    }
    
    if (_venues == nil || parseError != nil) {
        if (parseError != nil) {
            NSLog(@"Local venue cache parse error: %@", [parseError localizedDescription]);
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
        }
        [self refreshVenues:self];
    }
    // Do any additional setup after loading the view.
}

- (void)refreshVenues:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *urlAsString = @"http://localhost:8080/venues";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", url);
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self getVenuesFromData:data];
    [self plotVenues];
    NSError* writeError;
    [data writeToFile:storePath options:NSDataWritingAtomic error:&writeError];
    if (writeError != nil) {
        NSLog(@"Could not write to file: %@", [writeError localizedDescription]);
    } else {
        NSLog(@"Wrote to file %@", storePath);
    }
}

-(NSError *)getVenuesFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *venues = [VenueBuilder venuesFromJSON:data error:&error];
    _venues = venues;
    NSLog(@"Venues :%lu", (unsigned long)_venues.count);
    return error;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

-(void)plotVenues {
    for (Venue *venue in _venues) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [venue.latitude doubleValue];
        coordinate.longitude = [venue.longitude doubleValue];
        NSString *address = venue.street;
        if ([venue.street isKindOfClass:[NSNull class]]) {
            address = @"";
        }
        VenueAnnotation *annotation = [[VenueAnnotation alloc] initWithName:venue.location address:address coordinate:coordinate] ;
        
        [mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)thisMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyIdentifier";
    if ([annotation isKindOfClass:[VenueAnnotation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [thisMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"pin.png"];//here we use a nice image instead of the default pins

        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

@end
