//
//  HTTPResponseBase.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/18.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXObject.h"

@interface HTTPResponseBase : JXObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *des;

@end
