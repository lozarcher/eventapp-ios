//
//  NewEventListViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TwitterViewController.h"
#import "Tweet.h"
#import "TweetBuilder.h"
#import "MTConfiguration.h"
#import "SWRevealViewController.h"
#import "TwitterViewCell.h"
#import "TweetLinkViewController.h"

#import <Social/Social.h>

@interface TwitterViewController ()

@end

@implementation TwitterViewController

@synthesize tableView, refreshControl, spinner, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    
    // Register cell Nib
    UINib *cellNib = [UINib nibWithNibName:@"TwitterViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"TwitterViewCell"];
    
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
                            action:@selector(refreshTweets:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Tweets.plist", aCachesDirectory];
    
    //Delete the cache file
    //[[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
    
    self.title = NSLocalizedString(@"Twitter", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarCompose.png"]
                                                                          style:UIBarButtonItemStyleBordered target:self action:@selector(tweetButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    [self activateSpinner:YES];
    isPaginatedLoad = NO;
    [self refreshTweets:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Twitter List View";
}


- (void)refreshTweets:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *loadUrl = @"/tweets";
    if (isPaginatedLoad && self.nextPage) {
        loadUrl = self.nextPage;
    }
    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", serviceHostname, loadUrl];
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
    NSInteger numberOfTweets = [_tweets count];
    if (numberOfTweets != 0) {
        self.tableView.backgroundView = nil;
        [messageLabel removeFromSuperview];
        return 1;
    } else {
        // Display a message when the table is empty
        
        [self.view addSubview:messageLabel];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.nextPage isKindOfClass:[NSNull class]]) {
        return _tweets.count + 1;
    } else {
        return _tweets.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TwitterViewCell"];
    }
    Tweet *tweet = [self getTweetForIndexPath:indexPath];
    [self.prototypeCell populateDataInCell:tweet];
    
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == [_tweets count]) { //  Only call the function if we're selecting the last row
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *loadingText = @"Loading...";
        if (![cell.textLabel.text isEqualToString:loadingText]) {
            cell.textLabel.text = @"Loading...";
            NSLog(@"Load More requested"); // Add a function here to add more data to your array and reload the content
            isPaginatedLoad = YES;
            [self refreshTweets:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TwitterViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TwitterViewCell"];;
    
    // Cell text (event title)
    Tweet *tweet = [self getTweetForIndexPath:indexPath];
    NSLog(@"Cell label %@", [tweet name]);
    [cell populateDataInCell:tweet];
    cell.delegate = self;
    
    
    // Only call this if there is a next page
    if (![self.nextPage isKindOfClass:[NSNull class]]) {
        if(indexPath.row == [_tweets count] ) { // Here we check if we reached the end of the index, so the +1 row
            if (cell == nil) {
                cell = [[TwitterViewCell alloc] initWithFrame:CGRectZero];
            }
            // Reset previous content of the cell, I have these defined in a UITableCell subclass, change them where needed
            cell.imageView.image = nil;
            cell.nameLabel.text = nil;
            cell.screennameLabel.text = nil;
            cell.textLabel.text = @"Tap to load more...";
        }
    }
    return cell;
}

- (Tweet*)getTweetForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [_tweets count]) {
        return [[Tweet alloc] init];
    } else {
        NSInteger itemInSection = indexPath.row;
        Tweet *tweet = [_tweets objectAtIndex:itemInSection];
        return tweet;
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [receivedData appendData:data];

}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    connection = nil;
    receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [self endRefresh];
    NSError *parseError;
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *readError;
        NSData *data = [NSData dataWithContentsOfFile:storePath options:NSDataReadingMappedIfSafe error:&readError];
        if (readError != nil) {
            NSLog(@"Could not read from file: %@", [readError localizedDescription]);
        } else {
            NSLog(@"Using cached data");
            parseError = [self getTweetsFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_tweets == nil || parseError != nil) {
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
   
    [self endRefresh];
    [self getTweetsFromData:receivedData];
    [tableView reloadData];
    
    NSError* writeError;
    [receivedData writeToFile:storePath options:NSDataWritingAtomic error:&writeError];
    if (writeError != nil) {
        NSLog(@"Could not write to file: %@", [writeError localizedDescription]);
    } else {
        NSLog(@"Wrote to file %@", storePath);
    }
    
    connection = nil;
    receivedData = nil;
        
}


-(NSError *)getTweetsFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *tweets = [TweetBuilder tweetsFromJSON:data error:&error];
    self.nextPage = [TweetBuilder nextPageFromJSON:data];
    if ([tweets count] > 0) {
        if (isPaginatedLoad) {
            [_tweets addObjectsFromArray:tweets];
        } else {
            _tweets = tweets;
        }
        isPaginatedLoad = NO;
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu tweets from data", (unsigned long)tweets.count);
    return error;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
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
        [self activateSpinner:NO];
    }
}

- (IBAction)tweetButtonClicked:(id)sender {
    NSLog(@"Tweet button clicked");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#surbitonfood "];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
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

-(void)loadURL:(NSString *)urlString {
    NSLog(@"Loading URL %@ from view controller", urlString);
    
    TweetLinkViewController *webVc = [[TweetLinkViewController alloc] initWithNibName:@"TweetLinkViewController" bundle:nil];
    [self presentViewController:webVc animated:YES completion:nil];

    [webVc loadUrlString:urlString];


}

@end
