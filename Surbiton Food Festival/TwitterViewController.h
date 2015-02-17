//
//  NewEventListViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetView.h"

@interface TwitterViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
        NSArray *_tweets;
        NSString *storePath;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (retain,nonatomic) UIRefreshControl *refreshControl;

@end
