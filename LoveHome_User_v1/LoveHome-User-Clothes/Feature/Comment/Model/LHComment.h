//
//  LHComment.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/17.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHComment : NSObject
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *publishTime;

@end

@interface LHCommentCollection : NSObject
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSArray *comments;

@end