//
//  LHProductCategory.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHProduct.h"

//"id": 25,
//"name": "上装",
//"products": [

@interface LHProductCategory : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *products;

@end
