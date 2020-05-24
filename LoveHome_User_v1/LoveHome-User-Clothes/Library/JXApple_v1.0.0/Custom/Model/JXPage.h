//
//  JXPage.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXPage : NSObject
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalRows;

@end
