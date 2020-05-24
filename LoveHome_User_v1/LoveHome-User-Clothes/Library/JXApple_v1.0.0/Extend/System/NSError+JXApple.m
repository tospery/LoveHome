//
//  NSError+JXApple.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/1.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "NSError+JXApple.h"

@implementation NSError (JXApple)
+ (NSError *)exErrorWithCode:(JXErrorCode)code {
    if (code <= JXErrorCodeNone || code >= JXErrorCodeAll) {
        return nil;
    }
    
    NSString *description;
    switch (code) {
        case JXErrorCodeNetworkException:
            description = kStringNetworkException;
            break;
        case JXErrorCodeServerException:
            description = kStringServerException;
            break;
        case JXErrorCodeDataEmpty:
            description = kStringDataEmpty;
            break;
        case JXErrorCodeTokenInvalid:
            description = kStringTokenInvalid;
            break;
        default:
            description = kStringUnknown;
            break;
    }
    
    return [NSError errorWithDomain:[JXApp identifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (NSError *)exErrorWithCode:(JXErrorCode)code description:(NSString *)description {
    return [NSError errorWithDomain:[JXApp identifier]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: (description ? description : kStringUnknown)}];
}
@end
