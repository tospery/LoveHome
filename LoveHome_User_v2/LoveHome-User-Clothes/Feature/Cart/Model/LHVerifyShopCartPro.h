//
//  LHVerifyShopCartPro.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/2.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHVerifyShopCartProProduct : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *specId;

@end

@interface LHVerifyShopCartProShop : NSObject
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSArray *products;

@end
