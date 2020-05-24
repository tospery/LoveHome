//
//  LHOrderDetailViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/8.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHOrderDetailViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) LHOrderRequestType type;
@property (nonatomic, strong) LHOrder *order;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
