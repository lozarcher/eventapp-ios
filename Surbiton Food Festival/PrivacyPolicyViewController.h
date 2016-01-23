//
//  PrivacyPolicyViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 20/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPolicyViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
-(void)loadUrlString:(NSString *)urlString;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;

@end
