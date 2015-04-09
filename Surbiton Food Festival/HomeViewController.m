//
//  HomeViewController.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 08/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = NSLocalizedString(@"", nil);
    self.navigationController.navigationBar.hidden = YES;
    
    SWRevealViewController *revealController = [self revealViewController];

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}

-(void)loadEvents{
    NSLog(@"Tapped load events");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadTraders{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadMessaging{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadTwitter{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
     [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadVouchers{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadKingstonPound{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Home Screen";
    [self setUpButtons];
}

-(void)setUpButtons {
    // Button taps
    UITapGestureRecognizer *eventsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadEvents)];
    eventsTap.numberOfTapsRequired = 1;
    [self.greenPlate addGestureRecognizer:eventsTap];
    UITapGestureRecognizer *traderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadTraders)];
    traderTap.numberOfTapsRequired = 1;    
    [self.indigoPlate addGestureRecognizer:traderTap];
    UITapGestureRecognizer *messagingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMessaging)];
    messagingTap.numberOfTapsRequired = 1;
    [self.magentaPlate addGestureRecognizer:messagingTap];
    UITapGestureRecognizer *twitterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadTwitter)];
    twitterTap.numberOfTapsRequired = 1;
    [self.orangePlate addGestureRecognizer:twitterTap];
    UITapGestureRecognizer *voucherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVouchers)];
    voucherTap.numberOfTapsRequired = 1;
    [self.redPlate addGestureRecognizer:voucherTap];
    UITapGestureRecognizer *kPoundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadKingstonPound)];
    kPoundTap.numberOfTapsRequired = 1;
    [self.yellowPlate addGestureRecognizer:kPoundTap];
}


@end
