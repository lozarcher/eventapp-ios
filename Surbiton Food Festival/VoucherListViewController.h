//
//  VoucherListViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherListViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *_vouchers;
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
- (void)refreshVouchers:(id)sender;

@end
