//
//  EventViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TraderViewController.h"
#import "UIImageView+WebCache.h"
#import <Crashlytics/Crashlytics.h>

@interface TraderViewController ()

@end

@implementation TraderViewController

@synthesize traderDescriptionLabel, traderTitleLabel, traderImageView, phoneLabel, websiteLabel, closeButton, trader, kingstonPoundImage, linkLabel;

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    traderTitleLabel.text = trader.name;
    if (![[trader about] isKindOfClass:[NSNull class]]) {
        traderDescriptionLabel.text = trader.about;
    } else {
        traderDescriptionLabel.text = @"";
    }
    
    [kingstonPoundImage setHidden:([trader.kingstonPound intValue] != 1)];
    
    if (![trader.website isKindOfClass:[NSNull class]]) {
        NSURL *nsurl = [NSURL URLWithString:trader.website];
        if ([[UIApplication sharedApplication] canOpenURL:nsurl]) {
            [websiteLabel setHidden:NO];
        } else {
            [websiteLabel setHidden:YES];
            
        }
    } else {
        [websiteLabel setHidden:YES];
    }
    
    [phoneLabel setHidden:[trader.phone isKindOfClass:[NSNull class]]];
    [linkLabel setHidden:[trader.link isKindOfClass:[NSNull class]]];
    if (![trader.phone isKindOfClass:[NSNull class]]) {
        [phoneLabel setTitle:[NSString stringWithFormat:@"Call %@", trader.name] forState:UIControlStateNormal];
    }
    
    if (![trader.coverImg isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[trader coverImg]]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [self setImage:image];
                                    if (error != nil) {
                                        [CrashlyticsKit recordError:error];
                                    }
                                }
                            }
         ];
    } else {
        [self setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
    
    [Answers logContentViewWithName:trader.name
                        contentType:@"Trader List"
                          contentId:trader.id
                   customAttributes:@{}];
}

-(void)setImage:(UIImage *)image {
    [traderImageView setImage:image];
    [traderImageView setNeedsLayout];
    [traderImageView layoutIfNeeded];
    if (traderImageView.frame.size.width < (traderImageView.image.size.width)) {
        _imageHeightConstraint.constant = traderImageView.frame.size.width / (traderImageView.image.size.width) * (traderImageView.image.size.height);
    } else {
        _imageHeightConstraint.constant = image.size.height;
    }
}


- (IBAction)websiteClicked:(id)sender {
    NSString *urlString = trader.website;
    if (![urlString hasPrefix:@"http"]) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    NSLog(@"Opening %@", urlString);

}
- (IBAction)fbPageClicked:(id)sender {
    NSString *fbUrl = [NSString stringWithFormat:@"fb://profile/%@", trader.id];
    NSURL *nsurl = [ [ NSURL alloc ] initWithString: fbUrl ];
    if (![[UIApplication sharedApplication] canOpenURL:nsurl])
        nsurl = [ [ NSURL alloc ] initWithString: trader.link ];
    [[UIApplication sharedApplication] openURL:nsurl];

}
- (IBAction)phoneClicked:(id)sender {
    NSString *phoneUrl = [NSString stringWithFormat:@"tel:%@", trader.phone];
    NSLog(@"Calling %@", trader.phone);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
    //[self sendSMS:@"" recipientList:[NSArray arrayWithObjects:trader.phone, nil]];
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
