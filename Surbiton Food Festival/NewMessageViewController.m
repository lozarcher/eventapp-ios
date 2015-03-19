//
//  NewMessageViewController.m
//  Surbiton Food Festival
//
//  Created by Loz on 19/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "NewMessageViewController.h"
#import "Message.h"
#import "MTConfiguration.h"
#import "MessageViewController.h"

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
    [self.messageEntryDialog setHidden:NO];
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    [self.messageEntryDialog setHidden:YES];
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

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[message dictionary] options:0 error:&error];
    if (jsonData) {
        NSString *postUrl = [NSString stringWithFormat:@"%@/messages/post", [MTConfiguration serviceHostname]];
        
        // Create the request.
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl]
                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                         timeoutInterval:10.0];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        NSURLResponse* response;
        NSData* responseData = nil;
        
        NSLog(@"Sending request to %@", postUrl);
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog(@"Error :%@", [error debugDescription]);
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"the final output is:%@",responseString);
        BOOL success = !error && responseString;
        NSString *message = (success) ? @"Your message has been sent!" : @"Sorry, the message failed, try again later";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];
        if (success) {
            [self.parent refreshMessages:self];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Sorry, the message failed, try again later" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];

        NSLog(@"Unable to serialize the data %@: %@", [message dictionary], error);
    }
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
