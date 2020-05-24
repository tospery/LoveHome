//
//  LHPaySuccessViewController.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/7.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHOperationSuccessViewController : LHBaseViewController <UMSocialUIDelegate>
@property (nonatomic, assign) LHEntryFrom from;
@property (nonatomic, assign) LHOperationSuccessType type;
@property (nonatomic, strong) LHOrder *order;

@end
