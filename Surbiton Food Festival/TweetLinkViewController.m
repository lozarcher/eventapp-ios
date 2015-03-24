//
//  TweetLinkViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 12/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "TweetLinkViewController.h"

@interface TweetLinkViewController ()

@end

@implementation TweetLinkViewController

@synthesize spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Tweet Link View";
}


-(void)loadUrlString:(NSString *)urlString {
    [self activateSpinner:YES];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self activateSpinner:YES];
};
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self activateSpinner:NO];
    NSLog(@"Error");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self activateSpinner:NO];
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (IBAction)closeButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)activateSpinner:(BOOL)activate {
    if (activate) {
        if (!spinner) {
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.view addSubview:spinner];
            spinner.center = CGPointMake(160, 240);
            spinner.hidesWhenStopped = YES;
        }
        [spinner startAnimating];
    } else {
        if (spinner) {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        }
    }
}

- (IBAction)openInSafariPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webView.request.URL.absoluteString]];

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
