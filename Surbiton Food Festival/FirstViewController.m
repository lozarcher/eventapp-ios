//
//  FirstViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//


#import "FirstViewController.h"
#import "Event.h"
#import "EventBuilder.h"

@implementation FirstViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;

    NSString *urlAsString = @"http://localhost:8080/events";
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


#pragma - markup TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Event *event = [_events objectAtIndex:indexPath.row];
    NSLog(@"Cell label %@", [event name]);
    cell.textLabel.text = [event name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [_events objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",[event name]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSError *error = nil;
    NSArray *events = [EventBuilder eventsFromJSON:data error:&error];
    _events = events;
    NSLog(@"Events :%lu", (unsigned long)_events.count);
    [tableView reloadData];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [tableView reloadData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

@end
