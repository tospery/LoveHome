//
//  JXPage.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "JXPage.h"

@implementation JXPage
- (instancetype)init {
    if (self = [super init]) {
        _currentPage = 1;
        _pageSize = 20;
    }
    return self;
}

@end
