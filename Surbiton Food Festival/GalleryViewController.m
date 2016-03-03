//
//  GalleryViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 03/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import "GalleryViewController.h"
#import "AppDelegate.h"

@interface GalleryViewController ()
@property (weak, nonatomic) IBOutlet UIView *browserView;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create array of MWPhoto objects
    self.photos = [NSMutableArray array];
    self.thumbs = [NSMutableArray array];

    // Add photos
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/1897682_691767674222766_6681107116807073405_n.png?oh=e2df6f86291ced1e35e9dfec7c2fdf7e&oe=57620002"]]];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xat1/t31.0-8/1921222_688346764564857_1962211635_o.jpg"]]];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-prn2/v/t1.0-9/1535444_688279277904939_464169478_n.png?oh=e107f4c21c75d7827c8065a79a3c817f&oe=579654E1"]]];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/1549261_691767704222763_1390333702370167352_n.png?oh=5cf7f285d87cd115ea59e939c577dbf7&oe=575471C9"]]];

    [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-0/p206x206/1897682…_6681107116807073405_n.png?oh=0f4f6b01eba29c7c57ff323a07fe079a&oe=574B17CC"]]];
    [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-0/p206x206/1004865…764564857_1962211635_n.jpg?oh=c3ae6cdbaabc78aa45e0461c8c18e1fd&oe=576CA9BA"]]];
    [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-prn2/v/t1.0-0/p206x206/1535444…9277904939_464169478_n.png?oh=7dd154453042c8f751c378b9b5222631&oe=57698063"]]];
    [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xaf1/v/t1.0-0/p206x206/1549261…_1390333702370167352_n.png?oh=38fd39538e43936b44065cc5f865ba9d&oe=576BFD07"]]];


    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = YES; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    self.title = NSLocalizedString(@"Gallery", nil);
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    // Do any additional setup after loading the view.
    
    [self.navigationController addChildViewController:browser];
    
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
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
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

@end
