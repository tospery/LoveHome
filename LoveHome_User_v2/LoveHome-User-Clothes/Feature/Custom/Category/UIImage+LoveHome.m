//
//  UIImage+LoveHome.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "UIImage+LoveHome.h"

@implementation UIImage (LoveHome)
+(NSData *)imageObjectToData:(UIImage *)originImage
       andCompressionQuality:(CGFloat)compressionQuality
                  andMaxSize:(NSUInteger)maxSize
{
    if (!originImage || !maxSize)
    {
        return nil;
    }
    
    CGSize  newSize      = CGSizeZero;
    CGFloat qualityRate  = compressionQuality;
    
    //获取原始图片的大小
    NSData     *originImageData = UIImageJPEGRepresentation(originImage,1.0);
    NSUInteger originImageSize  = [originImageData length]/1024;
    
    if (originImageSize <= maxSize)
    {
        newSize = originImage.size;
        
    }else
    {
        CGFloat rate = ((CGFloat)maxSize)/((CGFloat)originImageSize);
        
        newSize.width  = originImage.size.width*rate;
        newSize.height = originImage.size.height*rate;
    }
    
    if (!newSize.width || !newSize.height)
    {
        return nil;
    }
    
    originImage = [self scaleImage:originImage toWidth:newSize.width toHeight:newSize.height];
    
    NSData* pictureData = UIImageJPEGRepresentation(originImage,qualityRate);
    
    return pictureData;
}

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
    int width=0;
    int height=0;
    int x=0;
    int y=0;
    
    if (image.size.width<toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height<toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else if (image.size.width>toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height>toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else{
        height = toHeight;
        width = toWidth;
    }
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

@end
