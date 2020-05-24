//
//  JXInputManager.m
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/30.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXInputManager.h"
#import "JXApple.h"
#import <objc/runtime.h>

#define kJXInputManagerCategoryLimitKey        @"kJXInputManagerCategoryLimitKey"

static NSMutableDictionary *limitDict;

@implementation UITextField (JXInputManagerCategory)
- (id)valueForUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
            return [limitDict objectForKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            return objc_getAssociatedObject(self, key.UTF8String);
        }
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
            [limitDict setObject:value forKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)exSetupLimit:(NSUInteger)limit {
    [self setValue:[NSNumber numberWithUnsignedInteger:limit] forKey:kJXInputManagerCategoryLimitKey];
}

//- (void)clearLimit {
//    [limitDict removeObjectForKey:[NSString stringWithFormat:@"%p", self]];
//}
@end


@implementation UITextView (JXInputManagerCategory)
- (id)valueForUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
            return [limitDict objectForKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            return objc_getAssociatedObject(self, key.UTF8String);
        }
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
            [limitDict setObject:value forKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)exSetupLimit:(NSUInteger)limit {
    [self setValue:[NSNumber numberWithUnsignedInteger:limit] forKey:kJXInputManagerCategoryLimitKey];
}

//- (void)clearLimit {
//    [limitDict removeObjectForKey:[NSString stringWithFormat:@"%p", self]];
//}
@end


@interface JXInputManager ()
@property (nonatomic, copy) void(^exceedBlock)(UIView *inputView, NSUInteger exceed);
@property (nonatomic, copy) void(^countBlock)(UIView *inputView, NSUInteger count);
@end

@implementation JXInputManager
+ (void)load {
    [super load];
    if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
        limitDict = [NSMutableDictionary dictionary];
    }
    [JXInputManager sharedInstance];
}

+ (JXInputManager *)sharedInstance {
    static JXInputManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXInputManager alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.enable = YES;
    }
    return self;
}

- (void)setEnable:(BOOL)enable {
    if (_enable == enable) {
        return;
    }
    
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextFieldTextDidChangeNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object: nil];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    _enable = enable;
}

- (void)setupExceedBlock:(void(^)(UIView *inputView, NSUInteger exceed))exceedBlock
              countBlock:(void(^)(UIView *inputView, NSUInteger count))countBlock {
    if (!JXiOSVersionGreaterThanOrEqual(7.0) && !exceedBlock && !countBlock) {
        [limitDict removeAllObjects];
    }
    
    _exceedBlock = exceedBlock;
    _countBlock = countBlock;
}

- (void)textFieldViewDidChange:(NSNotification*)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    NSNumber *number;
    if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
        number = [limitDict objectForKey:[NSString stringWithFormat:@"%p", textField]];
    }else {
        number = [textField valueForKey:kJXInputManagerCategoryLimitKey];
    }
    if (!number) {
        return;
    }
    
    UITextRange *textRange = textField.markedTextRange;
    if (textRange) {
        return;
    }
    
    NSUInteger limit = number.unsignedIntegerValue;
    NSUInteger chars;
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textField.text lengthInByte];
    }else {
        chars = textField.text.length;
    }
    if (chars > limit) {
        NSInteger adjust = limit;
        if (chars == limit + 1) {
            NSString *subString = [textField.text substringWithRange:NSMakeRange(limit - 1, 1)];
            const char *cString = [subString UTF8String];
            if (NULL == cString) {
                adjust -= 1;
            }
        }
        
        if (JXInputManagerLimitDistinguish == _type) {
            textField.text = [textField.text substringByBytes:adjust];
        }else {
            textField.text = [textField.text substringToIndex:adjust];
        }
        
        if (_exceedBlock) {
            _exceedBlock(textField, limit);
        }
    }
    
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textField.text lengthInByte];
    }else {
        chars = textField.text.length;
    }
    
    if (_countBlock) {
        _countBlock(textField,chars);
    }
}

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    
    NSNumber *number;
    if (!JXiOSVersionGreaterThanOrEqual(7.0)) {
        number = [limitDict objectForKey:[NSString stringWithFormat:@"%p", textView]];
    }else {
        number = [textView valueForKey:kJXInputManagerCategoryLimitKey];
    }
    if (!number) {
        return;
    }
    
    UITextRange *textRange = textView.markedTextRange;
    if (textRange) {
        return;
    }
    
    NSUInteger limit = number.unsignedIntegerValue;
    NSUInteger chars;
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textView.text lengthInByte];
    }else {
        chars = textView.text.length;
    }
    if (chars > limit) {
        NSInteger adjust = limit;
        if (chars == limit + 1) {
            NSString *subString = [textView.text substringWithRange:NSMakeRange(limit - 1, 1)];
            const char *cString = [subString UTF8String];
            if (NULL == cString) {
                adjust -= 1;
            }
        }
        
        if (JXInputManagerLimitDistinguish == _type) {
            textView.text = [textView.text substringByBytes:adjust];
        }else {
            textView.text = [textView.text substringToIndex:adjust];
        }
        
        if (_exceedBlock) {
            _exceedBlock(textView, limit);
        }
    }
    
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textView.text lengthInByte];
    }else {
        chars = textView.text.length;
    }
    
    if (_countBlock) {
        _countBlock(textView, chars);
    }
}

#pragma mark - Class methods
+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
                 ltSpaces:(BOOL)ltSpaces
           containLetters:(BOOL)containLetters
           containNumbers:(BOOL)containNumbers
           containSymbols:(BOOL)containSymbols
                    title:(NSString *)title {
    // 不能为空
    if (0 == input.length) {
        return [NSString stringWithFormat:@"%@不能为空", title];
    }
    
    // 输入不能全为空白字符
    if (0 == [input exTrim].length) {
        return [NSString stringWithFormat:@"%@不能全为空白字符", title];
    }
    
    // 至少输入
    if (input.length < least) {
        return [NSString stringWithFormat:@"%@至少为%@位", title, @(least)];
    }
    
    // 不能相同
    if ([[input exTrim] isEqualToString:[original exTrim]]) {
        return [NSString stringWithFormat:@"请输入与原%@不一样的新%@", title, title];
    }
    
    // 首尾不能包含空白字符
    if (!ltSpaces) {
        NSString *first = [input substringToIndex:1];
        NSString *last = [input substringFromIndex:(input.length - 1)];
        NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSRange range = [first rangeOfCharacterFromSet:wnSet];
        if (range.location != NSNotFound) {
            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
        }
        
        range = [last rangeOfCharacterFromSet:wnSet];
        if (range.location != NSNotFound) {
            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
        }
    }
    
    // 纯英文
    if (containLetters && !containNumbers && !containSymbols) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            return [NSString stringWithFormat:@"%@只能包含英文字母", title];
        }
    }
    
    // 纯数字
    if (!containLetters && containNumbers && !containSymbols) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            [NSString stringWithFormat:@"%@只能包含数字", title];
        }
    }
    
    // 纯英文+数字
    if (containLetters && containNumbers && !containSymbols) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            return [NSString stringWithFormat:@"%@只能包含字母和数字", title];
        }
    }
    
    return nil;
}

+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
            spacesAllowed:(BOOL)spacesAllowed
                pureChars:(BOOL)pureChars
                 pureNums:(BOOL)pureNums
                     name:(NSString *)name {
    JXInputManagerVerify verify = [[self class] verifyInput:input
                                                      least:least
                                                   original:original
                                              spacesAllowed:spacesAllowed
                                                  pureChars:pureChars
                                                   pureNums:pureNums];
    NSString *result = nil;
    switch (verify) {
        case JXInputManagerVerifyNeed:
            result = [NSString stringWithFormat:@"%@不能为空", name];
            break;
        case JXInputManagerVerifyWhitespaceLT:
            result = [NSString stringWithFormat:@"%@首尾不能包含空白字符", name];
            break;
        case JXInputManagerVerifyWhitespaceAll:
            result = [NSString stringWithFormat:@"%@不能全为空白字符", name];
            break;
        case JXInputManagerVerifyPureChars:
            result = [NSString stringWithFormat:@"%@只能包含英文字符", name];
            break;
        case JXInputManagerVerifyPureNums:
            result = [NSString stringWithFormat:@"%@只能包含数字", name];
            break;
        case JXInputManagerVerifyPureASCII:
            result = [NSString stringWithFormat:@"%@只能包含英文和数字", name];
            break;
        case JXInputManagerVerifyLeast:
            result = [NSString stringWithFormat:@"%@至少为%@位", name, @(least)];
            break;
        case JXInputManagerVerifySame:
            result = [NSString stringWithFormat:@"请输入与原%@不一样的新%@", name, name];
            break;
        default:
            break;
    }
    return result;
}

+ (JXInputManagerVerify)verifyInput:(NSString *)input
                              least:(NSInteger)least
                           original:(NSString *)original
                      spacesAllowed:(BOOL)spacesAllowed
                          pureChars:(BOOL)pureChars
                           pureNums:(BOOL)pureNums {
    // 不能为空
    if (0 == input.length) {
        return JXInputManagerVerifyNeed;
    }
    
    // 首尾不能包含空白字符
    if (!spacesAllowed && (input.length >= 1)) {
        NSString *first = [input substringToIndex:1];
        NSString *last = [input substringFromIndex:(input.length - 1)];
        NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSRange range = [first rangeOfCharacterFromSet:wnSet];
        if (range.location != NSNotFound) {
            return JXInputManagerVerifyWhitespaceLT;
        }
        
        range = [last rangeOfCharacterFromSet:wnSet];
        if (range.location != NSNotFound) {
            return JXInputManagerVerifyWhitespaceLT;
        }
    }
    
    // 输入不能全为空白字符
    NSString *pure = [input exTrim];
    if (0 == pure.length) {
        return JXInputManagerVerifyWhitespaceAll;
    }
    
    // 纯英文
    if (pureChars && !pureNums) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            return JXInputManagerVerifyPureChars;
        }
    }
    
    // 纯数字
    if (!pureChars && pureNums) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            return JXInputManagerVerifyPureChars;
        }
    }
    
    // 纯英文+数字
    if (pureChars && pureNums) {
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
        if (range.location != NSNotFound) {
            return JXInputManagerVerifyPureChars;
        }
    }
    
    // 至少输入
    if (input.length < least) {
        return JXInputManagerVerifyLeast;
    }
    
    // 不能相同
    if ([pure isEqualToString:[original exTrim]]) {
        return JXInputManagerVerifySame;
    }
    
    return JXInputManagerVerifyNone;
}

+ (NSString *)verifyPhoneNumber:(NSString *)phoneNumber original:(NSString *)original {
    if (0 == phoneNumber.length) {
        return kStringPleaseInputPhoneNumber;
    }
    
    //    NSString *pure = [phoneNumber exTrim];
    //    if (0 == pure.length) {
    //        return [NSString stringWithFormat:@"手机号码%@", kStringCantAllWhitespace];
    //    }
    
    if (kJXMetricPhoneNumber != phoneNumber.length) {
        return kStringPhoneNumberMustBe11Count;
    }
    
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange range = [phoneNumber rangeOfCharacterFromSet:allowedCharacters];
    if (range.location != NSNotFound) {
        return kStringPhoneNumberInvalidChar;
    }
    
    if (![phoneNumber hasPrefix:@"1"]) {
        return kStringPhoneNumberFormatError;
    }
    
    if ([phoneNumber isEqualToString:original]) {
        return kStringPhoneNumberNeedNotSame;
    }
    
    return nil;
}
@end

