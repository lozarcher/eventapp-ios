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
    
    /*
     FBLoginView *loginView = [[FBLoginView alloc] initWithPublishPermissions:@[@"rsvp_event"] defaultAudience:FBSessionDefaultAudienceEveryone];
     // Align the button in the center horizontally
     loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), self.view.center.y - (loginView.frame.size.height / 2));
     [self.view addSubview:loginView];
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Home Screen";
}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
    UIViewController *stubController = [[UIViewController alloc] init];
    stubController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:stubController animated:YES];
}

@end
