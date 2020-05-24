//
//  UIImage+LoveHome.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LoveHome)
+(NSData *)imageObjectToData:(UIImage *)originImage
       andCompressionQuality:(CGFloat)compressionQuality
                  andMaxSize:(NSUInteger)maxSize;
@end
