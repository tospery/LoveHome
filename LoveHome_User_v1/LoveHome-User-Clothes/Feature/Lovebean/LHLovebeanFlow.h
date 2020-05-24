//
//  LHLovebeanFlow.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//"id": 29,
//"accountid": 120,
//"changenumber": 50,
//"changetime": "2015-08-25 03:34:07",
//"fromto": "参与活动",
//"devicename": "APP-IOS"

@interface LHLovebeanFlow : NSObject
@property (nonatomic, assign) NSInteger changenumber;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *accountid;
@property (nonatomic, strong) NSString *changetime;
@property (nonatomic, strong) NSString *fromto;
@property (nonatomic, strong) NSString *devicename;

@end
