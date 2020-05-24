//
//  LH2Product.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/1/21.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LH2Product : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger actType;
@property (nonatomic, copy) NSString *actPrice;
@property (nonatomic, copy) NSString *actUrl;

//@property (nonatomic, assign) NSInteger actType;

@end
