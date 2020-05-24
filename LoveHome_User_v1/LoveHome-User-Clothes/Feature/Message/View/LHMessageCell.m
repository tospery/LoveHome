//
//  LHMessageCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/20.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMessageCell.h"

@interface LHMessageCell ()
@property (nonatomic, weak) IBOutlet UILabel *msgTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *msgContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *msgTimeLabel;
@end

@implementation LHMessageCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(LHMessage *)message {
    _message = message;
    
    self.msgTitleLabel.text = message.title;
    self.msgContentLabel.text = message.content;
    self.msgTimeLabel.text = message.pushTime; //[message.pushTime exStringWithFormat:kJXFormatDatetimeNormal];
}

+ (NSString *)identifier {
    return @"LHMessageCellIdentifier";
}

+ (CGFloat)height {
    return 124.0f;
}

+ (CGFloat)heightForMessage:(LHMessage *)message {
    CGFloat height = 86.0f;
    if (message.content.length > 0) {
        CGSize size = [message.content exSizeWithFont:[UIFont systemFontOfSize:15.0f] width:(kJXScreenWidth - 20 - 20 - 8 - 8)];
        height += size.height;
    }
    return height;
}
@end





