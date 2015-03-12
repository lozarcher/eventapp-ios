//
//  NewEventListViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterViewCell.h"

@interface TwitterViewController : UIViewController <tweetLinkProtocol, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *_tweets;
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (retain,nonatomic) UILabel *messageLabel;

@end
