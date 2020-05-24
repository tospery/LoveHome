//
//  LH2Shop.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/1/21.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LH2Shop : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *products;

@end
