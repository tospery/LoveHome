
//
//  NSString+ContentSize.h
//  ScrollerViewPage
//
//  Created by MRH-MAC on 15/1/7.
//  Copyright (c) 2015年 MRH-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end

@interface UIImage (ImageEffects)


#pragma mark 图片尺寸处理
/*!
 *  @brief  根据给的尺寸得到缩率图
 *
 *  @param targetSize 想要缩放的大小
 *
 *  @return UIImage
 */
- (UIImage *)thumbnailImage:(CGSize)targetSize;


/*!
 *  @brief  裁减图片
 *
 *  @param heightScale 高度的裁减比例（范围：0～1）
 *  @param orginImage  原始图片
 *
 *  @return UIImage
 */
+ (UIImage *)cutImageByHeightScale:(CGFloat)heightScale andOrginImage:(UIImage *)orginImage;


#pragma mark 图片效果处理
/* 毛玻璃效果处理 */
//- (UIImage *)applyLightEffect;
//- (UIImage *)applyExtraLightEffect;
//- (UIImage *)applyDarkEffect;
//- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
//- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


#pragma mark 图片质量和对象转换处理
/*
 * 图片转换处理
 */
+(NSString *)image2String:(UIImage *)image;
+(NSData *)imageToData:(UIImage *)image andSize:(CGSize)size;

/*!
 *  @brief  把UIImage转换成NSData(默认显示大小：500KB，压缩质量比：1.0)
 *
 *  @param originImage        原始图片
 *
 *  @return NSData
 */
+(NSData *)imageObjectToData:(UIImage *)originImage;


/*!
 *  @brief  把UIImage转换成NSData
 *
 *  @param originImage        原始图片
 *  @param compressionQuality 图片压缩质量比（0.0～1.0）
 *  @param maxSize            图片文件大小的最大限制（单位是KB）
 *
 *  @return NSData
 */
+(NSData *)imageObjectToData:(UIImage *)originImage
       andCompressionQuality:(CGFloat)compressionQuality
                  andMaxSize:(NSUInteger)maxSize;



#pragma mark 生成图片处理
/*!
 *  @brief  根据颜色生成图片
 *
 *  @param color 图片颜色
 *  @param size  图片尺寸
 *
 *  @return UIImage
 */
+ (UIImage *)creatImageWithColor:(UIColor *)color andSize:(CGSize)size;


#pragma mark 图片存删取相关处理
/*!
 *  @brief  存储图片到Documents\自己创建的文件夹名字
 *
 *  @param foldername 存储图片的文件夹名
 *  @param filename   存储图片的文件文字
 *  @param data       存储的图片数据
 *
 *  @return BOOL
 */
+ (BOOL)savePhotoFileToFolderWithFolderName:(NSString *)foldername
                                andFileName:(NSString *)filename
                                    andData:(NSData *)data;


/*!
 *  @brief  获取存储的图片
 *
 *  @param imageName  图片的名字
 *  @param folderName 存储图片的文件夹名
 *
 *  @return UIImage
 */
+ (UIImage *)getImageFromSandboxWithImageName:(NSString *)imageName
                                fromDirectory:(NSString *)folderName;


/*!
 *  @brief  删除指定的图片
 *
 *  @param nameArray  即将删除的图片名字数组
 *  @param folderName 存储图片的文件夹名
 */
+(void)deleteImageFileWithNamesArray:(NSArray *)nameArray
                       fromDirectory:(NSString *)folderName;


/*!
 *  @brief  删除指定文件夹的所有图片
 *
 *  @param folderName 存储图片的文件夹名
 */
+(void)deleteAllImageFileFromDirectory:(NSString *)folderName;




#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName;

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;













@end
