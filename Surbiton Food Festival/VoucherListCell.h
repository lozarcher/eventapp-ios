//
//  VoucherListCell.h
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voucher.h"

@interface VoucherListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *voucherTitleLabel;
-(void)populateDataInCell:(Voucher *)voucher;

@end
