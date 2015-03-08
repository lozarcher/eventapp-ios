//
//  VenueViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 05/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VenueViewController.h"
#import "Venue.h"

@interface VenueViewController ()

@end

@implementation VenueViewController

- (IBAction)closeButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@synthesize venueNameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
