//
//  RemarkFooterView.h
//  LoveHome
//
//  Created by MRH-MAC on 15/9/28.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface RemarkFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *remarkContent;

+ (NSString *)cellIndentiferStr;
+(CGFloat)getCellHeight:(OrderModel *)order;
@end
