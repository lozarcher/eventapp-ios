//
//  EventViewCell.h
//  Surbiton Food Festival
//
//  Created by Laurence Archer on 16/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trader.h"

@interface TraderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *traderNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *traderImage;
-(void)populateDataInCell:(Trader *)trader;
@property (weak, nonatomic) IBOutlet UIImageView *kingstonPoundImage;

@end
