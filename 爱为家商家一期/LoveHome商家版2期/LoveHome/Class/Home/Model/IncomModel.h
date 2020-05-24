//
//  IncomModel.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//



@interface IncomModel : NSObject
@property (nonatomic,strong) NSString *endDate;
@property (nonatomic,strong) NSString *half;
@property (nonatomic,strong) NSString *startDate;
@property (nonatomic,assign) CGFloat  totalIncome;
@property (nonatomic,assign) NSInteger orders;

@end
