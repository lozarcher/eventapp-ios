//
//  FirstViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TraderViewCell.h"
#import "GAITrackedViewController.h"

@interface TraderListViewController : GAITrackedViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *_traders;
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (retain,nonatomic) UILabel *messageLabel;
@property (nonatomic, strong) TraderViewCell *prototypeCell;
- (void)refreshTraders:(id)sender;

@end

