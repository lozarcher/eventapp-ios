//
//  FirstViewController.h
//  IYAF 2015
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewCell.h"

@interface PostListViewController : UIViewController <tweetLinkProtocol, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_posts;
    NSString *storePath;
    NSMutableData *receivedData;
    BOOL isPaginatedLoad;
    NSMutableDictionary *heightsCache;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (retain,nonatomic) UILabel *messageLabel;
@property (nonatomic, strong) PostViewCell *prototypeCell;
@property (retain,nonatomic) NSString *nextPage;
- (void)refreshPosts:(id)sender;

@end

