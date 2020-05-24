//
//  ImageTool.m
//  LoveHome
//
//  Created by MRH-MAC on 14/12/9.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "ImageTool.h"
#import "UIImageView+WebCache.h"
@implementation ImageTool

+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView
{
    if (imageView)
    {
        NSString *addressStr = [[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:kHTTPServer]] absoluteString];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:addressStr] placeholderImage:place options:SDWebImageRetryFailed | SDWebImageLowPriority];
    }
}


+(void)clear
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}


+ (void)getMemorySizeWithConpleBlock:(ImageMemorySizeBlock)memorySize
{
    [[SDWebImageManager sharedManager].imageCache calculateSizeWithCompletionBlock:memorySize];
}

/*!
 *  @brief  获取网络图片的全地址
 *
 *  @param baseUrlStr
 *  @param pathStr
 *
 *  @return
 */
+ (NSString *)getServerImageAllUrlWithBaseUrl:(NSString *)baseUrlStr andPath:(NSString *)pathStr
{
    if (JudgeContainerCountIsNull(baseUrlStr) || JudgeContainerCountIsNull(pathStr))
    {
        return nil;
    }
    
    NSURL *baseUrl  = [NSURL URLWithString:baseUrlStr];
    if ([[baseUrl path] length] > 0 && ![[baseUrl absoluteString] hasSuffix:@"/"])
    {
        baseUrl = [baseUrl URLByAppendingPathComponent:@""];
    }
    
    NSString *resultUrl = [[NSURL URLWithString:pathStr relativeToURL:baseUrl] absoluteString];
    return resultUrl;
}

@end
