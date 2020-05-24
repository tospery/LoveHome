//
//  RegistSuceesViewController.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"
typedef NS_ENUM(NSInteger, AutoStatus){
    AutoStatusNoOne,
    AutoStatusWating,         // 审核中
    AutoStatusUnPass,     // 未通过
    AutoStatusSuceess,       // 成功
    AutoStatusFail
};


@interface RegistSuceesViewController : ModelViewController
@property (nonatomic,assign) AutoStatus autoStatu;
@property (nonatomic,strong) NSString *autoStatuString;
@end
