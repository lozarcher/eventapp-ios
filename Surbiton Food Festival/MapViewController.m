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
#import "MTConfiguration.h"
#import "SWRevealViewController.h"
#import "VenueViewController.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

@synthesize mapView;

-(void)viewWillAppear:(BOOL)animated {
    [self refreshVenues:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView.delegate=self;

    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Venues.plist", aCachesDirectory];
    
    //Delete the cache file
    //[[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
    
    self.title = NSLocalizedString(@"Map", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.392029539135;
    zoomLocation.longitude= -0.31130046171006;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
    
    [mapView setRegion:viewRegion animated:YES];
}

- (void)refreshVenues:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *urlAsString = [NSString stringWithFormat:@"%@/venues", serviceHostname];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", url);
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:10.0];
    
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        // Inform the user that the connection failed.
        NSLog(@"Error making connection");
        
    }

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
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    connection = nil;
    receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    // Get events from cache instead
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
    }
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %lu bytes of data", (unsigned long)receivedData.length);
    
    [self getVenuesFromData:receivedData];
    [self plotVenues];
    
    NSError* writeError;
    [receivedData writeToFile:storePath options:NSDataWritingAtomic error:&writeError];
    if (writeError != nil) {
        NSLog(@"Could not write to file: %@", [writeError localizedDescription]);
    } else {
        NSLog(@"Wrote to file %@", storePath);
    }
    
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    connection = nil;
    receivedData = nil;
    
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
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

            annotationView.image = [UIImage imageNamed:@"pin.png"];//here we use a nice image instead of the default pins

        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //launch a new view upon touching the disclosure indicator
    VenueViewController *venueVc = [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
    venueVc.venueNameLabel.text = @"Venue...";
    [self presentViewController:venueVc animated:YES completion:nil];
}

@end
