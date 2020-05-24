//
//  NotificationViewCell.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/15.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "NotificationViewCell.h"
#import "NSString+ContentSize.h"
@interface NotificationViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *pushTimeLable;
@property (weak, nonatomic) IBOutlet UIView *showView;


@end

@implementation NotificationViewCell

- (void)awakeFromNib {
    // Initialization code
    _showView.layer.cornerRadius = 4;
}

- (void)setNotiModel:(NotificationModel *)notiModel
{
    _notiModel = notiModel;
    _orderIdLable.text = _notiModel.title;
    _contentLable.text =_notiModel.content;
    _pushTimeLable.text = _notiModel.pushTime;
}

+(CGFloat)cellHeightWithData:(NotificationModel *)notiModel
{
    CGFloat baseHeight = 96;
    
   CGRect   content  = [notiModel.content stringContetenSizeWithFount:[UIFont systemFontOfSize:15] andSize:CGSizeMake(SCREEN_WIDTH - 14, 10000)];
   
    if (content.size.height > 18) {
        return content.size.height - 18 + baseHeight;
    }
    
    return baseHeight;
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
