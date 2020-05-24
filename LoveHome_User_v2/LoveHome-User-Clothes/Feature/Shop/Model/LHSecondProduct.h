//
//  LHSecondProduct.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/29.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSecondProduct : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
//@property (nonatomic, assign) CGFloat actPriceType;
//@property (nonatomic, assign) CGFloat actPrice;
@property (nonatomic, strong) NSString *url;    // YJX_TODO 服务器缺少该字段
@property (nonatomic, strong) NSArray *specifies;

@end
