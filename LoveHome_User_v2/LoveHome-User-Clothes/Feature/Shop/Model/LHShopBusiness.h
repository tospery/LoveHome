//
//  LHShopBusiness.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHProductCategory.h"

//"id": 1,
//"name": "洗衣",
//"categories": [

@interface LHShopBusiness : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *categories;

@end
