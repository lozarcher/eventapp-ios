//
//  FirstViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 31/01/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventViewCell.h"
#import "FontAwesomeKit/FAKFontAwesome.h"

@interface EventListViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate> {
    NSArray *_events;
    NSMutableArray *_filteredEvents;
    NSMutableDictionary *_eventDays;
    NSMutableArray *_eventDayKeys;
    NSString *storePath;
    NSMutableData *receivedData;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UIRefreshControl *refreshControl;
@property (retain,nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) EventViewCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *allEventsTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *favouritesTab;
@property BOOL showFavourites;
@property NSMutableDictionary *favourites;
- (void)refreshEvents:(id)sender;
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;
-(void)setFavourite:(NSString *)eventId;
@end

