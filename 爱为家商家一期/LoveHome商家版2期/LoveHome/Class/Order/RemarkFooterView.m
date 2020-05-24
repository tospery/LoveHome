//
//  RemarkFooterView.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/28.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "RemarkFooterView.h"

@implementation RemarkFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _remarkContent.layer.cornerRadius = 4;
    _remarkContent.clipsToBounds = YES;

}

+ (NSString *)cellIndentiferStr
{
    return @"RemarkFooterView";
}

+(CGFloat)getCellHeight:(OrderModel *)order
{
    CGFloat base = 45;
    
    NSString *content = [NSString stringWithFormat:@"  %@",order.remark];
    
    CGFloat height  =  [content stringContetenSizeWithFount:[UIFont systemFontOfSize:14] andSize:CGSizeMake(SCREEN_WIDTH - 16, 1000)].size.height;

    if (height > (45 - 16)) {
        return height + 16;
    }
    else
    {
    return base;        
    }
    

}

@end
