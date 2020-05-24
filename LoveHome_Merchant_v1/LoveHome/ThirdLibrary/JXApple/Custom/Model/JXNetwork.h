//
//  JXNetwork.h
//  MyReachability
//
//  Created by Thundersoft on 15/3/27.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#ifdef JXEnableReachability
#import <Foundation/Foundation.h>

@interface JXNetwork : NSObject
@property (nonatomic, strong, readonly) NSString *ip;

- (void)setupChangeBlock:(void (^)(NetworkStatus status))changeBlock;
- (BOOL)isEnabled;

+ (JXNetwork *)sharedInstance;
+ (NetworkStatus)currentNetworkStatus;
@end
#endif