//
//  ImageTool.h
//  LoveHome
//
//  Created by MRH-MAC on 14/12/9.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTool : NSObject
typedef void(^ImageMemorySizeBlock)(NSUInteger fileCount, NSUInteger totalSize);
/*!
 *  @brief  加载网络图片
 *
 *  @param url       网络图片地址
 *  @param place     占位图片
 *  @param imageView 被显示的图片
 */
+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView;


/*!
 *  @brief  Clear缓存
 */
+ (void)clear;


/*!
 *  @brief  获取当前图片占有内存大小
 *
 *  @param memorySize
 */

+ (void)getMemorySizeWithConpleBlock:(ImageMemorySizeBlock)memorySize;

/*!
 *  @brief  获取网络图片的全地址
 *
 *  @param baseUrlStr
 *  @param pathStr
 *
 *  @return
 */
+ (NSString *)getServerImageAllUrlWithBaseUrl:(NSString *)baseUrlStr andPath:(NSString *)pathStr;

@end
