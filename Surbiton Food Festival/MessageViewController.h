//
//  NewEventListViewController.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UIBubbleTableViewDataSource.h"

@interface MessageViewController : GAITrackedViewController <NSURLConnectionDelegate, UIBubbleTableViewDataSource> {
    NSMutableArray *_messages;
    NSMutableArray *_bubbleData;
    NSString *storePath;
    NSMutableData *receivedData;
    BOOL isPaginatedLoad;
}

@property (retain,nonatomic) IBOutlet UIBubbleTableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (retain,nonatomic) UILabel *messageLabel;
@property (retain,nonatomic) NSString *nextPage;
- (void)refreshMessages:(id)sender;

@end
