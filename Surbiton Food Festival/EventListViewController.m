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

@implementation EventListViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    
    _eventDays = [[NSMutableDictionary alloc] init];
    _eventDayKeys = [[NSMutableArray alloc] init];
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
            parseError = [self getEventsFromData:data];
        }
    }

    if (_events == nil || parseError != nil) {
        if (parseError != nil) {
            NSLog(@"Local event cache parse error: %@", [parseError localizedDescription]);
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
        }
        [self refreshEvents:self];
    }
}

- (void)refreshEvents:(id)sender {
    NSLog(@"Fetching data from URL");
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfDates = [_eventDayKeys count];
    if (numberOfDates != 0) {
        self.tableView.backgroundView = nil;
        return [_eventDayKeys count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
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
    return cell;
}

- (Event*)getEventForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger itemInSection = indexPath.row;
    NSArray *eventsForDay = [_eventDays objectForKey:[_eventDayKeys objectAtIndex:section]];
    Event *event = [eventsForDay objectAtIndex:itemInSection];
    return event;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self getEventForIndexPath:indexPath];

    EventViewController *eventDetail=[[EventViewController alloc]initWithNibName:@"EventViewController" bundle:[NSBundle mainBundle]];
    eventDetail.event = event;
    [self presentViewController:eventDetail
                       animated:YES
                     completion:nil];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self getEventsFromData:data];
    [tableView reloadData];
    

    NSError* writeError;
    [data writeToFile:storePath options:NSDataWritingAtomic error:&writeError];
    if (writeError != nil) {
        NSLog(@"Could not write to file: %@", [writeError localizedDescription]);
    } else {
        NSLog(@"Wrote to file %@", storePath);
    }
}

-(NSError *)getEventsFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *events = [EventBuilder eventsFromJSON:data error:&error];
    _events = events;
    [self createEventDays:events];
    NSLog(@"Events :%lu", (unsigned long)_events.count);
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
        } else {
            [eventsForDay addObject:event];
        }
        [_eventDays setObject:eventsForDay forKey:dateAtMidnight];
        [_eventDayKeys addObject:dateAtMidnight];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [self endRefresh];
    [tableView reloadData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self endRefresh];
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

-(void)endRefresh {
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

@end
