//
//  LHType.h --- 定义通用类型的头文件
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/16.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifndef LoveHome_User_Clothes_LHType_h
#define LoveHome_User_Clothes_LHType_h

typedef JXHTTPRequestSuccessBlock   LHHTTPRequestSuccessBlock;
typedef JXHTTPRequestFailureBlock   LHHTTPRequestFailureBlock;
typedef JXHTTPTaskSuccessBlock      LHHTTPTaskSuccessBlock;
typedef JXHTTPTaskFailureBlock      LHHTTPTaskFailureBlock;
typedef JXHTTPProgressBlock         LHHTTPProgressBlock;

//typedef NS_ENUM(NSInteger, LHBusinessType){
//    LHBusinessTypeNone,
//    LHBusinessTypeClothes,
//    LHBusinessTypeShoe,
//    LHBusinessTypeLeather,
//    LHBusinessTypeLuxury,
//    LHBusinessTypeOther
//};

//typedef NS_ENUM(NSInteger, LHShopListFrom){
//    LHShopListFromNone,
//    LHShopListFromHomeClothes,
//    LHShopListFromHomeShoe,
//    LHShopListFromHomeLeather,
//    LHShopListFromHomeLuxury,
//    LHShopListFromHomeOther,
//    LHShopListFromActivity,
//    LHShopListFromFavorite
//};

typedef NS_ENUM(NSInteger, LHCartProductEditType){
    LHCartProductEditTypeSelect,
    LHCartProductEditTypeDeselect,
    LHCartProductEditTypeDelete,
    LHCartProductEditTypePlus,
    LHCartProductEditTypeMinus
};

typedef NS_ENUM(NSInteger, LHPayWay){
    LHPayWayByCard = 0,
    LHPayWayOnLine
};

typedef NS_ENUM(NSInteger, LHOnlinePayWay){
    LHOnlinePayWayBalance,
    LHOnlinePayWayAlipay,
    LHOnlinePayWayBkpay,
    LHOnlinePayWayWxpay
};

typedef NS_ENUM(NSInteger, LHOperationSuccessType){
    LHOperationSuccessTypePay,
    LHOperationSuccessTypeReceive,
    LHOperationSuccessTypeSubmit
};

typedef NS_ENUM(NSInteger, LHEntryFrom){
    LHEntryFromNone,
    LHEntryFromHomeClothes,
    LHEntryFromHomeShoe,
    LHEntryFromHomeLeather,
    LHEntryFromHomeLuxury,
    LHEntryFromHomeOther,
    //LHEntryFromCart,
    LHEntryFromFavorite,
    LHEntryFromOrder,
    LHEntryFromCoupon,
    LHEntryFromActivity,            // Presented
    LHEntryFromSearch,              // Presented
    LHEntryFromMap                  // Presented
};

typedef NS_ENUM(NSInteger, LHOrderRequestType){
    LHOrderRequestTypePay = 1,      // 待支付
    LHOrderRequestTypeHandle,       // 待受理
    LHOrderRequestTypeCollect,      // 收衣中
    LHOrderRequestTypeService,      // 服务中
    LHOrderRequestTypeFinish,       // 已完成（有评价或无评价）
    LHOrderRequestTypeCancel        // 已取消
};

typedef NS_ENUM(NSInteger, LHActivityType){
    LHActivityTypeDisplay,          // 仅仅用于展示的活动
    LHActivityTypeInteract          // 可进行交互的活动
};

//// 81用户取消；82商家拒绝
//typedef NS_ENUM(NSInteger, LHOrderResponseType){
//    LHOrderResponseTypeWaitingHandle1 = 2,
//    LHOrderResponseTypeWaitingHandle2 = 7,
//    LHOrderResponseTypeWaitingHandle3 = 10,
//    LHOrderResponseTypeNoComment = 4,
//    LHOrderResponseTypeHasComment = 5
//};

typedef NS_ENUM(NSInteger, LHOrderCancelReason){
    LHOrderCancelReasonCustomerPayed = 1,           // 用户取消(未支付)
    LHOrderCancelReasonCustomerNoPay,               // 用户取消(已支付)
    LHOrderCancelReasonCustomerCollecting,          // 用户取消(收衣中)
    LHOrderCancelReasonAppvworks,                   // 爱为家管理员拒绝
    LHOrderCancelReasonMerchant,                    // 商家拒绝(新增)
    LHOrderCancelReasonMerchantCollecting           // 商家拒绝(收衣)
};

typedef NS_ENUM(NSInteger, LHOrderResponseType){
    LHOrderResponseTypeToPay = 1, 				// 待支付
    LHOrderResponseTypeToAccept,				// 待受理
    LHOrderResponseTypeCollecting,				// 收衣中
    LHOrderResponseTypeServing,					// 服务中
    LHOrderResponseTypeToComment,				// 待评价
    LHOrderResponseTypeFinished,				// 已完成
    LHOrderResponseTypeForAppvworksCheck,		// 待审核
    LHOrderResponseTypeRefunding,				// 等待退款
    LHOrderResponseTypeClosed,					// 已关闭
    LHOrderResponseTypeDeleted,					// 已删除
    LHOrderResponseTypeNoPesponse,				// 新增未响应
    LHOrderResponseTypeColletingNoResponse,		// 收衣未响应
    LHOrderResponseTypeMechantRejectNew,		// 商户拒绝的新增订单
    LHOrderResponseTypeMechantRejectCollect		// 商户拒绝的收衣订单
};

typedef NS_ENUM(NSInteger, LHShareTask){
    LHShareTaskOrder = 1,       // 订单分享
    LHShareTaskActivity = 2,    // 活动分享
    LHShareTaskClient = 3,       // 客户端分享
    LHShareTaskShop = 10        // 店铺分享
};

typedef NS_ENUM(NSInteger, LHOrderActionType){
    LHOrderActionTypeCancel,
    LHOrderActionTypePay,
    LHOrderActionTypeReceive,
    LHOrderActionTypeDelete,
    LHOrderActionTypeComment,
    LHOrderActionTypeAgain,
    LHOrderActionTypeConfirm        // 确认收衣
};

typedef void(^LHCartProductCountCallback)();
typedef void(^LHCartProductCheckCallback)();
typedef void(^LHCartProductDeleteCallback)(LHSpecify *s);

typedef void (^LHOrderReqeustSuccessBlock)(AFHTTPRequestOperation *operation, id response, LHOrderRequestType type);
typedef void (^LHOrderReqeustFailureBlock)(AFHTTPRequestOperation *operation, NSError *error, LHOrderRequestType type);


typedef void(^LHShopHeaderCheckCallback)();
typedef void(^LHShopHeaderEditCallback)();
typedef void(^LHShopHeaderPressCallback)(NSInteger shopId);

typedef void(^LHSpecifyCellCheckCallback)();
typedef void(^LHSpecifyCellCountCallback)(BOOL plus);
typedef void(^LHSpecifyCellDeleteCallback)(LHSpecify *s);


//typedef NS_ENUM(NSInteger, LHEntryFrom){
//    TSScratchcardInfoTypeNone,
//    TSScratchcardInfoTypeCoin,
//    TSScratchcardInfoTypeCoupon,
//    TSScratchcardInfoTypeAll
//};

#endif






