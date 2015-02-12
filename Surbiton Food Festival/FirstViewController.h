//
//  FirstViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *_events;
    NSString *storePath;
}

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@end

