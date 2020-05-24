//
//  LHCartViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHCartViewController : LHBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) LHEntryFrom from;

//@property (nonatomic, assign) BOOL isPushed;
//@property (nonatomic, assign) BOOL isPresented;

@end
