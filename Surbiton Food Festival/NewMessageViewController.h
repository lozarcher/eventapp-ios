//
//  NewMessageViewController.h
//  Surbiton Food Festival
//
//  Created by Loz on 19/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface NewMessageViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@end
