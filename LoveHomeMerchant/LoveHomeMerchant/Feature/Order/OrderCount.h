//
//  OrderCount.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/21.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "JXObject.h"

@interface OrderCount : JXArchiveObject
@property (nonatomic, assign) NSInteger newlyIncreasedCount;
@property (nonatomic, assign) NSInteger notResponseCount;
@property (nonatomic, assign) NSInteger colletingCount;
@property (nonatomic, assign) NSInteger servingCount;
@property (nonatomic, assign) NSInteger finishedCount;
@property (nonatomic, assign) NSInteger rejectedCount;

@end
