//
//  LHError.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "LHError.h"

@implementation LHError

+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description
{
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}
@end
