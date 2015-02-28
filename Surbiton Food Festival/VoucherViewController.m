//
//  VoucherViewController.m
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VoucherViewController.h"

@implementation VoucherViewController

- (id)initWithImage:(UIImage *)anImage
{
    if (self = [super init])
    {
        image = anImage;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    // Set the main view of this UIViewController to be a UIScrollView.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the scroll view.
    CGSize photoSize = [image size];
    
    // Create the image view. We push the origin to (0, -44) to ensure
    // that this view displays behind the navigation bar.
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                                              photoSize.width, photoSize.height)];
    self.imageView.userInteractionEnabled =TRUE;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tap];
    
    [self.imageView setImage:image];
    [self setView:self.imageView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    //[[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    //[[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    //UIImageView *myImage = (UIImageView *)gestureRecognizer.view;
    // do stuff;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //	(iOS 5)
    //	Only allow rotation to portrait
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (BOOL)shouldAutorotate
{
    //	(iOS 6)
    //	No auto rotating
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //	(iOS 6)
    //	Only allow rotation to portrait
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //	(iOS 6)
    //	Force to portrait
    return UIInterfaceOrientationLandscapeLeft;
}

@end
