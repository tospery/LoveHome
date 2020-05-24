//
//  LHHTTPClient.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "LHHTTPClient.h"
#import "UIImage+LoveHome.h"
#import "LHSecondBusiness.h"
#import "LHSecondActivity.h"
#import "LHSecondCategory.h"
#import "LHSecondProduct.h"
#import "LHSecondSpecify.h"
#import "LHCartInfo.h"

@implementation LHHTTPClient
#pragma mark - Web APIs
#pragma mark - 个人
#pragma mark 用户反馈
+ (AFHTTPRequestOperation *)requestCheckUserJionActCountWithActId:(NSString *)actId
                                                        productId:(NSString *)productId
                                                          success:(LHHTTPRequestSuccessBlock)success
                                                          failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"actId": actId,
                             @"productId": productId};
    return [LHHTTPClient sendPostRequestWithPathString:@"activity/checkUserJionActCount" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

+ (AFHTTPRequestOperation *)requestFeedbackWithContent:(NSString *)content
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"suggestion": content};
    return [LHHTTPClient sendPostRequestWithPathString:@"suggestion/addByUser" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}
#pragma mark 收藏-店铺-检查
+ (AFHTTPRequestOperation *)requestFavoriteCheckWithShopid:(NSString *)shopid
                                                   success:(LHHTTPRequestSuccessBlock)success
                                                   failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": shopid ? shopid : @""};
    return [LHHTTPClient sendPostRequestWithPathString:@"favorite/check" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}
#pragma mark 收藏-店铺-删除-根据收藏ID
+ (AFHTTPRequestOperation *)requestFavoriteDeleteWithFavoriteId:(NSString *)favoriteId
                                                        success:(LHHTTPRequestSuccessBlock)success
                                                        failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"favoriteId": favoriteId ? favoriteId : @""};
    return [LHHTTPClient sendPostRequestWithPathString:@"favorite/del" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark 收藏-店铺-删除-根据店铺ID
+ (AFHTTPRequestOperation *)requestFavoriteDeleteWithShopid:(NSString *)shopid
                                                    success:(LHHTTPRequestSuccessBlock)success
                                                    failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": shopid ? shopid : @""};
    return [LHHTTPClient sendPostRequestWithPathString:@"favorite/delByShop" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark 退出登录
+ (AFHTTPRequestOperation *)requestExitWithSuccess:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"account/exit" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:success failure:failure];
}


#pragma mark - 活动
#pragma mark 获取参与活动的店铺列表
+ (AFHTTPRequestOperation *)requestGetActivityShopsWithActivityid:(NSString *)activityid
                                                    baseProductId:(NSString *)baseProductId
                                                              lng:(CGFloat)lng
                                                              lat:(CGFloat)lat
                                                            range:(CGFloat)range
                                                             sort:(NSInteger)sort
                                                             page:(NSInteger)page
                                                             rows:(NSInteger)rows
                                                          success:(LHHTTPRequestSuccessBlock)success
                                                          failure:(LHHTTPRequestFailureBlock)failure {
    //    // YJX_TODO 一期
    //    NSDictionary *params = @{@"activityid": activityid,
    //                             /*@"baseProductId": baseProductId,*/
    //                             @"lng": @(lng),
    //                             @"lat": @(lat),
    //                             @"range": @(range),
    //                             @"sort": @(sort),
    //                             @"page": @(page),
    //                             @"rows": @(rows)};
    //    return [LHHTTPClient sendPostRequestWithPathString:@"activity/getShopMsgByAllAct" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
    //        LHActivityShopList *shopList = [LHActivityShopList objectWithKeyValues:response];
    //        if (success) {
    //            success(operation, shopList);
    //        }
    //    } failure:failure];
    
    // YJX_TODO 二期
    NSDictionary *params = @{@"activityId": activityid,
                             /*@"baseProductId": baseProductId,*/
                             @"lng": @(lng),
                             @"lat": @(lat),
                             @"range": @(range),
                             @"sort": @(sort),
                             @"page": @(page),
                             @"rows": @(rows)};
    return [LHHTTPClient sendPostRequestWithPathString:@"activity/getActShopList" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHActivityShopList *shopList = [LHActivityShopList objectWithKeyValues:response];
        if (success) {
            success(operation, shopList);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getActivityCenterWithCurrentPage:(NSInteger)currentPage
                                                    pageSize:(NSInteger)pageSize
                                                     success:(LHHTTPRequestSuccessBlock)success
                                                     failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"currentPage": @(currentPage),
                             @"pageSize": @(pageSize)};
    return [LHHTTPClient sendPostRequestWithPathString:@"activity/getActivityAreasList" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHActivityCenterList *list = [LHActivityCenterList objectWithKeyValues:response];
        if (success) {
            success(operation, list);
        }
    } failure:failure];
}

#pragma mark 分享得爱豆
+ (AFHTTPRequestOperation *)requestGetLovebeanWhenSharedWithTaskid:(NSInteger)taskid
                                                           success:(LHHTTPRequestSuccessBlock)success
                                                           failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"taskId": @(taskid),
                             @"state": @(YES),
                             @"platform": @(2)};
    return [LHHTTPClient sendPostRequestWithPathString:@"loveBeans/shareClintIncreaseLoveBeans" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

// 待整理
+ (AFHTTPRequestOperation *)queryShopCommentsWithShopId:(NSUInteger)shopId
                                                   page:(NSUInteger)page
                                                   rows:(NSUInteger)rows
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": @(shopId),
                             @"page": @(page),
                             @"rows": @(rows)};
    return [LHHTTPClient sendPostRequestWithPathString:@"comments/queryShopComments" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHCommentCollection *commentCollection = [LHCommentCollection objectWithKeyValues:response];
        
        ////        @property (nonatomic, assign) NSInteger accountId;
        ////        @property (nonatomic, assign) NSInteger commentId;
        ////        @property (nonatomic, assign) NSInteger level;
        ////        @property (nonatomic, strong) NSString *nickName;
        ////        @property (nonatomic, strong) NSString *avatar;
        ////        @property (nonatomic, strong) NSString *content;
        ////        @property (nonatomic, strong) NSString *publishTime;
        ////        @property (nonatomic, assign) LHCommentReplyStatus shopReplyStatus;
        ////        @property (nonatomic, strong) NSString *shopReplyTime;
        ////        @property (nonatomic, strong) NSString *shopReplyContent;
        //        LHComment *c1 = [LHComment new];
        //        c1.accountId = 1;
        //        c1.commentId = 1;
        //        c1.level = 1;
        //        c1.nickName = @"骆驼";
        //        c1.avatar = @"http://img-test.appvworks.com/7b3a08c8ace146eeafaf33e64f4f41a1";
        //        c1.content = @"非常好的非常好的非常好的非常好的非常好的非常好的非常好的非常好的非常好的非常好的";
        //        c1.publishTime = @"2015-11-22";
        //        c1.shopReplyStatus = LHCommentReplyStatusNormal;
        //        c1.shopReplyContent = @"谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾谢谢惠顾";
        //        c1.shopReplyTime = @"2015-11-23";
        //
        //        LHComment *c2 = [LHComment new];
        //        c2.accountId = 2;
        //        c2.commentId = 2;
        //        c2.level = 4;
        //        c2.nickName = @"骆驼";
        //        c2.avatar = @"http://img-test.appvworks.com/7b3a08c8ace146eeafaf33e64f4f41a1";
        //        c2.content = @"非常好的";
        //        c2.publishTime = @"2015-11-22";
        //        c2.shopReplyStatus = LHCommentReplyStatusNormal;
        //        c2.shopReplyContent = @"谢谢惠顾";
        //        c2.shopReplyTime = @"2015-11-23";
        //
        //        commentCollection.totalPages = 11;
        //        commentCollection.totalRows = 110;
        //        commentCollection.currentPage = 1;
        //        commentCollection.comments = @[c1, c2];
        
        if (success) {
            success(operation, commentCollection);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)postPushCodeWithCode:(NSString *)code
                                         success:(LHHTTPRequestSuccessBlock)success
                                         failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"pushCode": code};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/setPushCode" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)signinWithPhone:(NSString *)phone
                                       code:(NSString *)code
                                    success:(LHHTTPRequestSuccessBlock)success
                                    failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"mobile": phone,
                             @"code": code,
                             @"device": @2};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/register" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)loginWithPhone:(NSString *)phone
                                      code:(NSString *)code
                                    device:(NSString *)device
                                   success:(LHHTTPRequestSuccessBlock)success
                                   failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"mobile": phone,
                             @"code": code,
                             @"device": @(2)};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/login" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHUser *user = [LHUser objectWithKeyValues:response];
        LogDebug(@"%@",user.token);
        if (0 != user.token.length) {
            if (success) {
                success(operation, user);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark general
+ (AFHTTPRequestOperation *)getcodeWithPhone:(NSString *)phone
                                     success:(LHHTTPRequestSuccessBlock)success
                                     failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"mobile": phone};
    return [LHHTTPClient sendPostRequestWithPathString:@"general/getCode" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSString class]] && [(NSString *)response length] != 0) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark account
+ (AFHTTPRequestOperation *)validateMobileWithCode:(NSString *)code
                                             phone:(NSString *)phone
                                           success:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"mobile": phone,
                             @"code"  : code};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/validateMobile" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)modifyMobileWithPhonenumber:(NSString *)phonenumber
                                                   code:(NSString *)code
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"mobile": phonenumber,
                             @"code"  : code};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/modifyMobile" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark 收藏
+ (AFHTTPRequestOperation *)getFavoritesWithLatitude:(double)latitude longitude:(double)longitude success:(LHHTTPRequestSuccessBlock)success failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"myLatitude": @(latitude),
                             @"myLongitude": @(longitude)};
    return [LHHTTPClient sendPostRequestWithPathString:@"favorite/getall" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *favorites = [LHFavorite objectArrayWithKeyValuesArray:response];
            if (success) {
                success(operation, favorites);
            }
        }else if ([response isKindOfClass:[NSNull class]]) {
            if (success) {
                success(operation, nil);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)requestFavoriteShopWithUid:(NSInteger)uid
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": @(uid)};
    return [LHHTTPClient sendPostRequestWithPathString:@"favorite/add" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark wallet
+ (AFHTTPRequestOperation *)setPayword:(NSString *)password
                               success:(LHHTTPRequestSuccessBlock)success
                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"password":MD5Bit32Encrypt(password)};
    return [LHHTTPClient sendPostRequestWithPathString:@"wallet/modWalletPassword" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getBalanceFlowsWithPage:(NSUInteger)page
                                               size:(NSUInteger)size
                                            success:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"currentPage": @(page),
                             @"pageSize": @(size)};
    return [LHHTTPClient sendPostRequestWithPathString:@"wallet/getPageWalletFlow" tokened:YES params:params paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        LHBalanceFlowCollection *collection = [LHBalanceFlowCollection objectWithKeyValues:response];
        if (success) {
            success(operation, collection);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getBalanceWithSuccess:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"wallet/getWallet" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHBalance *balance = [LHBalance objectWithKeyValues:response];
        if (success) {
            success(operation, balance);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


+ (AFHTTPRequestOperation *)getMessagesWithType:(NSInteger)type
                                           page:(NSUInteger)page
                                           rows:(NSUInteger)rows
                                        success:(LHHTTPRequestSuccessBlock)success
                                        failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"messageType": @(type),
                             @"page": @(page),
                             @"rows": @(rows)};
    return [LHHTTPClient sendPostRequestWithPathString:@"general/getPushMessage" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHMessageCollection *collection = [LHMessageCollection objectWithKeyValues:response];
        if (success) {
            success(operation, collection);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

//+ (AFHTTPRequestOperation *)getActivitiesWithSuccess:(LHHTTPRequestSuccessBlock)success
//                                             failure:(LHHTTPRequestFailureBlock)failure
//                                          retryTimes:(NSUInteger)retryTimes {
//    return [LHHTTPClient sendBaseRequestWithPathString:@"activity/getAllActivity" methodType:JXHTTPMethodTypeGet paramType:JXHTTPParamTypeDefault params:nil needToken:NO checkNetwork:NO retryTimes:retryTimes success:^(AFHTTPRequestOperation *operation, id response) {
//        NSArray *activities = [LHActivity objectArrayWithKeyValuesArray:response];
//        if(success) {
//            success(operation, activities);
//        }
//    } failure:failure];
//}

+ (AFHTTPRequestOperation *)getActivitiesWithSuccess:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure
                                          retryTimes:(NSUInteger)retryTimes {
    NSDictionary *params = @{@"terminalTypeEnum": @"IOS"};
    return [LHHTTPClient sendBaseRequestWithPathString:@"advertisement/getAdvertisementList" methodType:JXHTTPMethodTypePost paramType:JXHTTPParamTypeDefault params:params needToken:NO checkNetwork:NO retryTimes:retryTimes success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *activities = [LHActivity objectArrayWithKeyValuesArray:response];
        if(success) {
            success(operation, activities);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getUserinfoWithSuccess:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure
                                        retryTimes:(NSUInteger)retryTimes {
    
    //    return [LHHTTPClient sendPostRequestWithPathString:@"account/getUser" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
    //        LHUserInfo *userinfo = [LHUserInfo objectWithKeyValues:response];
    //        if (success) {
    //            success(operation, userinfo);
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        if (failure) {
    //            failure(operation, error);
    //        }
    //    }];
    
    return [LHHTTPClient sendBaseRequestWithPathString:@"account/getUser" methodType:JXHTTPMethodTypePost paramType:JXHTTPParamTypeDefault params:nil needToken:YES checkNetwork:NO retryTimes:retryTimes success:^(AFHTTPRequestOperation *operation, id response) {
        LHUserInfo *userinfo = [LHUserInfo objectWithKeyValues:response];
        if (success) {
            success(operation, userinfo);
        }
    } failure:failure];
}

+ (NSURLSessionUploadTask *)uploadWithImage:(UIImage *)image
                                    success:(JXHTTPTaskSuccessBlock)success
                                    failure:(JXHTTPTaskFailureBlock)failure
                                   progress:(LHHTTPProgressBlock)progress {
    NSData *data = [UIImage imageObjectToData:image andCompressionQuality:1.0 andMaxSize:512];
    NSArray *files = @[@{kJXHTTPFileArg: @"file", kJXHTTPFileName: @"image.png", kJXHTTPFileData: data}];
    return [LHHTTPClient sendUploadTaskWithPathString:@"account/uploadHeadImg" tokened:YES params:nil files:files success:^(NSURLResponse *urlResponse, id response) {
        if (success) {
            success(urlResponse, response);
        }
    } failure:^(NSURLResponse *urlResponse, NSError *error) {
        if (failure) {
            failure(urlResponse, error);
        }
    } progress:progress];
}

+ (AFHTTPRequestOperation *)modifyNickname:(NSString *)nickname
                                   success:(LHHTTPRequestSuccessBlock)success
                                   failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"nickName": nickname};
    return [LHHTTPClient sendPostRequestWithPathString:@"account/modNickName" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getReceiptsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/getalladdr" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *receipts = [LHReceipt objectArrayWithKeyValuesArray:response];
        if (success) {
            success(operation, receipts);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)delReceiptWithUid:(NSInteger)uid
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId":@(uid)};
    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/del" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if (success) {
            success(operation, response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)updateReceipt:(LHReceipt *)receipt
                                  success:(LHHTTPRequestSuccessBlock)success
                                  failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId": @(receipt.receiptID.integerValue),
                             @"name":receipt.name,
                             @"mobile":receipt.mobile,
                             @"provinceId":@(receipt.provinceId),
                             @"cityId":@(receipt.cityId),
                             @"areaId":@(receipt.areaId),
                             @"address":receipt.address,
                             @"addressExpand":receipt.addressExpand,
                             @"latitude":@(receipt.latitude),
                             @"longitude":@(receipt.longitude)};
    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/modify" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHReceipt *receipt = [LHReceipt objectWithKeyValues:response];
        if (receipt.receiptID.integerValue != 0) {
            if (success) {
                success(operation, receipt);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)addReceipt:(LHReceipt *)receipt
                               success:(LHHTTPRequestSuccessBlock)success
                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"name":receipt.name,
                             @"mobile":receipt.mobile,
                             @"provinceId":@(receipt.provinceId),
                             @"cityId":@(receipt.cityId),
                             @"areaId":@(receipt.areaId),
                             @"address":receipt.address,
                             @"addressExpand":receipt.addressExpand,
                             @"latitude":@(receipt.latitude),
                             @"longitude":@(receipt.longitude)};
    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/add" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHReceipt *receipt = [LHReceipt objectWithKeyValues:response];
        if (receipt.receiptID.integerValue != 0) {
            if (success) {
                success(operation, receipt);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)setDefaultReceiptWithUid:(NSNumber *)uid
                                             success:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId":uid};
    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/setdefault" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if (success) {
            success(operation, response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getLovebeanFlowsWithPage:(NSInteger)page
                                                size:(NSInteger)size
                                             success:(LHHTTPRequestSuccessBlock)success
                                             failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"page":@(page),
                             @"rows":@(size)};
    return [LHHTTPClient sendPostRequestWithPathString:@"loveBeansLogging/showUserLovebeansLogging" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHLovebeanWrapperCollection *lovebeanWrapper = [LHLovebeanWrapperCollection objectWithKeyValues:response];
        if (success) {
            success(operation, lovebeanWrapper);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getLovebeanSignWithSuccess:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"status":@(YES),
                             @"platform":@(2)};
    return [LHHTTPClient sendPostRequestWithPathString:@"loveBeansSignSheet/signGetLoveBeans" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHLovebeanSign *sign = [LHLovebeanSign objectWithKeyValues:response];
        if (success) {
            success(operation, sign);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getMordersWithPage:(NSInteger)page
                                          size:(NSInteger)size
                                       isError:(BOOL)isError
                                       success:(LHHTTPRequestSuccessBlock)success
                                       failure:(LHHTTPRequestFailureBlock)failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!isError) {
            if (success) {
                success(nil, nil);
            }
        }else {
            if (failure) {
                failure(nil, nil);
            }
        }
    });
    
    return [[AFHTTPRequestOperation alloc] init];
}

#pragma mark - 充值/支付
+ (AFHTTPRequestOperation *)rechargeWithMoney:(CGFloat)money
                                          way:(NSInteger)way
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure  {
    NSDictionary *params = @{@"payWay":@(way),
                             @"cash": [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", money]]};
    return [LHHTTPClient sendPostRequestWithPathString:@"pay/wallet" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark - 优惠券
+ (AFHTTPRequestOperation *)requestGetCouponsWithShopids:(NSDictionary *)shopids
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = shopids;
    return [LHHTTPClient sendPostRequestWithPathString:@"counpons/showCouponListByShopId" tokened:YES params:params paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *coupons = [LHCoupon objectArrayWithKeyValuesArray:response];
        if (success) {
            success(operation, coupons);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)requestGetBasicDataForOrderConfirmWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                                  failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"loveBeans/getBasicData" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHBasicData *basicData = [LHBasicData objectWithKeyValues:response];
        if (success) {
            success(operation, basicData);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)requestGetUsableCouponCountWithShopid:(NSInteger)shopid
                                                        goodsList:(NSArray *)goodsList
                                                          success:(LHHTTPRequestSuccessBlock)success
                                                          failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": @(shopid),
                             @"goodsList": goodsList};
    return [LHHTTPClient sendPostRequestWithPathString:@"counpons/queryCurrentUseableCouponCount" tokened:YES params:params paramType:JXHTTPParamTypeJSON success:success failure:failure];
}

+ (AFHTTPRequestOperation *)getMyCouponsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"counpons/queryOneCounponsInformation" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *coupons = [LHCoupon objectArrayWithKeyValuesArray:response];
        if (success) {
            success(operation, coupons);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getSuppliedCouponsWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"counpons/showReceiveCoupons" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *coupons = [LHCoupon objectArrayWithKeyValuesArray:response];
        if (success) {
            success(operation, coupons);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)receiveCounponWithCounponid:(NSString *)couponid
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"counponId":@(couponid.integerValue)};
    return [LHHTTPClient sendPostRequestWithPathString:@"counpons/getCounpons" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark - 店铺/商品
+ (AFHTTPRequestOperation *)getProductsWithShopid:(NSInteger)shopid
                                        addressId:(NSInteger)addressId
                                          success:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@(shopid) forKey:@"shopId"];
    if (!kIsLocalCart) {
        [params setObject:@(addressId) forKey:@"addressId"];
    }
    
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/getProducts" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *array = [LHShopBusiness objectArrayWithKeyValuesArray:response];
            if (success) {
                success(operation, array);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getProductsWithShopid:(NSInteger)shopid
                                       activityId:(NSInteger)activityId
                                        addressId:(NSInteger)addressId
                                          success:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": @(shopid),
                             @"addressId": @(addressId)};
    
    return [LHHTTPClient sendPostRequestWithPathString:@"activity/getShopActivityProducts" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *array = [LHSecondBusiness objectArrayWithKeyValuesArray:response];
            
            // actPriceType 1折扣 2组合
            NSMutableArray *businesses = [NSMutableArray array];
            for (LHSecondBusiness *business in array) {
                LHShopBusiness *business2 = [LHShopBusiness new];
                business2.uid = business.id;
                business2.name = business.name;
                
                NSMutableArray *categories = [NSMutableArray array];
                for (LHSecondActivity *activity in business.activitys) {
                    LHProductCategory *category = [LHProductCategory new];
                    category.uid = activity.activityId;
                    category.name = activity.activityTitle;
                    
                    NSMutableArray *products = [NSMutableArray array];
                    for (LHSecondCategory *c in activity.categories) {
                        for (LHSecondProduct *p in c.products) {
                            LHProduct *product = [LHProduct new];
                            product.uid = p.id;
                            product.name = p.name;
                            product.price = p.price;
                            product.url = p.url;
                            
                            //                            @property (nonatomic, assign) LHSecondActivityType actPriceType;
                            //                            @property (nonatomic, assign) CGFloat actPrice;
                            //                            @property (nonatomic, strong) NSString *activityId;
                            //                            @property (nonatomic, strong) NSString *activityTitle;
                            //                            @property (nonatomic, strong) NSString *actProductImgUrl;
                            
                            product.actPriceType = activity.actPriceType;
                            product.actPrice = activity.actPrice;
                            product.actProductImgUrl = activity.actProductImgUrl;
                            product.activityTitle = activity.activityTitle;
                            product.activityId = activity.activityId;
                            
                            NSMutableArray *specifies = [NSMutableArray array];
                            for (LHSecondSpecify *s in p.specifies) {
                                LHSpecify *specify = [LHSpecify new];
                                specify.uid = s.id;
                                specify.name = s.name;
                                specify.price = s.price;
                                specify.url = s.url;
                                specify.pieces = s.pieces;
                                
                                specify.actPriceType = activity.actPriceType;
                                specify.actPrice = activity.actPrice;
                                specify.actProductImgUrl = activity.actProductImgUrl;
                                specify.activityTitle = activity.activityTitle;
                                specify.activityId = activity.activityId;
                                
                                if (product.actPriceType == LHSecondActivityTypeDiscount) {
                                    specify.originalPrice = s.price;
                                    specify.price = JXStringFromFloat(s.price.floatValue * activity.actPrice * 0.1);
                                }else if (product.actPriceType == LHSecondActivityTypeCombination) {
                                    specify.originalPrice = s.price;
                                    specify.price = JXStringFromFloat(activity.actPrice);
                                }else {
                                    specify.price = s.price;
                                }
                                
                                [specifies addObject:specify];
                            }
                            
                            if (specifies.count != 0) {
                                product.specifies = specifies;
                            }
                            
                            
                            //                            product.price = [NSString stringWithFormat:@"%.2f", [[(LHSpecify *)product.specifies[0] price] floatValue]];
                            //
                            //                            NSMutableArray *prices = [NSMutableArray array];
                            //                            for (LHSpecify *specify in product.specifies) {
                            //                                if (!JudgeContainerIsEmptyOrNull(product.price)) {
                            //                                    [prices addObject:specify.price];
                            //                                }
                            //                            }
                            //                            if (prices.count != 0) {
                            //                                NSArray *results = [prices sortedArrayUsingSelector:@selector(compare:)];
                            //                                product.price = [NSString stringWithFormat:@"%.2f~%.2f", [results[0] floatValue], [results[results.count - 1] floatValue]];
                            //                            }
                            
                            [products addObject:product];
                        }
                    }
                    
                    if (products.count != 0) {
                        category.products = products;
                    }
                    [categories addObject:category];
                }
                
                if (categories.count != 0) {
                    business2.categories = categories;
                }
                [businesses addObject:business2];
            }
            
            
            if (success) {
                success(operation, businesses);
            }
        }else {
            //            if (failure) {
            //                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            //            }
            
            if (success) {
                success(operation, nil);
            }
        }
    } failure:failure];
}

#pragma mark - 检测失效商品
+ (AFHTTPRequestOperation *)getInvalidProductsWithParams:(NSArray *)params
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/verifyShopCartProduct" tokened:NO params:params paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        if (success) {
            success(operation, [LHVerifyShopCartResult objectWithKeyValues:response]);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)addShopCartProduct:(NSDictionary *)param
                                       success:(LHHTTPRequestSuccessBlock)success
                                       failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/addShopCartProduct" tokened:YES params:param paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)batchClearProduct:(NSDictionary *)param
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/batchClearProduct" tokened:YES params:param paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)getUserShopCartRecordWithAddressId:(NSInteger)addressId
                                                       success:(LHHTTPRequestSuccessBlock)success
                                                       failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId": @(addressId)};
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/getUserShopCartRecord" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if (success) {
            success(operation, [LHCartInfo objectWithKeyValues:response]);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)updateProdcutBuyCount:(NSInteger)addressId
                                       specifieId:(NSInteger)specifieId
                                         buyCount:(NSInteger)buyCount
                                       activityId:(NSInteger)activityId
                                          success:(LHHTTPRequestSuccessBlock)success
                                          failure:(LHHTTPRequestFailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (addressId != 0) {
        [params setObject:@(addressId) forKey:@"addressId"];
    }
    if (addressId != 0) {
        [params setObject:@(specifieId) forKey:@"specifieId"];
    }
    if (addressId != 0) {
        [params setObject:@(buyCount) forKey:@"buyCount"];
    }
    if (addressId != 0) {
        [params setObject:@(activityId) forKey:@"activityId"];
    }
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/updateProdcutBuyCount" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 收货
+ (AFHTTPRequestOperation *)requestReceiveWithOrderid:(NSString *)orderid
                                              success:(LHHTTPRequestSuccessBlock)success
                                              failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/confirmreceipt" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 确认收衣
+ (AFHTTPRequestOperation *)requestConfirmCollectedWithOrderid:(NSString *)orderid
                                                       success:(LHHTTPRequestSuccessBlock)success
                                                       failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/colletclothesbycustomer" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 获取默认的收货地址
+ (AFHTTPRequestOperation *)requestGetDefaultReceiptWithSuccess:(LHHTTPRequestSuccessBlock)success
                                                        failure:(LHHTTPRequestFailureBlock)failure {
    //    return [LHHTTPClient sendPostRequestWithPathString:@"receiptAddr/getDefaultAddr" tokened:YES params:nil paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
    //        LHReceipt *receipt = [LHReceipt objectWithKeyValues:response];
    //        if (success) {
    //            success(operation, receipt);
    //        }
    //    } failure:failure];
    
    return [LHHTTPClient sendBaseRequestWithPathString:@"receiptAddr/getDefaultAddr" methodType:JXHTTPMethodTypePost paramType:JXHTTPParamTypeDefault params:nil needToken:YES checkNetwork:NO retryTimes:3 success:^(AFHTTPRequestOperation *operation, id response) {
        LHReceipt *receipt = [LHReceipt objectWithKeyValues:response];
        if (success) {
            success(operation, receipt);
        }
    } failure:failure];
}

#pragma mark 根据ID获取店铺详情
+ (AFHTTPRequestOperation *)getShopWithShopid:(NSInteger)shopid
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopId": @(shopid)};
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/getShop" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHShop *shop = [LHShop objectWithKeyValues:response];
        if (0 == shop.shopId.length) {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }else {
            if (success) {
                success(operation, shop);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getShopCartBuyCounts:(NSInteger)addressId
                                         success:(LHHTTPRequestSuccessBlock)success
                                         failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId": @(addressId)};
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/getShopCartBuyCounts" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if (![response isKindOfClass:[NSNumber class]]) {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }else {
            if (success) {
                success(operation, response);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)insertUserReportWithShopid:(NSInteger)shopid
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    NSString *myMobile = gLH.user.info.phoneNumber;
    myMobile = myMobile.length == 0 ? @"" : myMobile;
    
    NSString *myIP = [JXDevice ip];
    myIP = myIP.length == 0 ? @"" : myIP;
    
    //    NSString *myCode = [JXDevice imsi];
    //    myCode = myCode.length == 0 ? @"" : myCode;
    
    NSDictionary *params = @{@"mobile": myMobile,
                             @"source": @"iOS",
                             @"longitude": @(gLH.receipt.longitude),
                             @"latitude": @(gLH.receipt.latitude),
                             @"shopid": @(shopid),
                             @"loginip": myIP,
                             @"onlycode": @""};
    return [LHHTTPClient sendPostRequestWithPathString:@"userreport/insertUserReport" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

+ (AFHTTPRequestOperation *)emptyFailureProduct:(NSInteger)addressId
                                        success:(LHHTTPRequestSuccessBlock)success
                                        failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"addressId": @(addressId)};
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/emptyFailureProduct" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

+ (AFHTTPRequestOperation *)verifyShopCartProductInfos:(NSArray *)params
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"shopCart/verifyShopCartProductInfos" tokened:NO params:params paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        if (success) {
            success(operation, [LHCartInfo objectWithKeyValues:response]);
        }
    } failure:failure];
}

#pragma mark 查询店铺列表
+ (AFHTTPRequestOperation *)queryShopsWithLatitude:(CGFloat)latitude
                                         longitude:(CGFloat)longitude
                                              type:(NSUInteger)type
                                          distance:(CGFloat)distance
                                              sort:(NSUInteger)sort
                                             index:(NSInteger)index
                                              size:(NSInteger)size
                                           success:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"lat": @(latitude),
                             @"lng": @(longitude),
                             @"nearbyDistance": @(distance),
                             @"sort": @(sort),
                             @"scope": @(type),
                             @"currentPage": @(index),
                             @"pageSize": @(size)};
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/getShopsByScope" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHShopList *shopList = [LHShopList objectWithKeyValues:response];
        if (success) {
            success(operation, shopList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)queryShopsWithLatitude:(CGFloat)latitude
                                         longitude:(CGFloat)longitude
                                              type:(NSUInteger)type
                                          distance:(CGFloat)distance
                                              sort:(NSUInteger)sort
                                             index:(NSInteger)index
                                              size:(NSInteger)size
                                             shops:(NSArray *)shops
                                           success:(LHHTTPRequestSuccessBlock)success
                                           failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params1 = @{@"lat": @(latitude),
                              @"lng": @(longitude),
                              @"nearbyDistance": @(distance),
                              @"sort": @(sort),
                              @"currentPage": @(index),
                              @"pageSize": @(size)};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:params1];
    if (shops.count != 0) {
        [params setObject:shops forKey:@"shopIds"];
    }
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/getShopsByParams" tokened:NO params:params paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        LHShopList *shopList = [LHShopList objectWithKeyValues:response];
        if (success) {
            success(operation, shopList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)searchShopsWithName:(NSString *)name
                                        success:(LHHTTPRequestSuccessBlock)success
                                        failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"shopName": name};
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/getShopByName" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *shops = [LHShop objectArrayWithKeyValuesArray:response];
        if (success) {
            success(operation, shops);
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)searchShopsWithLatitude:(CGFloat)latitude
                                          longitude:(CGFloat)longitude
                                               name:(NSString *)name
                                           distance:(CGFloat)distance
                                               sort:(NSUInteger)sort
                                              index:(NSInteger)index
                                               size:(NSInteger)size
                                            success:(LHHTTPRequestSuccessBlock)success
                                            failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"lat": @(latitude),
                             @"lng": @(longitude),
                             @"nearbyDistance": @(distance),
                             @"sort": @(sort),
                             @"name": name,
                             @"currentPage": @(index),
                             @"pageSize": @(size)};
    
    return [LHHTTPClient sendPostRequestWithPathString:@"merchant/searchShopsByName" tokened:NO params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHShopList *shopList = [LHShopList objectWithKeyValues:response];
        if (success) {
            success(operation, shopList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


#pragma mark 查询订单详情
+ (AFHTTPRequestOperation *)requestGetOrderDetailWithOrderid:(NSString *)orderid
                                                     success:(LHHTTPRequestSuccessBlock)success
                                                     failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"orderId":orderid};
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/getorderdetail" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHOrder *order = [LHOrder objectWithKeyValues:response];
        if (0 != order.uid.length) {
            if (success) {
                success(operation, order);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark 取消订单(已支付)
+ (AFHTTPRequestOperation *)requestCancelPayedOrderWithOrderid:(NSString *)orderId
                                                       success:(LHHTTPRequestSuccessBlock)success
                                                       failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/cancelorderhavepay" tokened:YES params:@{@"orderId":orderId} paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 取消订单(收衣中)
+ (AFHTTPRequestOperation *)requestCancelCollectingOrderWithOrderid:(NSString *)orderId
                                                            success:(LHHTTPRequestSuccessBlock)success
                                                            failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/cancelordercollectclothes" tokened:YES params:@{@"orderId":orderId} paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 获取用户订单
+ (AFHTTPRequestOperation *)requestGetUserOrdersWithType:(LHOrderRequestType)type
                                                    page:(NSInteger)page
                                                    size:(NSInteger)size
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure {
    if (type >= LHOrderRequestTypeCollect) {
        type += 1;
    }
    
    NSDictionary *params = @{@"status":@(type),
                             @"currentPage":@(page),
                             @"pageSize":@(size)};
    
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/getuserorder" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        LHOrderCollection *orderCollection = [LHOrderCollection objectWithKeyValues:response];
        if (success) {
            success(operation, orderCollection);
        }
    } failure:failure];
}

#pragma mark 取消订单(未支付)
+ (AFHTTPRequestOperation *)requestCancelNopayedOrderWithOrderid:(NSString *)orderId
                                                         success:(LHHTTPRequestSuccessBlock)success
                                                         failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"orderId": orderId};
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/cancelordernopay" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        //        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
        if (success) {
            success(operation, response);
        }
        //        }else {
        //            if (failure) {
        //                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
        //            }
        //        }
    } failure:failure];;
}

#pragma mark - 订单
+ (AFHTTPRequestOperation *)requestSubmitOrderWithModel:(LHOrderSubmit *)model
                                                success:(LHHTTPRequestSuccessBlock)success
                                                failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/placeorder" tokened:YES params:[model keyValues] paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
        LHOrderPay *orderPay = [LHOrderPay objectWithKeyValues:response];
        if (orderPay.payId.length != 0) {
            if (success) {
                success(operation, orderPay);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)requestNewPayidWithOrderid:(NSString *)orderid
                                               success:(LHHTTPRequestSuccessBlock)success
                                               failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"orderId": orderid};
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/topaysingleorder" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSString class]] && [(NSString *)response length] != 0) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

#pragma mark 点评店铺
+ (AFHTTPRequestOperation *)requestCommentShopWithContent:(NSString *)content
                                                   shopId:(NSString *)shopId
                                                  orderId:(NSString *)orderId
                                            descriptLevel:(NSInteger)descriptLevel
                                             serviceLevel:(NSInteger)serviceLevel
                                               speedLevel:(NSInteger)speedLevel
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"content": content,
                             @"shopId": shopId,
                             @"orderId": orderId,
                             @"serviceDsc": @(descriptLevel),
                             @"attitude": @(serviceLevel),
                             @"deliverySpeed": @(speedLevel)};
    
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/subbitcomment" tokened:YES params:params paramType:JXHTTPParamTypeJSON success:success failure:failure];
}

#pragma mark 删除订单
+ (AFHTTPRequestOperation *)requestDeleteOrderWithOrderid:(NSString *)orderId
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendPostRequestWithPathString:@"userorder/delete" tokened:YES params:@{@"orderId":orderId} paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark 验证支付密码
+ (AFHTTPRequestOperation *)requestVerifyPayword:(NSString *)payword
                                         success:(LHHTTPRequestSuccessBlock)success
                                         failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"password":MD5Bit32Encrypt(payword)};
    return [LHHTTPClient sendPostRequestWithPathString:@"wallet/checkWalletPassword" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSNumber class]] && [response boolValue]) {
            if (success) {
                success(operation, response);
            }
        }else {
            if (failure) {
                failure(operation, [NSError exErrorWithCode:JXErrorCodeServerException description:kStringServerException]);
            }
        }
    } failure:failure];
}

+ (AFHTTPRequestOperation *)requestPayWithWay:(LHOnlinePayWay)way
                                        payId:(NSString *)payId
                                         cash:(CGFloat)cash
                                      success:(LHHTTPRequestSuccessBlock)success
                                      failure:(LHHTTPRequestFailureBlock)failure {
    NSDictionary *params = @{@"payWay":@(way),
                             @"payId":payId,
                             @"cash":[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", cash]]};
    return [LHHTTPClient sendPostRequestWithPathString:@"pay/order" tokened:YES params:params paramType:JXHTTPParamTypeDefault success:success failure:failure];
}

#pragma mark - HTTP methods
+ (AFHTTPRequestOperation *)sendGetRequestWithPathString:(NSString *)pathString
                                                 tokened:(BOOL)tokened
                                                  params:(id)params
                                                 success:(LHHTTPRequestSuccessBlock)success
                                                 failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendBaseRequestWithPathString:pathString methodType:JXHTTPMethodTypeGet paramType:JXHTTPParamTypeDefault params:params needToken:tokened checkNetwork:YES retryTimes:0 success:success failure:failure];
}

+ (AFHTTPRequestOperation *)sendPostRequestWithPathString:(NSString *)pathString
                                                  tokened:(BOOL)tokened
                                                   params:(id)params
                                                paramType:(JXHTTPParamType)paramType
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure {
    return [LHHTTPClient sendBaseRequestWithPathString:pathString methodType:JXHTTPMethodTypePost paramType:paramType params:params needToken:tokened checkNetwork:YES retryTimes:0 success:success failure:failure];
}

+ (NSURLSessionUploadTask *)sendUploadTaskWithPathString:(NSString *)pathString
                                                 tokened:(BOOL)tokened
                                                  params:(id)params
                                                   files:(NSArray *)files
                                                 success:(LHHTTPTaskSuccessBlock)success
                                                 failure:(LHHTTPTaskFailureBlock)failure
                                                progress:(LHHTTPProgressBlock)progress {
    [JXHTTPClient sendUploadTaskWithBaseString:kHTTPBase
                                    pathString:pathString
                                     paramType:JXHTTPParamTypeDefault
                                        params:params
                                         files:files
                                       headers:(tokened ? [[self class] getTokenHeader] : nil)
                                       success:^(NSURLResponse *urlResponse, id response) {
                                           LHResponseBase *baseResponse = [LHResponseBase objectWithKeyValues:response];
                                           if (kHTTPSuccess != baseResponse.code) {
                                               if (failure) {
                                                   failure(urlResponse, [NSError exErrorWithCode:baseResponse.code description:baseResponse.message]);
                                               }
                                           }else {
                                               if (success) {
                                                   success(urlResponse, [response objectForKey:kHTTPData]);
                                               }
                                           }
                                       }
                                       failure:failure
                                      progress:progress];
    return nil;
}


+ (AFHTTPRequestOperation *)sendBaseRequestWithPathString:(NSString *)pathString
                                               methodType:(JXHTTPMethodType)methodType
                                                paramType:(JXHTTPParamType)paramType
                                                   params:(id)params
                                                needToken:(BOOL)needToken
                                             checkNetwork:(BOOL)checkNetwork
                                               retryTimes:(NSUInteger)retryTimes
                                                  success:(LHHTTPRequestSuccessBlock)success
                                                  failure:(LHHTTPRequestFailureBlock)failure {
    if (checkNetwork) {
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            if (failure) {
                failure(nil, [NSError exErrorWithCode:JXErrorCodeNetworkException description:kStringNetworkException]);
            }
            return nil;
        }
    }
    
    //NSDictionary *headers = [self getCommonHeaderWithToken:needToken params:params];
    
    return [JXHTTPClient sendBaseRequestWithBaseString:kHTTPBase
                                            pathString:pathString
                                            methodType:methodType
                                             paramType:paramType
                                                params:params
                                                 files:nil
                                               headers:(needToken ? [[self class] getTokenHeader] : nil)
                                               success:^(AFHTTPRequestOperation *operation, id response) {
                                                   JXLogDebug(@"response = %@", response);
                                                   
                                                   LHResponseBase *base = [LHResponseBase objectWithKeyValues:response];
                                                   if (kHTTPSuccess != base.code) {
                                                       NSString *message;
                                                       if (401 == base.code) {
                                                           message = kStringTokenInvalid;
                                                       }else {
                                                           message = base.message;
                                                       }
                                                       if (failure) {
                                                           failure(operation, [NSError exErrorWithCode:base.code description:message]);
                                                       }
                                                   }else {
                                                       if (success) {
                                                           success(operation, [response objectForKey:kHTTPData]);
                                                       }
                                                   }
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   if (retryTimes > 0) {
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                           [LHHTTPClient sendBaseRequestWithPathString:pathString methodType:methodType paramType:paramType params:params needToken:needToken checkNetwork:checkNetwork retryTimes:(retryTimes - 1) success:success failure:failure];
                                                       });
                                                   }else {
                                                       NSError *myError = error;
                                                       if (3840 == error.code ||
                                                           -1011 == error.code) {
                                                           myError = [NSError exErrorWithCode:JXErrorCodeServerException];
                                                       }
                                                       if (failure) {
                                                           failure(operation, myError);
                                                       }
                                                   }
                                               } progress:NULL];
}

+ (NSDictionary *)getTokenHeader {
    NSString *token = gLH.user.token;
    return @{@"token": (0 != token.length) ? token : @""};
}

+ (NSDictionary *)getCommonHeaderWithToken:(BOOL)needToken params:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (needToken) {
        NSString *token = gLH.user.token;
        [dict setObject:((0 != token) ? token : @"") forKey:@"token"];
    }
    
    if (params) {
        NSArray *keys = [params.allKeys sortedArrayUsingSelector:@selector(compare:)];
        NSMutableString *sign = [NSMutableString stringWithString:kAppKey];
        for (NSString *key in keys) {
            [sign appendFormat:@"%@%@", key, params[key]];
        }
        [sign appendString:kAppSecret];
        NSString *utf8Sign = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)sign, NULL, NULL,  kCFStringEncodingUTF8 ));
        NSString *value1 = [utf8Sign exMD5Bit32];
        NSString *value2 = [value1 uppercaseString];
        [dict setObject:(value2 ? value2 : @"") forKey:@"signature"];
    }
    
    return ((0 != dict.count) ? dict : nil);
}
@end







