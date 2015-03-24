//
//  NewEventListViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"
#import "MessageBuilder.h"
#import "MTConfiguration.h"
#import "SWRevealViewController.h"
#import "MessageViewCell.h"
#import "NewMessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize tableView, refreshControl, spinner, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    
    //initialise the message label
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    // Register cell Nib
    UINib *cellNib = [UINib nibWithNibName:@"MessageViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"MessageViewCell"];
    
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
                            action:@selector(refreshMessages:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Messages", aCachesDirectory];
    
    //Delete the cache file
    //[[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
    
    self.title = NSLocalizedString(@"Group Messaging", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *newMessageeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarCompose.png"]
                                                                         style:UIBarButtonItemStyleBordered target:self action:@selector(newMessage:)];
    
    self.navigationItem.rightBarButtonItem = newMessageeButton;
    
    [self activateSpinner:YES];
    isPaginatedLoad = NO;
    [self refreshMessages:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Message List View";
}


-(void)newMessage:(id)sender {
    NewMessageViewController *newMessage=[[NewMessageViewController alloc]initWithNibName:@"NewMessageViewController" bundle:[NSBundle mainBundle]];
    newMessage.parent = self;
    [self.navigationController pushViewController:newMessage animated:YES];
}

- (void)refreshMessages:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *loadUrl = @"/messages";
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
    NSInteger numberOfMessages = [_messages count];
    if (numberOfMessages != 0) {
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
        return _messages.count + 1;
    } else {
        return _messages.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageViewCell"];
    }
    Message *message = [self getMessageForIndexPath:indexPath];
    [self.prototypeCell populateDataInCell:message];
    
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == [_messages count]) { //  Only call the function if we're selecting the last row
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *loadingText = @"Loading...";
        if (![cell.textLabel.text isEqualToString:loadingText]) {
            cell.textLabel.text = @"Loading...";
            NSLog(@"Load More requested"); // Add a function here to add more data to your array and reload the content
            isPaginatedLoad = YES;
            [self refreshMessages:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageViewCell"];;
    
    // Cell text (event title)
    Message *message = [self getMessageForIndexPath:indexPath];
    NSLog(@"Cell label %@", [message name]);
    [cell populateDataInCell:message];
    
    // Only call this if there is a next page
    if (![self.nextPage isKindOfClass:[NSNull class]]) {
        if(indexPath.row == [_messages count] ) { // Here we check if we reached the end of the index, so the +1 row
            if (cell == nil) {
                cell = [[MessageViewCell alloc] initWithFrame:CGRectZero];
            }
            // Reset previous content of the cell, I have these defined in a UITableCell subclass, change them where needed
            cell.imageView.image = nil;
            cell.nameLabel.text = nil;
            cell.textLabel.text = @"Tap to load more...";
        }
    }
    return cell;
}

- (Message*)getMessageForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [_messages count]) {
        return [[Message alloc] init];
    } else {
        NSInteger itemInSection = indexPath.row;
        Message *message = [_messages objectAtIndex:itemInSection];
        return message;
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
            parseError = [self getMessagesFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_messages == nil || parseError != nil) {
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
    [self getMessagesFromData:receivedData];
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


-(NSError *)getMessagesFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *messages = [MessageBuilder messagesFromJSON:data error:&error];
    self.nextPage = [MessageBuilder nextPageFromJSON:data];
    if ([messages count] > 0) {
        if (isPaginatedLoad) {
            [_messages addObjectsFromArray:messages];
        } else {
            _messages = messages;
        }
        isPaginatedLoad = NO;
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu messages from data", (unsigned long)messages.count);
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
