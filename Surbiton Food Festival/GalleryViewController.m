//
//  GalleryViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import "GalleryViewController.h"
#import "AppDelegate.h"
#import "MTConfiguration.h"
#import "GalleryBuilder.h"
#import "Gallery.h"
#import "UploadPhotoViewController.h"

@interface GalleryViewController ()
@property MWPhotoBrowser *browser;

@end

@implementation GalleryViewController

@synthesize spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Gallery", nil);
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(doAddPhoto:)];
    self.navigationItem.rightBarButtonItem = cameraButtonItem;
    
    // Do any additional setup after loading the view.
    
    NSString *aCachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    storePath = [NSString stringWithFormat:@"%@/Gallery.plist", aCachesDirectory];
    
    _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    _browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    _browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    _browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    _browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    _browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    _browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    _browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    _browser.autoPlayOnAppear = NO; // Auto-play first video

    [self.navigationController addChildViewController:_browser];
    
    [self activateSpinner:YES];
    [self refreshGallery:self];

}

-(IBAction)doAddPhoto:(id)sender
{
    UploadPhotoViewController *vc = [[UploadPhotoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshGallery:(id)sender {
    NSLog(@"Fetching data from URL");
    NSString *serviceHostname = [MTConfiguration serviceHostname];
    NSString *loadUrl = @"/gallery";
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

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        Gallery *gallery = [self.photos objectAtIndex:index];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:gallery.picture]];
        NSString *caption;
        if (![gallery.caption isEqualToString:@""]) {
            caption = [[NSString alloc] initWithFormat:@"%@\r\n%@", gallery.caption, gallery.user];
        } else {
            caption = [[NSString alloc] initWithFormat:@"%@", gallery.user];
        }
        photo.caption = caption;
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        Gallery *gallery = [self.photos objectAtIndex:index];
        MWPhoto *thumb = [MWPhoto photoWithURL:[NSURL URLWithString:gallery.thumb]];
        return thumb;
    }
    return nil;
}

-(void)loadHome:(id)sender {
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
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
    
    [self activateSpinner:NO];
    // Get events from cache instead
    NSError *parseError;
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *readError;
        NSData *data = [NSData dataWithContentsOfFile:storePath options:NSDataReadingMappedIfSafe error:&readError];
        if (readError != nil) {
            NSLog(@"Could not read from file: %@", [readError localizedDescription]);
        } else {
            NSLog(@"Using cached data");
            [self getGalleryFromData:data];
        }
    }
    
    if (_photos == nil || parseError != nil) {
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
    
    [self getGalleryFromData:receivedData];
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


-(NSError *)getGalleryFromData:(NSData *)data {
    NSError *error = nil;
    NSArray *gallery = [GalleryBuilder galleryFromJSON:data error:&error];
    if ([gallery count] > 0) {
        _photos = gallery;
    }
    if (error != nil) {
        NSLog(@"Error : %@", [error description]);
    }
    NSLog(@"Got %lu photos from gallery data", (unsigned long)gallery.count);
    [_browser reloadData];
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


@end
