//
//  EventViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 15/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TraderViewController.h"
#import "UIImageView+WebCache.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check to see if we are running on iOS 6
    if (![self respondsToSelector:@selector(topLayoutGuide)]) {
        self.topConstraint.constant = self.topConstraint.constant - 64;
    }
    
    // Do any additional setup after loading the view from its nib.
    traderTitleLabel.text = trader.name;
    if (![[trader about] isKindOfClass:[NSNull class]]) {
        traderDescriptionLabel.text = trader.about;
    } else {
        traderDescriptionLabel.text = @"";
    }
    
    traderImageView.frame = self.view.bounds;
    
    [kingstonPoundImage setHidden:(![trader.kingstonPound intValue] == 1)];
    if (![trader.coverImg isKindOfClass:[NSNull class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[trader coverImg]] options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                [traderImageView setImage:image];
                            }];
    } else {
        [traderImageView setImage:[UIImage imageNamed:@"logo.jpg"]];
    }
    
    //) {
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
        [phoneLabel setTitle:[NSString stringWithFormat:@"Text %@", trader.name] forState:UIControlStateNormal];
    }
    
}
- (IBAction)websiteClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trader.website]];
    NSLog(@"Opening %@", trader.website);

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
    NSLog(@"Texting %@", trader.phone);
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
    [self sendSMS:@"" recipientList:[NSArray arrayWithObjects:trader.phone, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
    } else {
        NSLog(@"Message failed");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];

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
