//
//  OrderDetailModel.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

//                        {
//                            "specPrice": 0.02,
//                            "count": 1,
//                            "productName": "9.9洗衣",
//                            "imageUrl": "1131"
//                        }

@interface OrderDetailModel : NSObject
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) CGFloat specPrice;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *specName;
@property (nonatomic, strong) NSString *imageUrl;

@end
