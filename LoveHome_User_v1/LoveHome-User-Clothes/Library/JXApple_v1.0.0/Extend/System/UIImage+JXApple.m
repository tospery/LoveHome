//
//  UIImage+JXApple.m
//  MyiOS
//
//  Created by Thundersoft on 10/20/14.
//  Copyright (c) 2014 Thundersoft. All rights reserved.
//

#import "UIImage+JXApple.h"
#import "JXApple.h"

#ifdef JXEnableZXing
#import "ZXingObjC.h"
#endif

@implementation UIImage (JXApple)
+ (UIImage *)exImageWithColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawText:(NSString *)text font:(UIFont *)font color:(UIColor *)color size:(CGSize)size {
    CGRect textRect;
    CGSize standardSize = [kStringNone exSizeWithFont:font width:size.width];
    CGSize textSize = [text exSizeWithFont:font width:size.width];
    if (textSize.height > standardSize.height) {
        textRect.origin.x = 0;
        textRect.origin.y = (size.height - textSize.height) / 2.0;
        textRect.size.width = size.width;
        textRect.size.height = textSize.height;
    }else {
        textRect.origin.x = (size.width - textSize.width) / 2.0;
        textRect.origin.y = size.height / 2.0 - textSize.height;
        textRect.size.width = textSize.width;
        textRect.size.height = textSize.height;
    }


    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [color set];
    [text exDrawInRect:textRect
                  font:font
                 color:color
             alignment:NSTextAlignmentLeft];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)exScaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)exStretchCenter {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5
                                     topCapHeight:self.size.height * 0.5];
}

+ (UIImage *)exImageWithQRCode:(NSString *)qrCode {
#ifdef JXEnableZXing
    {
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        
        ZXEncodeHints* hints = [ZXEncodeHints hints];
        hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];//容错性设成最高，二维码里添加图片
        hints.encoding =  NSUTF8StringEncoding;// 加上这两句，可以用中文了
        
        ZXBitMatrix* result = [writer encode:qrCode format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            return [UIImage imageWithCGImage:image];
        } else {
            NSString* errorMessage = [error localizedDescription];
            JXLogError(@"%@", errorMessage);
            return nil;
        }
    }
#else
    {
        NSLog(@"未添加ZXing支持！");
        return nil;
    }
#endif
}
@end
