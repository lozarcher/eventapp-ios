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

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView = [[UIWebView alloc] init];

    [self.view addSubview:webView];
    //[webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.bbc.co.uk/"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started load");
};
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished load");
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (IBAction)closeButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
