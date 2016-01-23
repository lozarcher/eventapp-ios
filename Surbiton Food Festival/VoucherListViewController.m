//
//  VoucherListViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VoucherListViewController.h"
#import "Voucher.h"
#import "VoucherBuilder.h"
#import "VoucherListCell.h"
#import "MTConfiguration.h"
#import "SWRevealViewController.h"
#import "VoucherListCell.h"
#import "UIImageView+WebCache.h"
#import "VoucherViewController.h"

@implementation VoucherListViewController

@synthesize tableView, heightsCache;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.heightsCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshVouchers:)
                  forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:self.refreshControl];
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Vouchers.plist", aCachesDirectory];
    
    self.title = NSLocalizedString(@"Vouchers", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    //[self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [self refreshVouchers:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)refreshVouchers:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *urlAsString = [NSString stringWithFormat:@"%@/vouchers", serviceHostname];
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
    return _vouchers.count;
}



- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"VoucherTableItem";

    VoucherListCell *cell = (VoucherListCell *)[view dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VoucherListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    // Cell text (event title)
    Voucher *voucher = [self getVoucherForIndexPath:indexPath];
    NSLog(@"Cell label %@", [voucher title]);
    
    NSString *title = voucher.title ?: NSLocalizedString(@"[No Title]", nil);
    [cell.voucherTitleLabel setText:title];
   
    NSString *thumbnail = voucher.url;
    [cell.voucherImage sd_setImageWithURL:[NSURL URLWithString:thumbnail]
                         placeholderImage:[UIImage imageNamed:thumbnail]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    // save height of an image to some cache
                                    [self.heightsCache setValue:[NSNumber numberWithFloat:cell.voucherImage.frame.size.height]
                                                      forKey:voucher.url];
                                    /*
                                    [view beginUpdates];
                                    [view reloadRowsAtIndexPaths:@[indexPath]
                                                     withRowAnimation:UITableViewRowAnimationFade];
                                    [view endUpdates];
                                     */
                                }
     ];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (Voucher*)getVoucherForIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemInSection = indexPath.row;
    NSLog(@"Selecting row %ld from %lu vouchers", (long)indexPath.row, (unsigned long)_vouchers.count);
    Voucher *voucher = [_vouchers objectAtIndex:itemInSection];
    return voucher;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Voucher *voucher = [self getVoucherForIndexPath:indexPath];
    NSString *thumbnail = voucher.url;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:thumbnail] options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    }
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            VoucherViewController *cont = [[VoucherViewController alloc  ]initWithImage:image];
            [self presentViewController:cont animated:YES completion:nil];
        }];
    
}
     
- (CGFloat)tableView:(UITableView *)tableView
                  heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    // try to get image height from your own heights cache
    // if its is not there return default one
    
    return 220;
    
    // TODO - THERE'S A BUG HERE. On the second load, there's an array out of index
    NSLog(@"Finding voucher %ld in %lu", (long)indexPath.row, (unsigned long)_vouchers.count);
    Voucher *voucher = [self getVoucherForIndexPath:indexPath];
    CGFloat height = [[self.heightsCache valueForKey:voucher.url] floatValue];
    height = height + 50;
    return height;
    
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
    
    [self connectionError];
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
            [self getVouchersFromData:data];
            [tableView reloadData];
        }
    }
    
    if (_vouchers == nil || parseError != nil) {
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
    [self getVouchersFromData:receivedData];
    [tableView reloadData];
    [self connectionOK];
    
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


-(NSError *)getVouchersFromData:(NSData *)data {
    NSError *error = nil;
    NSMutableArray *vouchers = [VoucherBuilder vouchersFromJSON:data error:&error];
    if ([vouchers count] > 0) {
        _vouchers = vouchers;
    } else {
        [self connectionError];
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu vouchers from data", (unsigned long)vouchers.count);
    return error;
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void)connectionError {
    NSLog(@"Connection Error");
}

-(void)connectionOK {
    NSLog(@"Connection OK");
}

@end