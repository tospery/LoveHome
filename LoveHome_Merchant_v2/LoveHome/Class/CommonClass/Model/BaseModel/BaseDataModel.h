//
//  BaseDataModel.h
//  ProjectFrameworkXC5.0
//
//  Created by MRH on 14-10-21.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataModel : NSObject <NSCopying,NSMutableCopying, NSSecureCoding>

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

- (NSDictionary *)objectToDictionary;

@end
