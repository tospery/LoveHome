//
//  JXNetwork.m
//  MyReachability
//
//  Created by Thundersoft on 15/3/27.
//  Copyright (c) 2015年 Thundersoft. All rights reserved.
//

#ifdef JXEnableReachability
#import "JXNetwork.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

static Reachability *reachability;

@interface JXNetwork ()
@property (nonatomic, strong, readwrite) NSString *ip;
@property (nonatomic, copy) void(^changeBlock)(NetworkStatus status);
@end

@implementation JXNetwork
#pragma mark - Accessor methods
- (NSString *)ip {
    if (![self isEnabled]) {
        return nil;
    }
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}

#pragma mark - Notification methods
- (void)notifyReachabilityChanged:(NSNotification *)notification {
    Reachability *currentReachability = [notification object];
    NetworkStatus networkStatus = currentReachability.currentReachabilityStatus;
    if (_changeBlock) {
        _changeBlock(networkStatus);
    }
}

#pragma mark - Pulibc methods
- (void)setupChangeBlock:(void (^)(NetworkStatus status))changeBlock {
    if (changeBlock) {
        _changeBlock = changeBlock;
        [reachability startNotifier];
    }else {
        [reachability stopNotifier];
    }
}

- (BOOL)isEnabled {
    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable;
}

#pragma Class methods
+ (void)load {
    [super load];

    JXNetwork *network = [JXNetwork sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:network
                                             selector:@selector(notifyReachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
}

+ (JXNetwork *)sharedInstance {
    static JXNetwork *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (NetworkStatus)currentNetworkStatus {
    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
}
@end
#endif