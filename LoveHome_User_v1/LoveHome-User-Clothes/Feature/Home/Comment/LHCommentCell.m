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
@end

@implementation LHCommentCell
- (void)awakeFromNib {
    // Initialization code
    [self.avatarButton exCircleWithColor:[UIColor clearColor] border:0];
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
    self.contentLabel.text = comment.content;
}

+ (NSString *)identifier {
    return @"LHCommentCellIdentifier";
}

+ (CGFloat)heightForComment:(LHComment *)comment {
    CGFloat height = 109.f;
    CGSize size = [comment.content exSizeWithFont:[UIFont systemFontOfSize:14.0f] width:kJXScreenWidth - 12 - 8];
    height += size.height;
    
    return height;
}
@end
