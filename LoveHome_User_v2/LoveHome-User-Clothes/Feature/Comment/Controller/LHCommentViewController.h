//
//  LHCommentShopViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/9.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHCommentViewController : LHBaseViewController <UITextViewDelegate>
@property (nonatomic, strong) LHOrder *order;
@property (nonatomic, assign) NSInteger section;

@end
