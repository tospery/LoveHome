//
//  LHCommentCell.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/18.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCommentCell.h"
#import "LHStarView.h"

@interface LHCommentCell ()
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *avatarButton;
@property (nonatomic, weak) IBOutlet LHStarView *starView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *height1Constraint;

@property (nonatomic, weak) IBOutlet UILabel *replyLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation LHCommentCell
- (void)awakeFromNib {
    // Initialization code
    [self.avatarButton exCircleWithColor:[UIColor clearColor] border:0];
    [self.replyLabel exSetBorder:[UIColor clearColor] width:0.0 radius:8.0];
    self.starView.enabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setComment:(LHComment *)comment {
    _comment = comment;
    
    [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:comment.avatar] forState:UIControlStateNormal placeholderImage:kImagePHUserAvatar];
    self.nicknameLabel.text = comment.nickName;
    self.timeLabel.text = comment.publishTime;
    self.starView.level = comment.level;
    [self.starView loadData];
    
    CGSize size = [comment.content exSizeWithFont:[UIFont systemFontOfSize:14.0f] width:kJXScreenWidth - 12 - 8];
    self.height1Constraint.constant = size.height;
    self.contentLabel.text = comment.content;
    
    if (LHCommentReplyStatusNormal == comment.shopReplyStatus) {
        if (comment.shopReplyContent.length != 0) {
            NSString *reply = [NSString stringWithFormat:@"掌柜回复：%@", comment.shopReplyContent];
            CGSize size = [reply exSizeWithFont:[UIFont systemFontOfSize:14.0f] width:kJXScreenWidth - 12 - 8];
            self.heightConstraint.constant = size.height + 8;
            self.replyLabel.text = reply;
        }
    }
}

+ (NSString *)identifier {
    return @"LHCommentCellIdentifier";
}

+ (CGFloat)heightForComment:(LHComment *)comment {
    CGFloat height = 109.f;
    CGSize size = [comment.content exSizeWithFont:[UIFont systemFontOfSize:14.0f] width:kJXScreenWidth - 12 - 8];
    height += size.height;
    
    if (LHCommentReplyStatusNormal == comment.shopReplyStatus) {
        if (comment.shopReplyContent.length != 0) {
            NSString *reply = [NSString stringWithFormat:@"掌柜回复：%@", comment.shopReplyContent];
            size = [reply exSizeWithFont:[UIFont systemFontOfSize:14.0f] width:kJXScreenWidth - 12 - 8];
            height += size.height + 8;
        }
    }
    
    return height;
}
@end
