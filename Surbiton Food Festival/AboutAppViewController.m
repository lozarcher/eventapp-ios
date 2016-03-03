//
//  AboutAppViewController.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 19/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "AboutAppViewController.h"
#import "PrivacyPolicyViewController.h"
#import "AppDelegate.h"

@interface AboutAppViewController ()

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Contact / Help", nil);
    
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(loadHome:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    

    // Do any additional setup after loading the view from its nib.
}

-(void)loadHome:(id)sender {
    AppDelegate *appDelegate=( AppDelegate* )[UIApplication sharedApplication].delegate;
    [appDelegate.homeViewController loadHome];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = [NSString stringWithFormat: @"Version %@ build %@", version, build];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lozButtonClicked:(id)sender {
    NSLog(@"Texting Loz");
    [self sendSMS:@"" recipientList:[NSArray arrayWithObjects:@"07954579444", nil]];
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
- (IBAction)privacyPolicyButton:(id)sender {
    NSLog(@"Privacy Policy pressed");
    PrivacyPolicyViewController *webVc = [[PrivacyPolicyViewController alloc] initWithNibName:@"PrivacyPolicyViewController" bundle:nil];
    [self presentViewController:webVc animated:YES completion:nil];
    [webVc loadUrlString:@"http://www.surbitonfoodfestival.org/application-privacy-statement/"];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
    } else {
        NSLog(@"Message failed");
    }
}

@end
