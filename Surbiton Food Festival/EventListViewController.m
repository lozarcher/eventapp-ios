//
//  FirstViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//


#import "EventListViewController.h"
#import "Event.h"
#import "EventBuilder.h"
#import "EventViewController.h"
#import "EventViewCell.h"
#import "MTConfiguration.h"
#import "SWRevealViewController.h"

@implementation EventListViewController

@synthesize tableView, spinner, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    _eventDays = [[NSMutableDictionary alloc] init];
    _eventDayKeys = [[NSMutableArray alloc] init];
    
    //initialise the message label
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = @"No data is currently available. Please pull down to refresh.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];

    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshEvents:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Events.plist", aCachesDirectory];
    
    self.title = NSLocalizedString(@"Event Calendar", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self activateSpinner:YES];
    [self refreshEvents:self];
}

- (void)initialRefreshEvents:(id)sender {

}

- (void)refreshEvents:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *urlAsString = [NSString stringWithFormat:@"%@/events", serviceHostname];
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


#pragma - markup TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfDates = [_eventDayKeys count];
    if (numberOfDates != 0) {
        [messageLabel removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [_eventDayKeys count];
    } else {
        // Display a message when the table is empty
        [self.view addSubview:messageLabel];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *sectionDate = [_eventDayKeys objectAtIndex:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee d MMMM"];
    
    NSString *stringFromDate = [formatter stringFromDate:sectionDate];
    return stringFromDate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = [_eventDayKeys objectAtIndex:section];
    NSUInteger eventCount = [[_eventDays objectForKey:date] count];
    return eventCount;
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"EventTableItem";
    EventViewCell *cell = [view dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"EventViewCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    // Cell text (event title)
    Event *event = [self getEventForIndexPath:indexPath];
    NSLog(@"Cell label %@", [event name]);
    [cell populateDataInCell:event];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (Event*)getEventForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger itemInSection = indexPath.row;
    NSArray *eventsForDay = [_eventDays objectForKey:[_eventDayKeys objectAtIndex:section]];
    Event *event = [eventsForDay objectAtIndex:itemInSection];
    return event;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self getEventForIndexPath:indexPath];
    
    EventViewController *eventDetail=[[EventViewController alloc]initWithNibName:@"EventViewController" bundle:[NSBundle mainBundle]];
    eventDetail.event = event;
    [self presentViewController:eventDetail animated:YES completion:nil];
}


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
    
    [self activateSpinner:NO];
    [self.refreshControl endRefreshing];
    // Get events from cache instead
    NSError *parseError;
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *readError;
        NSData *data = [NSData dataWithContentsOfFile:storePath options:NSDataReadingMappedIfSafe error:&readError];
        if (readError != nil) {
            NSLog(@"Could not read from file: %@", [readError localizedDescription]);
        } else {
            NSLog(@"Using cached data");
            [self getEventsFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_events == nil || parseError != nil) {
        if (parseError != nil) {
            NSLog(@"Local event cache parse error: %@", [parseError localizedDescription]);
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %lu bytes of data", (unsigned long)receivedData.length);
    
    [self.refreshControl endRefreshing];
    [self getEventsFromData:receivedData];
    [tableView reloadData];
    [self activateSpinner:NO];
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


-(NSError *)getEventsFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *events = [EventBuilder eventsFromJSON:data error:&error];
    if ([events count] > 0) {
        _events = events;
    } else {
        [self activateSpinner:NO];
    }
    [self createEventDays:events];
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu events from data", (unsigned long)events.count);
    return error;
}

-(void)createEventDays:(NSArray *)events {
    [_eventDayKeys removeAllObjects];
    [_eventDays removeAllObjects];
    for (Event* event in events) {
        
        // (Step 1) Convert epoch time to SECONDS since 1970
        NSTimeInterval seconds = [event.startTime doubleValue]/1000;
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:epochNSDate];
        comps.hour   = 0;
        comps.minute = 0;
        comps.second = 0;
        NSDate *dateAtMidnight = [calendar dateFromComponents:comps];
        
        NSMutableArray *eventsForDay = [_eventDays objectForKey:dateAtMidnight];
        if (eventsForDay == nil) {
            eventsForDay = [NSMutableArray arrayWithObject:event];
            [_eventDayKeys addObject:dateAtMidnight];
        } else {
            [eventsForDay addObject:event];
        }
        [_eventDays setObject:eventsForDay forKey:dateAtMidnight];
    }
    
    for(id key in _eventDays) {
        NSLog(@"Date: %@", key);
        NSArray *eventsForDay = [_eventDays objectForKey:key];
        for (Event *event in eventsForDay) {
            NSLog(@"Event %@", event.name);
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void)activateSpinner:(BOOL)activate {
    if (activate) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 240);
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
    } else {
        if (spinner) {
            [spinner stopAnimating];
        }
    }
}
@end
