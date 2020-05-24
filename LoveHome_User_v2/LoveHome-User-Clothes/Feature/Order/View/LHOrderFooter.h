//
//  LHOrderFooter.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHOrderFooterActionCallback)(LHOrder *order, LHOrderActionType type);

@interface LHOrderFooter : UITableViewHeaderFooterView
@property (nonatomic, copy) LHOrderFooterActionCallback callback;

- (void)configOrder:(LHOrder *)order type:(LHOrderRequestType)type;

+ (NSString *)identifier;
+ (CGFloat)height;
@end
