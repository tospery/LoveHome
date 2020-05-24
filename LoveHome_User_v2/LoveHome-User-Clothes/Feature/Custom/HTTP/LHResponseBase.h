//
//  LHResponseBase.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/22.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHResponseBase : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;

@end
