//
//  HomeViewController.m
//  IYAF 2015
//
//  Created by Loz Archer on 08/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "EventViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = NSLocalizedString(@"", nil);
    self.navigationController.navigationBar.hidden = YES;
    
    SWRevealViewController *revealController = [self revealViewController];

    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Home.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    if (IS_OS_8_OR_LATER) {
        float degrees = 7; //the value in degrees
        self.eventImage.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    }
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}
-(void)loadHome {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadEvents{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadPosts{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadTraders{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadTwitter{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
     [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadGalleryPage{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadInfoPage{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    self.gapBeforeMenu.constant = height * 0.45;
    
    [self setUpButtons];
}

-(void)setUpButtons {
    // Button taps
    UITapGestureRecognizer *eventTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadEvents)];
    eventTap.numberOfTapsRequired = 1;
    [self.eventImage setUserInteractionEnabled:YES];
    [self.eventImage addGestureRecognizer:eventTap];
    
    UITapGestureRecognizer *performerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadTraders)];
    performerTap.numberOfTapsRequired = 1;
    [self.performersImage setUserInteractionEnabled:YES];
    [self.performersImage addGestureRecognizer:performerTap];
    
    UITapGestureRecognizer *newsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPosts)];
    newsTap.numberOfTapsRequired = 1;
    [self.newsImage setUserInteractionEnabled:YES];
    [self.newsImage addGestureRecognizer:newsTap];
    
    UITapGestureRecognizer *twitterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadTwitter)];
    twitterTap.numberOfTapsRequired = 1;
    [self.twitterImage setUserInteractionEnabled:YES];
    [self.twitterImage addGestureRecognizer:twitterTap];
    
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadInfoPage)];
    infoTap.numberOfTapsRequired = 1;
    [self.infoImage setUserInteractionEnabled:YES];
    [self.infoImage addGestureRecognizer:infoTap];
    
    UITapGestureRecognizer *galleryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadGalleryPage)];
    galleryTap.numberOfTapsRequired = 1;
    [self.galleryImage setUserInteractionEnabled:YES];
    [self.galleryImage  addGestureRecognizer:galleryTap];
    
}


@end
