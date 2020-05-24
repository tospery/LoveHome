//
//  LHLovebeanWrapper.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHLovebeanFlow.h"

//"money": 9999994.05,
//"loveBeansNumber": 999999405,
//"list": [
//]

@interface LHLovebeanWrapper : NSObject
@property (nonatomic, assign) BOOL signedToday;
@property (nonatomic, assign) CGFloat money;
@property (nonatomic, assign) CGFloat loveBeansNumber;
@property (nonatomic, strong) NSArray *flows;

@end
