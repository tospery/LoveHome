//
//  LHVerifyShopCartResult.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/2.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHVerifyShopCartResultSpecify : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *url;
@end

@interface LHVerifyShopCartResultProduct : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray *specifies;
@end

@interface LHVerifyShopCartResultShop : NSObject
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, strong) NSArray *products;
@end

@interface LHVerifyShopCartResult : NSObject
@property (nonatomic, strong) NSArray *normalPro;
@property (nonatomic, strong) NSArray *passDueProducts;

@end
