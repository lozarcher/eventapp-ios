//
//  FirstViewController.m
//  IYAF 2015
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "PostListViewController.h"
#import "Post.h"
#import "PostBuilder.h"
#import "PostViewCell.h"
#import "MTConfiguration.h"
#import "TweetLinkViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#import "UITableView+FDTemplateLayoutCell.h"

@implementation PostListViewController

@synthesize tableView, spinner, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.fd_debugLogEnabled = YES;

    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Register cell Nib
    UINib *cellNib = [UINib nibWithNibName:@"PostViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PostViewCell"];
    
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
                            action:@selector(refreshPosts:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Posts.plist", aCachesDirectory];
    
    self.title = NSLocalizedString(@"News", nil);
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    isPaginatedLoad = NO;

    [self activateSpinner:YES];
    [self refreshPosts:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewDidLayoutSubviews {
    self.spinner.center = self.view.center;
}

-(void)loadHome:(id)sender {
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
}

- (void)refreshPosts:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *loadUrl = @"/posts";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_posts.count > 0 && ![self.nextPage isKindOfClass:[NSNull class]]) {
        return _posts.count + 1;
    } else {
        return _posts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostViewCell"];;

    // Cell text (event title)
    Post *post = [self getPostForIndexPath:indexPath];
    NSLog(@"Cell label %@", [post name]);

    cell.postImageHeight = 0;
    cell.imageHeightConstraint.constant = 0;
    
    [cell populateDataInCell:post indexPath:indexPath tableView:view];
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Only call this if there is a next page
    if (![self.nextPage isKindOfClass:[NSNull class]]) {
        if(indexPath.row == [_posts count] ) { // Here we check if we reached the end of the index, so the +1 row
            if (cell == nil) {
                cell = [[PostViewCell alloc] initWithFrame:CGRectZero];
            }
            // Reset previous content of the cell, I have these defined in a UITableCell subclass, change them where needed
            cell.imageView.image = nil;
            cell.dateLabel.text = @"";
            cell.messageLabel.text = @"Tap to load more...";
        }
    }

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"PostViewCell" configuration:^(id cell) {
        [cell populateDataInCell:[self getPostForIndexPath:indexPath] indexPath:indexPath tableView:self.tableView];
    }];
    
//    if (!self.prototypeCell)
//    {
//        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"PostViewCell"];
//    }
//    Post *post = [self getPostForIndexPath:indexPath];
//    [self.prototypeCell populateDataInCell:post indexPath:indexPath];
//
//    [self.prototypeCell layoutIfNeeded];
//
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height;
//    CGFloat imageHeight = [[heightsCache objectForKey:post.pictureUrl] floatValue];
//    
//    NSLog(@"Returning row height %f for row %ld", size.height, (long)indexPath.row);
//    
//    CGFloat originalHeight = size.height;
//    
//    CGFloat newHeight = originalHeight - self.prototypeCell.imageView.frame.size.height + imageHeight;
//    return newHeight;
    
}

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == [_posts count]) { //  Only call the function if we're selecting the last row
        isPaginatedLoad = YES;
        [self refreshPosts:self];
    }
}

- (Post*)getPostForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [_posts count]) {
        return [[Post alloc] init];
    } else {
        NSInteger itemInSection = indexPath.row;
        Post *post = [_posts objectAtIndex:itemInSection];
        return post;
    }
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
            [self getPostFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_posts == nil || parseError != nil) {
        if (parseError != nil) {
            NSLog(@"Local post cache parse error: %@", [parseError localizedDescription]);
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
    [self getPostFromData:receivedData];
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
    
    [tableView reloadData];

}


-(NSError *)getPostFromData:(NSData *)data {
    NSError *error = nil;
    NSMutableArray *posts = [[PostBuilder postsFromJSON:data error:&error] mutableCopy];
    self.nextPage = [PostBuilder nextPageFromJSON:data];
    if ([posts count] > 0) {
        if (isPaginatedLoad) {
            [_posts addObjectsFromArray:posts];
        } else {
            _posts = posts;
        }
        isPaginatedLoad = NO;
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu posts from data", (unsigned long)posts.count);
    
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
