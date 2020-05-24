//
//  JXHTTPClient.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/4.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableAFNetworking
#import "JXHTTPClient.h"
#import "JXApple.h"

@interface JXHTTPClient ()
@end

@implementation JXHTTPClient
#pragma mark - Private methods
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSProgress *progress = nil;
    if ([object isKindOfClass:[NSProgress class]]) {
        progress = (NSProgress *)object;
    }
    
    if (progress) {
        if (self.progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress(progress.fractionCompleted);
            });
        }
    }
}

#pragma mark - Class methods
+ (AFHTTPRequestOperation *)sendBaseRequestWithBaseString:(NSString *)baseString
                                               pathString:(NSString *)pathString
                                               methodType:(JXHTTPMethodType)methodType
                                                paramType:(JXHTTPParamType)paramType
                                                   params:(id)params
                                                    files:(NSArray *)files
                                                  headers:(NSDictionary *)headers
                                                  success:(JXHTTPRequestSuccessBlock)success
                                                  failure:(JXHTTPRequestFailureBlock)failure
                                                 progress:(JXHTTPProgressBlock)progress {
    JXLogDebug(@"请求：\npath = %@\nparams = %@", pathString, params);
    if (0 == baseString.length || 0 == pathString.length) {
        return nil;
    }
    
    NSTimeInterval timeout = 60.0f;
#ifdef kHTTPTimeout
    timeout = kHTTPTimeout;
#endif
    
    // Get
    if (JXHTTPMethodTypeGet == methodType) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseString]];
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy = securityPolicy;
        
        manager.requestSerializer.timeoutInterval = timeout;
        return [manager GET:pathString parameters:params success:success failure:failure];
    }
    
    // Post
    if (JXHTTPMethodTypePost == methodType) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseString]];
        
        if (JXHTTPParamTypeJSON == paramType) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy = securityPolicy;
        manager.requestSerializer.timeoutInterval = timeout;
        
        for (NSString *key in headers.allKeys) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        
        AFHTTPRequestOperation *operation;
        if (files.count > 0) {
            operation = [manager POST:pathString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSDictionary *info in files) {
                    NSString *arg = [info objectForKey:kJXHTTPFileArg];
                    NSString *name = [info objectForKey:kJXHTTPFileName];
                    NSData *data = [info objectForKey:kJXHTTPFileData];
                    
                    NSString *type;
                    if ([name hasSuffix:@".png"]) {
                        type = @"image/png";
                    }else if ([name hasSuffix:@".jpg"]) {
                        type = @"image/jpeg";
                    }else {
                        NSLog(@"文件名错误");
                    }
                    
                    [formData appendPartWithFileData:data name:arg fileName:name mimeType:type];
                }
            } success:success failure:failure];
        }else {
            operation = [manager POST:pathString parameters:params success:success failure:failure];
        }
        
        if (progress) {
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                progress((CGFloat)totalBytesWritten / totalBytesExpectedToWrite);
            }];
        }
        
        return operation;
    }
    
    return nil;
}

+ (NSURLSessionUploadTask *)sendUploadTaskWithBaseString:(NSString *)baseString
                                              pathString:(NSString *)pathString
                                               paramType:(JXHTTPParamType)paramType
                                                  params:(id)params
                                                   files:(NSArray *)files
                                                 headers:(NSDictionary *)headers
                                                 success:(JXHTTPTaskSuccessBlock)success
                                                 failure:(JXHTTPTaskFailureBlock)failure
                                                progress:(JXHTTPProgressBlock)progress {
    if (0 == baseString.length || 0 == pathString.length) {
        return nil;
    }
    
    NSTimeInterval timeout = 60.0f;
#ifdef kHTTPTimeout
    timeout = kHTTPTimeout;
#endif
    
    NSURL *url = [NSURL exURLWithBase:baseString path:pathString];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *info in files) {
            NSString *arg = [info objectForKey:kJXHTTPFileArg];
            NSString *name = [info objectForKey:kJXHTTPFileName];
            NSData *data = [info objectForKey:kJXHTTPFileData];
            
            NSString *type;
            if ([name hasSuffix:@".png"]) {
                type = @"image/png";
            }else if ([name hasSuffix:@".jpg"]) {
                type = @"image/jpeg";
            }else {
                NSLog(@"文件名错误");
            }
            
            [formData appendPartWithFileData:data name:arg fileName:name mimeType:type];
        }
        
    } error:nil];
    
    for (NSString *key in headers.allKeys) {
        [request addValue:headers[key] forHTTPHeaderField:key];
    }
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest  = timeout;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    NSProgress *pg = nil;
    NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:&pg completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if (success) {
                success(response, responseObject);
            }
        }else {
            if (failure) {
                failure(response, error);
            }
        }
    }];
    
    JXHTTPClient *client = [JXHTTPClient sharedInstance];
    client.progress = progress;
    [pg addObserver:client forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    
    [task resume];
    return task;
}

+ (AFHTTPRequestOperation *)sendSOAPRequestWithBaseString:(NSString *)baseString
                                            soapNamespace:(NSString *)soapNamespace
                                               soapAction:(NSString *)soapAction
                                                   params:(NSDictionary *)params
                                                  success:(JXHTTPRequestSuccessBlock)success
                                                  failure:(JXHTTPRequestFailureBlock)failure {
    if (0 == soapNamespace.length || 0 == soapAction.length) {
        return nil;
    }
    
    NSMutableString *soapMessage = [NSMutableString string];
    [soapMessage appendString:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"];
    [soapMessage appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\">", soapAction, soapNamespace]];
    for (NSString *key in params.allKeys) {
        [soapMessage appendString:[NSString stringWithFormat:@"<%@>%@</%@>", key, params[key], key]];
    }
    [soapMessage appendString:[NSString stringWithFormat:@"</%@>", soapAction]];
    [soapMessage appendString:
     @"</soap:Body>"
     "</soap:Envelope>"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseString]];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = kHTTPTimeout;
    [manager.requestSerializer setValue:[[NSURL URLWithString:baseString] host] forHTTPHeaderField:@"Host"];
    [manager.requestSerializer setValue:[[NSURL exURLWithBase:soapNamespace path:soapAction] absoluteString] forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setValue:JXStringFromInteger(soapMessage.length) forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return [manager POST:baseString parameters:soapMessage success:success failure:failure];
}

+ (JXHTTPClient *)sharedInstance {
    static JXHTTPClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXHTTPClient alloc] init];
    });
    return instance;
}

#pragma mark private
+ (NSString *)getMethodValue:(JXHTTPMethodType)methodType {
    NSString *result = @"POST";
    switch (methodType) {
        case JXHTTPMethodTypeGet:
            result = @"GET";
            break;
        case JXHTTPMethodTypePost:
            result = @"POST";
            break;
        case JXHTTPMethodTypePut:
            result = @"PUT";
            break;
        case JXHTTPMethodTypeDelete:
            result = @"DELETE";
            break;
        default:
            break;
    }
    return result;
}
@end
#endif
