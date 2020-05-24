//
//  JXInputManager.h
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/30.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXInputManagerLimit){
    JXInputManagerLimitDistinguish,    // 1个汉字占2个字符
    JXInputManagerLimitCompatible      // 不区分
};

typedef NS_ENUM(NSInteger, JXInputManagerVerify){
    JXInputManagerVerifyNone,
    JXInputManagerVerifyNeed,                   // 不能为空
    JXInputManagerVerifyWhitespaceLT,           // 首尾不能包含空白字符
    JXInputManagerVerifyWhitespaceAll,          // 输入不能全为空白字符
    JXInputManagerVerifyPureChars,              // 纯英文
    JXInputManagerVerifyPureNums,               // 纯数字
    JXInputManagerVerifyPureASCII,              // 纯英文+数字
    JXInputManagerVerifyLeast,                  // 至少输入
    JXInputManagerVerifySame                    // 不能相同
};

@interface UITextField (JXInputManagerCategory)
- (void)exSetupLimit:(NSUInteger)limit;
@end

@interface UITextView (JXInputManagerCategory)
- (void)exSetupLimit:(NSUInteger)limit;
@end

@interface JXInputManager : NSObject
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) JXInputManagerLimit type;

- (void)setupExceedBlock:(void(^)(UIView *inputView, NSUInteger exceed))exceedBlock countBlock:(void(^)(UIView *inputView, NSUInteger count))countBlock;
+ (JXInputManager *) sharedInstance;


/**
 *  验证输入（不支持本地化）
 *
 *  @param input          输入
 *  @param least          至少
 *  @param original       原来
 *  @param ltSpaces       是否允许首尾空白
 *  @param containLetters 是否包含字母
 *  @param containNumbers 是否包含数字
 *  @param containSymbols 是否包含符号
 *  @param title          标题
 *
 *  @return 提示信息
 */
+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
                 ltSpaces:(BOOL)ltSpaces
           containLetters:(BOOL)containLetters
           containNumbers:(BOOL)containNumbers
           containSymbols:(BOOL)containSymbols
                    title:(NSString *)title;

+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
            spacesAllowed:(BOOL)spacesAllowed
                pureChars:(BOOL)pureChars
                 pureNums:(BOOL)pureNums
                     name:(NSString *)name;
+ (JXInputManagerVerify)verifyInput:(NSString *)input
                              least:(NSInteger)least
                           original:(NSString *)original
                      spacesAllowed:(BOOL)spacesAllowed
                          pureChars:(BOOL)pureChars
                           pureNums:(BOOL)pureNums;
+ (NSString *)verifyPhoneNumber:(NSString *)phoneNumber original:(NSString *)original;
@end