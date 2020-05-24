//
//  LHBalanceFlow.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, LHBalanceFlowState){
//    LHBalanceFlowStateNone,
//    LHBalanceFlowStateRecharging,           // 充值中
//    LHBalanceFlowStateRechargeSuccess,      // 充值成功
//    LHBalanceFlowStateRechargeFailure,      // 充值失败
//    LHBalanceFlowStatePaying,               // 支付中
//    LHBalanceFlowStatePaySuccess,           // 支付成功
//    LHBalanceFlowStatePayFailure,           // 支付失败
//    LHBalanceFlowStateRefundWaiting,        // 等待退款
//    LHBalanceFlowStateRefunding,            // 退款中
//    LHBalanceFlowStateRefundSuccess,        // 退款成功
//    LHBalanceFlowStateRefundFailure,        // 退款失败
//    LHBalanceFlowStateTransferWaiting,      // 等待划账
//    LHBalanceFlowStateTransfering,          // 划账中
//    LHBalanceFlowStateTransferSuccess,      // 划账成功
//    LHBalanceFlowStateTransferFailure,      // 划账失败
//    LHBalanceFlowStateCollectSuccess,       // 收款成功
//    LHBalanceFlowStateAll
//};
//
//typedef NS_ENUM(NSInteger, LHBalanceFlowType){
//    LHBalanceFlowTypeNone,
//    LHBalanceFlowTypePay,       // 支付
//    LHBalanceFlowTypeRecharge,  // 充值
//    LHBalanceFlowTypeRefund,    // 退款
//    LHBalanceFlowTypeAll
//};

@interface LHBalanceFlow : NSObject
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) CGFloat cash;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *dealDate;
//@property (nonatomic, strong) NSDate *dealDate;

//+ (NSArray *)states;
//+ (NSArray *)types;
//+ (NSString *)stringForState:(LHBalanceFlowState)state;
//+ (NSString *)stringForType:(LHBalanceFlowType)type;
@end
