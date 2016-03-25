//
//  InfoViewCell.h
//  Surbiton Food Festival
//
//  Created by Loz on 25/03/2016.
//  Copyright © 2016 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"

@interface InfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;

-(void)populateDataInCell:(Info *)info;


@end
