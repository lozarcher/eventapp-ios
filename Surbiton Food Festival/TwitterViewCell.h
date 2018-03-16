//
//  TwitterViewCell.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 02/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "KILabel.h"

@interface TwitterViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet KILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (retain, nonatomic) UIWebView *webView;

-(void)populateDataInCell:(Tweet *)tweet;

@end
