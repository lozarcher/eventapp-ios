//
//  SecondViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UITableViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *_tweets;
    NSString *storePath;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;

@end

