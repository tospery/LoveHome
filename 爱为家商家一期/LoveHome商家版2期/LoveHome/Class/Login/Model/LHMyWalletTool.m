//
//  LHMyBalanceTool.m
//  LoveHome-User-Clothes
//
//  Created by MRH-MAC on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHMyWalletTool.h"
#import "PayOnlineMentModel.h"


@implementation LHMyWalletTool

+ (NSMutableArray *)getOnlinePayMent
{
    PayOnlineMentModel *airPay  = [[PayOnlineMentModel alloc] init];
    airPay.iconUrl              = @"ariPay";
    airPay.payMentName          = @"支付宝客服端支付";
    airPay.payMentDescription   = @"推荐安装支付宝客服端的用户使用";
    airPay.isSelect             = YES;
    airPay.payType = airPlayType;
    
    PayOnlineMentModel *weiChat = [[PayOnlineMentModel alloc] init];
    weiChat.iconUrl             = @"weiChat";
    weiChat.payMentName         = @"微信支付";
    weiChat.payMentDescription  = @"推荐安装微信5.0及以上版本的使用";
    weiChat.payType = weicatType;
    
    PayOnlineMentModel *upacash = [[PayOnlineMentModel alloc] init];
    upacash.iconUrl             = @"Upacash";
    upacash.payMentName         = @"银联支付";
    upacash.payMentDescription  = @"支持储蓄卡信用卡,无需开通网银";
    upacash.payType = UpacashType;
    
//    PayOnlineMentModel *tenPay  = [[PayOnlineMentModel alloc] init];
//    tenPay.iconUrl              = @"tenPay";
//    tenPay.payMentName          = @"财付通支付";
//    tenPay.payMentDescription   = @"支持银行卡和财付通账号支付";
//    tenPay.payType = tenPayType;
//    PayOnlineMentModel *member   = [[PayOnlineMentModel alloc] init];
//    member.iconUrl               = @"VIPcard";
//    member.payMentName           = @"店铺会员卡支付";
//    member.payMentDescription    = @"支付金额按店铺会员价为准";
    
    NSMutableArray *arry = [[NSMutableArray alloc] initWithObjects:airPay,nil];
    return arry;

}


//
//+ (void)sendInchargeMoney:(NSString *)money andPayTpey:(NSInteger)type andsuccessBlock:(JXHTTPRequestSuccessBlock)success andFail:(JXHTTPRequestFailureBlock)fail
//{
//    
//    NSNumber *cash = @([money floatValue]);
//    NSDictionary *param = @{@"payWay":@(type),@"cash":cash};
//    NSString *token = (0 != gLH.user.token.length) ? gLH.user.token : @"";
//
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
//    [manager POST:@"http://183.220.1.29:40800/appvworks.portal/pay/wallet" parameters:param success:success failure:fail];
//
//
//}
//
//
//+ (void)getUserWalletBlanceList:(BlanceListDetailBlock)success andFail:(JXHTTPRequestFailureBlock)fail
//{
//    [LHHTTPClient sendPostRequestWithPathString:@"" tokened:YES params:nil paramType:JXHTTPParamTypeJSON success:^(AFHTTPRequestOperation *operation, id response) {
//        if (!JudgeContainerIsEmptyOrNull(response)) {
//            
//        }
//        
//    } failure:fail];
//}
@end
