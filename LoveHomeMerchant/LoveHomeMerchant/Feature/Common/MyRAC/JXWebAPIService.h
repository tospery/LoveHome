//
//  JXWebAPIService.h
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/17.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXWebAPIService <NSObject>
- (RACSignal *)requestWithParam:(HTTPRequestParam *)param;
- (RACSignal *)requestWithParam:(HTTPRequestParam *)param schema:(HTTPRequestSchema *)schema;
- (RACSignal *)requestWithParam:(HTTPRequestParam *)param class:(Class)cls;
- (RACSignal *)requestWithParam:(HTTPRequestParam *)param schema:(HTTPRequestSchema *)schema class:(Class)cls;

@end
