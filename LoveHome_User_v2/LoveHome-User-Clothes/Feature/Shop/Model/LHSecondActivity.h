//
//  LHSecondActivity.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//"activityTitle":"全场7折",
//"activityId":21,
//"actPriceType":1,
//"actPrice":7,
//"actProductImgUrl":"http://img-test.appvworks.com/7b3a08c8ace146eeafaf33e64f4f41a1",

typedef NS_ENUM(NSInteger, LHSecondActivityType){
    LHSecondActivityTypeNone,
    LHSecondActivityTypeDiscount,
    LHSecondActivityTypeCombination
};

@interface LHSecondActivity : NSObject
@property (nonatomic, assign) LHSecondActivityType actPriceType;
@property (nonatomic, assign) CGFloat actPrice;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityTitle;
@property (nonatomic, strong) NSString *actProductImgUrl;
@property (nonatomic, strong) NSArray *categories;

@end
