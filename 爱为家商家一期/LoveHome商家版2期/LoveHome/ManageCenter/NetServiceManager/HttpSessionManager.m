//
//  HttpSessionManager.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/29.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "HttpSessionManager.h"

@implementation HttpSessionManager

+(void)test
{
   
    AFHTTPSessionManager *manger = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kHTTPServer]];
    NSDictionary *params = @{@"mobile": @"13678013287"};
    NSError *error;
    NSMutableURLRequest *request = [manger.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"general/getCode" relativeToURL:manger.baseURL] absoluteString] parameters:params error:&error];
    

    NSURLSessionDataTask *tak  = [manger dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        
        if (error) {
           
        } else {
           
        }

        
    }];
    
    [tak resume];
    

//    
//    AFHTTPRequestOperation *operation = [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getCode" andParameterDic:params andPatameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:success andFailedCallback:failure];
//
    
    
//    [seesion POST:nil parameters:nil constructingBodyWithBlock:nil success:nil failure:nil];
//    
//    [seesion POST:nil parameters:nil success:nil failure:nil];
}

@end
