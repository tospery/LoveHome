//
//  LHAddressCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/25.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptCell.h"

@interface LHReceiptCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *mobileLabel;
@property (nonatomic, weak) IBOutlet UILabel *areaLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIButton *dfButton;
@property (nonatomic, weak) IBOutlet UIButton *delButton;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingConstraint;

@property (nonatomic, copy) LHReceiptCellEditPressedBlock editPressedBlock;
@property (nonatomic, copy) LHReceiptCellDeletePressedBlock deletePressedBlock;
@end

@implementation LHReceiptCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editButtonPressed:(id)sender {
    if (self.editPressedBlock) {
        self.editPressedBlock(sender);
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.deletePressedBlock) {
        self.deletePressedBlock(sender);
    }
}

- (void)setReceipt:(LHReceipt *)receipt {
    _receipt = receipt;
    
    if (receipt.isDefault) {
        if (kIsLocalCart) {
            self.bgImageView.image = [UIImage imageNamed:@"address_normal"];
            [self.dfButton setHidden:YES];
            [self.delButton setHidden:NO];
            //self.trailingConstraint.constant = 94.0f;
        }else {
            self.bgImageView.image = [UIImage imageNamed:@"address_default"];
            [self.dfButton setHidden:NO];
            [self.delButton setHidden:YES];
            //self.trailingConstraint.constant = 20.0f;
        }
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"address_normal"];
        [self.dfButton setHidden:YES];
        [self.delButton setHidden:NO];
        //self.trailingConstraint.constant = 94.0f;
    }
    
    self.nameLabel.text = receipt.name;
    self.mobileLabel.text = receipt.mobile;
    self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@", receipt.provinceName, receipt.cityName, receipt.areaName];
    
    if (receipt.addressExpand.length != 0) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@", receipt.address, receipt.addressExpand];
    }else {
        self.addressLabel.text = receipt.address;
    }
}

- (void)setupEditPressedBlock:(LHReceiptCellEditPressedBlock)editPressedBlock
           deletePressedBlock:(LHReceiptCellDeletePressedBlock)deletePressedBlock {
    self.editPressedBlock = editPressedBlock;
    self.deletePressedBlock = deletePressedBlock;
}

+ (NSString *)identifier {
    return @"LHReceiptCellIdentifier";
}

+ (CGFloat)height {
    return 160.0f;
}
@end

