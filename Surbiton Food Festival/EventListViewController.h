//
//  FirstViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventViewCell.h"
#import "Category.h"
#import "FontAwesomeKit/FAKFontAwesome.h"
#import "HTHorizontalSelectionList/HTHorizontalSelectionList.h"
#import <UserNotifications/UserNotifications.h>

@interface EventListViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate, HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate> {
    NSArray *_events;
    NSArray *_categories;
    NSMutableArray *_filteredEvents;
    NSMutableDictionary *_eventDays;
    NSMutableArray *_eventDayKeys;
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *categoriesListView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) EventViewCell *prototypeCell;
@property Category *selectedCategory;
@property NSMutableDictionary *favourites;
- (void)refreshEvents:(id)sender;
-(void)setFavourite:(Event *)event;

@end

