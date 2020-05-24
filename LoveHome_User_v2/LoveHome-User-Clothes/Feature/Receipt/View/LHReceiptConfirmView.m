//
//  LHReceiptConfirmView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/30.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptConfirmView.h"

@interface LHReceiptConfirmView ()
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, weak) IBOutlet UIButton *entryButton;
@end

@implementation LHReceiptConfirmView
- (void)awakeFromNib {
    [self.okButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x26c8c6)] forState:UIControlStateHighlighted];
    
    [self.entryButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xFFFFFF)] forState:UIControlStateNormal];
    [self.entryButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0xFFFFF0)] forState:UIControlStateHighlighted];
    
    [self exSetBorder:[UIColor clearColor] width:0.0 radius:8.0f];
    
    //self.checkButton.selected = gLH.isReceiptPromptClosed;
    self.addressLabel.text = gLH.receipt.address;
}

- (IBAction)checkButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (IBAction)pressed:(UIButton *)btn {
    if (_clickBlock) {
        _clickBlock(btn.tag - 100, self.checkButton);
    }
}
@end




