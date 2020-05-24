//
//  LHAddProductRequest.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/31.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "addressId": 0,
//    "productIds": [
//                   {
//                       "shopId": 0,
//                       "productId": 0,
//                       "specifieId": 0,
//                       "buyCount": 0
//                   }
//                   ]
//}

@class LHAddProductRequestProduct;

@interface LHAddProductRequest : NSObject
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, strong) NSArray *productIds;
@end

@interface LHAddProductRequestProduct : NSObject
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger specifieId;
@property (nonatomic, assign) NSInteger buyCount;
@property (nonatomic, copy) NSString *activityId;

@end
