//
//  LHError.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHError : NSObject
+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description;

@end
