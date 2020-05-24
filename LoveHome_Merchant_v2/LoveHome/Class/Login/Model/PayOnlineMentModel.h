//
//  PayOnlineMentModel.h
//  LoveHome
//
//  Created by MRH-MAC on 15/3/10.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"
typedef enum : NSUInteger {
    airPlayType = 1,
    weicatType  = 2,
    UpacashType = 3,
    tenPayType  = 4
    
} Paytype;
@interface PayOnlineMentModel : BaseDataModel
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *payMentName;
@property (nonatomic, strong) NSString *payMentDescription;
@property (nonatomic, assign) Paytype  payType;
@property (nonatomic, assign) BOOL     isSelect;
@end
