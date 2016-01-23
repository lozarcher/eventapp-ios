//
//  TweetLinkViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetLinkViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
-(void)loadUrlString:(NSString *)urlString;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@end
