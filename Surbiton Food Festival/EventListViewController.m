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
#import "AppDelegate.h"
#import "UITableView+FDTemplateLayoutCell.h"

@implementation EventListViewController

@synthesize tableView, spinner, showFavourites, favourites;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.fd_debugLogEnabled = YES;

    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];;

    _eventDays = [[NSMutableDictionary alloc] init];
    _eventDayKeys = [[NSMutableArray alloc] init];
    
    // Register cell Nib
    UINib *cellNib = [UINib nibWithNibName:@"EventViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"EventViewCell"];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    // Favourite icons
    FAKFontAwesome *favIcon = [FAKFontAwesome heartIconWithSize:21];
    self.favouritesTab.image = [favIcon imageWithSize:CGSizeMake(21,21)];
    FAKFontAwesome *listIcon = [FAKFontAwesome listAltIconWithSize:21];
    self.allEventsTab.image = [listIcon imageWithSize:CGSizeMake(21,21)];
    self.showFavourites = NO;
    
    // Load favourites from NSUserDefaults
    [self loadFavourites];
    
    // set up notification from eventviewcell, when user sets or unsets a favourite
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(favouriteEventHandler:)
     name:@"favouriteEvent"
     object:nil ];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [self activateSpinner:YES];
    [self refreshEvents:self];
    [self setFilteredEvents];
}

//event handler when event occurs
-(void)favouriteEventHandler: (NSNotification *) notification
{
    NSDictionary* userInfo = notification.userInfo;
    Event* event = (Event *)userInfo[@"event"];
    if (event) {
        [self setFavourite:event];
    } else {
        NSLog(@"Error: did not receive cell in event list notification handler");
    }
}

-(void)setFilteredEvents {
    NSMutableArray *filteredEvents = [[NSMutableArray alloc] init];
    if (showFavourites) {
        for (Event *event in _events) {
            if ([self.favourites objectForKey:event.id]) {
                [filteredEvents addObject:event];
            }
        }
    } else {
        filteredEvents = [_events mutableCopy];
    }
    _filteredEvents = filteredEvents;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"Tab Bar select detected %@",tabBar.selectedItem);
    showFavourites = [self.tabBar.selectedItem isEqual:self.favouritesTab];
    if (showFavourites) {
        self.title = @"Your Favourite Events";
        NSLog(@"Showing favourites");
    } else {
        self.title = @"Event Calendar";
        NSLog(@"Showing all events");

    }
    [self setFilteredEvents];
    [self createEventDays:_filteredEvents];

    [tableView reloadData];
}

-(void)loadHome:(id)sender {
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat bottomPadding = 50;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        if (window.safeAreaInsets.bottom > 0)
            bottomPadding += window.safeAreaInsets.bottom;
    }
    self.tabBarHeight.constant = bottomPadding;
    
    [self setFilteredEvents];
    [self createEventDays:_filteredEvents];
    [tableView reloadData];
}

- (void) viewDidLayoutSubviews {
    self.spinner.center = self.view.center;
}

-(void)setFavourite:(Event *)event {
    if (!self.favourites) {
        self.favourites = [[NSMutableDictionary alloc] init];
    }
    if ([self.favourites objectForKey:event.id]) {
        [self.favourites removeObjectForKey:event.id];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", event.id], nil]];
    } else {
        [self.favourites setValue:@"set" forKey:event.id];
    
        
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSTimeInterval startSeconds = [event.startTime doubleValue]/1000;
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:startSeconds];
        NSString *startTimeString = [dateFormatter stringFromDate:startDate];
        
        content.title = [NSString localizedUserNotificationStringForKey:@"Event starting soon" arguments:nil];
        NSString *message = [NSString stringWithFormat:@"%@ will be starting at %@", event.name, startTimeString];
        content.body = [NSString localizedUserNotificationStringForKey:message
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        [content setValue:@(YES) forKey:@"shouldAlwaysAlertWhileAppIsForeground"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *timeOffset= [[NSDateComponents alloc] init];
        
//        For testing, set to now + 10 seconds
//        [timeOffset setSecond:10];
//        NSDate *offsetDate=[calendar dateByAddingComponents:timeOffset toDate:[NSDate date] options:0];
        
        // Set to event start time minus one hour
        [timeOffset setHour:-1];
        NSDate *offsetDate=[calendar dateByAddingComponents:timeOffset toDate:startDate options:0];
        
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:offsetDate];
        UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
                                                  triggerWithDateMatchingComponents:components repeats:NO];
        UNNotificationRequest* request = [UNNotificationRequest
                                          requestWithIdentifier:[NSString stringWithFormat:@"%@", event.id] content:content trigger:trigger];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                          if (error != nil) {
                                              NSLog(@"%@", error.localizedDescription);
                                          } else {
                                              NSLog(@"Set notification for %@", components);
                                          }
                                      }];
                                  } else {
                                      NSLog(@"Notification permission not granted");
                                  }
                              }];
    }
    
    if (showFavourites) {
        [self setFilteredEvents];
        [self createEventDays:_filteredEvents];
        [tableView reloadData];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favourites];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"favourites"];
    [defaults synchronize];
}


-(void)loadFavourites {
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"favourites"];
    NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.favourites = [dict mutableCopy];
}

-(BOOL)isFavourited:(NSString *)eventId {
    NSString *set = [self.favourites objectForKey:eventId];
    if (set)
        return YES;
    else
        return NO;
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
    [self spinner];
    self.tableView.backgroundView = nil;
    NSInteger numberOfDates = [_eventDayKeys count];
    if (numberOfDates != 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [_eventDayKeys count];
    } else {
        // Display a message when the table is empty
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (showFavourites) {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
            noDataLabel.text             = @"You don't have any favourite events yet";
            noDataLabel.numberOfLines = 0;
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            self.tableView.backgroundView = noDataLabel;
        }
        
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *sectionDate = [_eventDayKeys objectAtIndex:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee d MMMM yyyy"];
    
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
    
    EventViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EventViewCell"];;

    // Cell text (event title)
    Event *event = [self getEventForIndexPath:indexPath];
    NSLog(@"Cell label %@", [event name]);
    
    [cell populateDataInCell:event isFavourite:[self isFavourited:[event id]]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self getEventForIndexPath:indexPath];
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"EventViewCell" cacheByKey:event.id configuration:^(id cell) {
        [cell populateDataInCell:event isFavourite:[self isFavourited:[event id]]];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }];
    NSLog(@"Height of cell %@ is %f", event.id, height);
    return height;
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
    [self.navigationController pushViewController:eventDetail animated:YES];
    
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
