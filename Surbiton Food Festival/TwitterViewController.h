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
    NSMutableArray *_tweets;
    NSString *storePath;
    NSMutableData *receivedData;
    BOOL isPaginatedLoad;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (retain,nonatomic) UILabel *messageLabel;
@property (retain,nonatomic) NSString *nextPage;
@property (nonatomic, strong) TwitterViewCell *prototypeCell;


@end
