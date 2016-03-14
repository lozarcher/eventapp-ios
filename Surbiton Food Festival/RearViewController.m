
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"

#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "EventListViewController.h"
#import "TwitterViewController.h"
#import "TraderListViewController.h"
#import "PostListViewController.h"
#import "AboutAppViewController.h"
#import "VoucherListViewController.h"
#import "GalleryViewController.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.plates = [[NSArray alloc] initWithObjects:@"blue-plate.png", @"green-plate.png", @"indigo-plate.png", @"magenta-plate.png", @"orange-plate.png", @"red-plate.png", @"yellow-plate.png", @"white-plate.png", nil];
    self.title = NSLocalizedString(@"", nil);
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[self.plates objectAtIndex:row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	
    NSString *text = nil;
    if (row == 0)
    {
        text = @"Home";
    }
    else if (row == 1)
    {
        text = @"Event Calendar";
    }
    else if (row == 2)
    {
        text = @"Traders";
    }
    else if (row == 3)
    {
        text = @"News";
    }
    else if (row == 4)
    {
        text = @"Twitter";
    }
    else if (row == 5)
    {
        text = @"Gallery";
    }
    else if (row == 6)
    {
        text = @"Vouchers";
    }
    else if (row == 7)
    {
        text = @"Contact / Help";
    }
    cell.textLabel.text = NSLocalizedString( text,nil );
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    /*
     else if (row == 2)
    {
        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        return;
    }
    else if (row == 3)
    {
        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
        return;
    }
     */
    // otherwise we'll create a new frontViewController and push it with animation

    UIViewController *newFrontController = nil;

    if (row == 0)
    {
        HomeViewController *homeView = [[HomeViewController alloc] init];
        homeView.rearViewController = self;
        newFrontController = homeView;
    }
    
    else if (row == 1)
    {
        newFrontController = [[EventListViewController alloc] init];
    }
    
    else if (row == 2)
    {
        newFrontController = [[GalleryViewController alloc] init];
    }
  
    else if (row == 3)
    {
        newFrontController = [[PostListViewController alloc] init];
    }

    else if (row == 4)
    {
        newFrontController = [[TraderListViewController alloc] init];
    }
    
    else if (row == 5)
    {
        newFrontController = [[VoucherListViewController alloc] init];
    }
    
    else if (row == 6)
    {
        newFrontController = [[TwitterViewController alloc] init];
    }
    
    else if (row == 7)
    {
        newFrontController = [[AboutAppViewController alloc] init];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];

    _presentedRow = row;  // <- store the presented row
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}

@end