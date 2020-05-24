//
//  LHComment.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/17.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//"accountId": 692,
//"commentId": 188,
//"content": "好评",
//"level": 5,
//"avatar": null,
//"nickName": null,
//"publishTime": "2016-01-08 10:22:48",
//"shopReplyStatus": 1,                     1正常， 2屏蔽
//"shopReplyTime": null,
//"shopReplyContent": "模型形式"

typedef NS_ENUM(NSInteger, LHCommentReplyStatus){
    LHCommentReplyStatusNone,
    LHCommentReplyStatusNormal,
    LHCommentReplyStatusPingBi
};

@interface LHComment : NSObject
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, assign) LHCommentReplyStatus shopReplyStatus;
@property (nonatomic, strong) NSString *shopReplyTime;
@property (nonatomic, strong) NSString *shopReplyContent;

@end

@interface LHCommentCollection : NSObject
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSArray *comments;

@end