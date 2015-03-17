//
//  MessageViewCell.h
//  Surbiton Food Festival
//
//  Created by Loz Archer on 17/03/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
-(void)populateDataInCell:(Message *) message;
@end
