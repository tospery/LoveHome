//
//  PageInfo.h
//  LoveHome
//
//  Created by 杨建祥 on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paging : NSObject
@property (nonatomic, assign) BOOL onceToken;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;

@end
