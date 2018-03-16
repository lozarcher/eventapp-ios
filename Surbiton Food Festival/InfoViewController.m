//
//  EventViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "InfoViewController.h"
#import "UIImageView+WebCache.h"
#import "CoverHelper.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end

@implementation InfoViewController

@synthesize infoImage, infoTitle, infoContent, info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    
    // Check to see if we are running on iOS 6
    if (![self respondsToSelector:@selector(topLayoutGuide)]) {
        self.topConstraint.constant = self.topConstraint.constant - 64;
    }
    
    // Do any additional setup after loading the view from its nib.
    infoTitle.text = info.title;
    infoContent.text = info.content;
    
    infoContent.urlLinkTapHandler = ^(KILabel *label, NSString *urlString, NSRange range) {
        NSLog(@"Clicked link: %@", urlString);
        [self loadURL:urlString];
    };
    
    [super viewDidLoad];
}

-(void)loadURL:(NSString *)urlString {
    if (![urlString hasPrefix:@"http"]) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    NSLog(@"Loading URL %@ from view controller", urlString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void) viewDidAppear:(BOOL)animated {
    _imageHeightConstraint.constant = 0.0;

    if (![info.picture isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[info picture]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                
                                float aspect = image.size.height / image.size.width;
                                float newHeight = infoImage.frame.size.width * aspect;
                                _imageHeightConstraint.constant = newHeight;
                                [infoImage setImage:image];
                                _imageHeightConstraint.constant = newHeight;

                            }];
    } else {
        [infoImage setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
