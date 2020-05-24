//
//  JXUtil.m
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/3.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXUtil.h"
#import "JXTool.h"
#import "UIBarButtonItem+JXApple.h"
#import "NSString+JXApple.h"
#import <objc/runtime.h>

#ifdef JXEnableSDWebImage
#import "UIImageView+WebCache.h"
#endif

UIBarButtonItem * JXCreateLeftBarItem(id target) {
    UIBarButtonItem *backBarItem;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#ifdef JXEnableVBFPopFlatButton
    backBarItem = [UIBarButtonItem exBarItemWithType:buttonBackType
                                               color:[UIColor whiteColor]
                                              target:target
                                              action:@selector(leftBarItemPressed:)];
#else
    backBarItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"back"]
                                                 size:CGSizeMake(12, 20.6)
                                               target:target
                                               action:@selector(leftBarItemPressed:)];
#endif
#pragma clang diagnostic pop
    return backBarItem;
}

BOOL JXJudgeContainerIsEmptyOrNull(id container) {
    if (container)
    {
        if ([container isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)container;
            if ([array count] > 0)
            {
                return NO;
            }else
            {
                return YES;
            }
        }else if ([container isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)container;
            if ([[dictionary allKeys] count] > 0)
            {
                return NO;
            }else
            {
                return YES;
            }
        }else if ([container isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)container;
            if ([string length] > 0)
            {
                if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"(NULL)"] || [string isEqualToString:@"null"] || [string isEqualToString:@"NULL"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"<NULL>"])
                {
                    return YES;
                }
                else if ([string exTrim].length == 0)
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }else if ([container isKindOfClass:[NSNumber class]])
        {
            NSNumber *number = (NSNumber *)container;
            if ([number isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                return YES;
            }else
            {
                return NO;
            }
        }
    }
    return YES;
}


//+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView
//{
//    if (imageView)
//    {
//        NSString *addressStr = [[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:HttpServerManage_REQUEST_BASE_URL]] absoluteString];
//        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:addressStr] placeholderImage:place options:SDWebImageRetryFailed | SDWebImageLowPriority];
//    }
//}


void JXDownloadImage(NSString *urlString, UIImage *placeholderImage, UIImageView *imageView) {
#ifdef JXEnableSDWebImage
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                 placeholderImage:placeholderImage
                          options:(SDWebImageRetryFailed | SDWebImageLowPriority)];
#else
    JXLogError(@"未添加SDWebImage支持！");
#endif
}


NSArray * JXAllPropertyFromClass(NSObject* className) {
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([className class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return [NSArray arrayWithArray:propertyNames];
}

