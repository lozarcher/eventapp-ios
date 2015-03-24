//
//  FirstViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//


#import "TraderListViewController.h"
#import "Trader.h"
#import "TraderBuilder.h"
#import "TraderViewCell.h"
#import "MTConfiguration.h"
#import "SWRevealViewController.h"
#import "TraderViewController.h"

@implementation TraderListViewController

@synthesize tableView, spinner, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    // Register cell Nib
    UINib *cellNib = [UINib nibWithNibName:@"TraderViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TraderViewCell"];
    
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
                            action:@selector(refreshTraders:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Traders.plist", aCachesDirectory];
    
    self.title = NSLocalizedString(@"Traders", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self activateSpinner:YES];
    [self refreshTraders:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Trader List View";
}


- (void)refreshTraders:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *urlAsString = [NSString stringWithFormat:@"%@/traders", serviceHostname];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_traders count];
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TraderViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TraderViewCell"];;
    
    // Cell text (event title)
    Trader *trader = [self getTraderForIndexPath:indexPath];
    NSLog(@"Cell label %@", [trader  name]);
    [cell populateDataInCell:trader];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TraderViewCell"];
    }
    Trader *trader = [self getTraderForIndexPath:indexPath];
    [self.prototypeCell populateDataInCell:trader];
    
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (Trader*)getTraderForIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemInSection = indexPath.row;
    Trader *trader = [_traders objectAtIndex:itemInSection];
    return trader;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Trader *trader = [self getTraderForIndexPath:indexPath];
    
    TraderViewController *traderDetail=[[TraderViewController alloc]initWithNibName:@"TraderViewController" bundle:[NSBundle mainBundle]];
    traderDetail.trader = trader;
    [self.navigationController pushViewController:traderDetail animated:YES];
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
            [self getTradersFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_traders == nil || parseError != nil) {
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
    [self getTradersFromData:receivedData];
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


-(NSError *)getTradersFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *traders = [TraderBuilder tradersFromJSON:data error:&error];
    if ([traders count] > 0) {
        _traders = traders;
    } else {
        [self activateSpinner:NO];
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu traders from data", (unsigned long)traders.count);
    return error;
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
