//
//  JXCollapsibleView.h
//  MyiOS
//
//  Created by Thundersoft on 14/12/10.
//  Copyright (c) 2014年 Thundersoft. All rights reserved.
//

#ifdef JXEnableMasonry
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXCollapsibleViewMode){
    JXCollapsibleViewModeAuto,
    JXCollapsibleViewModeBase,
    JXCollapsibleViewModeClose,
    JXCollapsibleViewModeOpen
};

@interface JXCollapsibleView : UIView
@property (nonatomic, strong) NSString  *text;

- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines;
- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor arrowColor:(UIColor *)arrowColor;

- (void)setBlockForPressed:(void (^)(JXCollapsibleViewMode mode))pressedBlock;
@end
#endif