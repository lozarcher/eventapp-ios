//
//  HomeViewController.m
//  Surbiton Food Festival
//
//  Created by Loz Archer on 08/04/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"yellow-cloth-tile.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)loadHome {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadEvents{
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
-(void)loadGallery{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}
-(void)loadKingstonPound{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.rearViewController tableView:self.rearViewController.rearTableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat topPadding = 20;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        if (window.safeAreaInsets.top > topPadding)
            topPadding = window.safeAreaInsets.top;
    }
    self.topMargin.constant = topPadding;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat extraScreenHeight = screenRect.size.height - 568;
    self.menuTop.constant = self.menuTop.constant + (extraScreenHeight * 0.2);
    self.menuBottom.constant = self.menuBottom.constant + (extraScreenHeight * 0.8);
    
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
    UITapGestureRecognizer *galleryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadGallery)];
    galleryTap.numberOfTapsRequired = 1;
    [self.redPlate addGestureRecognizer:galleryTap];
    UITapGestureRecognizer *kPoundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadKingstonPound)];
    kPoundTap.numberOfTapsRequired = 1;
    [self.yellowPlate addGestureRecognizer:kPoundTap];
}


@end
