//
//  VoucherListCell.m
//  Surbiton Food Festival
//
//  Created by Loz on 28/02/2015.
//  Copyright (c) 2015 Spirit of Seething. All rights reserved.
//

#import "VoucherListCell.h"

@implementation VoucherListCell

@synthesize voucherTitleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)populateDataInCell:(Voucher *)voucher {
    voucherTitleLabel.text = [voucher title];
}
@end
