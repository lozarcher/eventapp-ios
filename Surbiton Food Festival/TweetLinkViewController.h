//
//  TweetLinkViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 12/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetLinkViewController : UINavigationController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
-(void)loadUrlString:(NSString *)urlString;
@end
