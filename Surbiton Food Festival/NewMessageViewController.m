//
//  NewMessageViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 19/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "NewMessageViewController.h"
#import "Message.h"

@interface NewMessageViewController ()

@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Check to see if we are running on iOS 6
    if (![self respondsToSelector:@selector(topLayoutGuide)]) {
        self.topConstraint.constant = self.topConstraint.constant - 64;
    }
    
    self.loginView.readPermissions = @[@"public_profile"];
    self.loginView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Call method when user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = [user objectID];
    self.nameLabel.text = user.name;
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
}
- (IBAction)sendButtonPressed:(id)sender {
    NSLog(@"Sending message from %@", self.nameLabel.text);
    NSLog(@"Message: %@", self.messageField.text);
    NSString *profilePicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.profilePictureView.profileID];
    NSLog(@"Profile pic: %@", profilePicUrl);
    Message *message = [[Message alloc] init];
    [message setProfilePic:profilePicUrl];
    [message setName:self.nameLabel.text];
    [message setText:self.messageField.text];
    
    
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
