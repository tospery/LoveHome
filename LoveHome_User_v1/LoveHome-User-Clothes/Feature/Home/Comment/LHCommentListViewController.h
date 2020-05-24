//
//  LHCommentViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/18.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHCommentListViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithShopid:(NSInteger)shopid;

@end
