//
//  LHLocateReceiptCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/17.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHLocateReceiptCell.h"

@interface LHLocateReceiptCell ()
@property (nonatomic, weak) IBOutlet UIButton *statusButton;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@end

@implementation LHLocateReceiptCell

- (void)awakeFromNib {
    // Initialization code
    [_countLabel exCircleWithColor:[UIColor redColor] border:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReceipt:(LHReceipt *)receipt {
    _receipt = receipt;
    
    if (kIsLocalCart) {
        _statusButton.selected = NO;
    }else {
        _statusButton.selected = receipt.isDefault;
    }
    
    _nameLabel.text = receipt.name;
    _phoneLabel.text = receipt.mobile;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receipt.provinceName, receipt.cityName, receipt.address, receipt.addressExpand.length != 0 ? receipt.addressExpand : @""];
    
    if (receipt.productCount > 9) {
        _countLabel.text = @"9+";
    }else {
        _countLabel.text = JXStringFromInteger(receipt.productCount);
    }
}

+ (NSString *)identifier {
    return @"LHLocateReceiptCellIdentifier";
}

+ (CGFloat)height {
    return 70.0f;
}

@end
