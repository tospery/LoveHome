//
//  LHHttp.h
//  LoveHome
//
//  Created by MRH-MAC on 15/11/17.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHHttp : NSObject

/*
 二期接口统计
 */


#pragma mark - 统计接口

#pragma mark -访客数量统计
+(AFHTTPRequestOperation *)getVisitorStatisticSuccess:(HttpServiceBasicSucessBackBlock)sucesess
                                              fail:(HttpServiceBasicFailBackBlock)fail;


@end
