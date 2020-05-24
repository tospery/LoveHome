//
//  LHAddressViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

typedef NS_ENUM(NSInteger, LHReceiptFrom){
    LHReceiptFromChoose,
    LHReceiptFromManage
};

@interface LHReceiptViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) LHReceiptFrom from;

@end
