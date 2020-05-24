//
//  RHVersionManager.m
//  LoveHome
//
//  Created by MRH on 14/10/4.
//  Copyright © 2014年 卡莱博尔. All rights reserved.
//

#import "RHVersionManager.h"


@interface RHVersionManager ()
@property (nonatomic, strong, readwrite) NSString *current;
@property (nonatomic, copy) void(^beginning)();
@property (nonatomic, copy) void(^completion)(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error);
@end

@implementation RHVersionManager

#pragma mark - Private methods
- (void)analyseUpdateInfo:(NSDictionary *)info {
    NSInteger resultCount = [info[@"resultCount"] integerValue];
    if (resultCount > 0) {
        NSArray *results = info[@"results"];
        NSDictionary *dictionary= [results objectAtIndex:0];
        NSString *newVersion = dictionary[@"version"];
        NSString *releaseNote = dictionary[@"releaseNotes"];
        NSString *openURL = dictionary[@"trackViewUrl"];
        
        NSComparisonResult cr = [newVersion compare:self.current options:NSCaseInsensitiveSearch];
        if (NSOrderedDescending == cr) {
            if (_completion) {
                _completion(YES, newVersion, releaseNote, openURL,  nil);
            }
        }else {
            if (_completion) {
                _completion(NO, newVersion, releaseNote, openURL, nil);
            }
        }
    } else {
        if (_completion) {
            _completion(NO, self.current, nil, nil, nil);
        }
    }
}

#pragma mark - Accessor methods
- (NSString *)current {
    if (!_current) {
        _current = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _current;
}

#pragma mark - Public methods

- (void)checkUpdateWithAppID:(NSString *)appID
                   beginning:(void(^)())beginning
                  completion:(void(^)(BOOL updated, NSString *newVersion, NSString *releaseNote, NSString *openURL, NSError *error))completion {
    _beginning = beginning;
    _completion = completion;
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *body = [NSString stringWithFormat:@"id=%@", appID];
    [self sendRequestWithURL:url body:body];
}

- (void)sendRequestWithURL:(NSURL *)url body:(NSString *)body {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([body length] > 0) {
        NSArray *array = [body componentsSeparatedByString:@"&"];
        for (NSString *strParameters in array) {
            NSArray *arrayKV = [strParameters componentsSeparatedByString:@"="];
            [params setObject:arrayKV[1] forKey:arrayKV[0]];
        }
    }
    
    if (_beginning) {
        _beginning();
    }
    
    [manager POST:url.absoluteString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __block NSError *changeError;
        __block NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                             options:NSJSONReadingMutableLeaves
                                                                               error:&changeError];
        if (!changeError) {
            [self analyseUpdateInfo:responseDict];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_completion) {
            _completion(NO, nil, nil, nil, error);
        }
    }];
}

#pragma mark - Class methods
+ (RHVersionManager *)sharedInstance {
    static RHVersionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


@end
