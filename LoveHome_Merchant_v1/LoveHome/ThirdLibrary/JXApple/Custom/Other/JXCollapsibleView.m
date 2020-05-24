//
//  JXCollapsibleView.m
//  MyiOS
//
//  Created by Thundersoft on 14/12/10.
//  Copyright (c) 2014年 Thundersoft. All rights reserved.
//

#ifdef JXEnableMasonry
#import "JXCollapsibleView.h"
#import "JXApple.h"
#import "Masonry.h"

#define JXCollapsibleViewButtonEdge         (12)

@interface JXCollapsibleView ()
@property (nonatomic, assign) BOOL isButtonPressed;
@property (nonatomic, assign) CGFloat baseHeight;
@property (nonatomic, assign) CGFloat matchHeight;

@property (nonatomic, assign) JXCollapsibleViewMode mode;
@property (nonatomic, assign) CGFloat               textWidth;
@property (nonatomic, assign) NSInteger             lines;
@property (nonatomic, assign) NSTextAlignment       textAlignment;
@property (nonatomic, strong) UIFont                *font;
@property (nonatomic, strong) UIColor               *textColor;
@property (nonatomic, strong) UIColor               *arrowColor;

@property (nonatomic, strong) void (^pressedBlock)(JXCollapsibleViewMode mode);
@end

@implementation JXCollapsibleView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupVariables];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setupVariables];
        [self setupSubviews];
    }
    return self;
}

- (void)updateConstraints {
    if (_isButtonPressed) {
        if (_text.length > 0){
            if (JXCollapsibleViewModeClose == _mode) {
                _mode = JXCollapsibleViewModeOpen;
                _textWidth = self.bounds.size.width - kJXMetricStandardPadding * 2 - JXCollapsibleViewButtonEdge;
                CGSize requiredSize = [_text exSizeWithFont:_font width:_textWidth];
                _matchHeight = requiredSize.height + kJXMetricStandardPadding;
            }else if (JXCollapsibleViewModeOpen == _mode) {
                _mode = JXCollapsibleViewModeClose;
                _matchHeight = _baseHeight * _lines + kJXMetricStandardPadding;
            }
        }else {
            _matchHeight = 0;
        }
    }else {
        if (_text.length > 0) {
            _textWidth = self.bounds.size.width - kJXMetricStandardPadding * 2 - JXCollapsibleViewButtonEdge;
            CGSize requiredSize = [_text exSizeWithFont:_font width:_textWidth + JXCollapsibleViewButtonEdge];
            if (requiredSize.height > _baseHeight * _lines) {
                _mode = JXCollapsibleViewModeClose;
                _matchHeight = _baseHeight * _lines + kJXMetricStandardPadding;
            }else {
                _mode = JXCollapsibleViewModeBase;
                _matchHeight = requiredSize.height + kJXMetricStandardPadding;
            }
        }else {
            _matchHeight = 0;
        }
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:_matchHeight]).priorityHigh();
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_text.length > 0) {
        [_textColor set];
        
        CGFloat textWidth = _textWidth;
        if (JXCollapsibleViewModeBase == _mode) {
            textWidth = _textWidth + JXCollapsibleViewButtonEdge;
        }
        CGRect textFrame = CGRectMake(kJXMetricStandardPadding,
                                      kJXMetricStandardPadding / 2.0,
                                      textWidth,
                                      _matchHeight - kJXMetricStandardPadding / 2.0);
        
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.alignment = _textAlignment;
        textParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        if ([_text respondsToSelector:@selector(drawWithRect:options:attributes:context:)]) {
            [_text drawWithRect:textFrame
                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                     attributes:@{NSFontAttributeName: _font,
                                  NSParagraphStyleAttributeName: textParagraphStyle,
                                  NSForegroundColorAttributeName: _textColor}
                        context:nil];
        }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [_text drawInRect:textFrame
                     withFont:_font
                lineBreakMode:NSLineBreakByWordWrapping
                    alignment:_textAlignment];
#pragma clang diagnostic pop
        }
        if (JXCollapsibleViewModeBase != _mode) {
            [_arrowColor setFill];
            // YJX_TODO
//            UIBezierPathArrowDirection direction;
//            if (JXCollapsibleViewModeClose == _mode) {
//                direction = kUIBezierPathArrowDirectionDown;
//            }else {
//                direction = kUIBezierPathArrowDirectionUp;
//            }
//            
//            [[UIBezierPath customBezierPathOfArrowSymbolWithRect:CGRectMake(self.bounds.size.width - JXCollapsibleViewButtonEdge - kJXMetricStandardPadding,
//                                                                            self.bounds.size.height - JXCollapsibleViewButtonEdge - kJXMetricStandardPadding,
//                                                                            JXCollapsibleViewButtonEdge,
//                                                                            JXCollapsibleViewButtonEdge)
//                                                           scale:0.9f
//                                                           thick:5.0f
//                                                       direction:direction] fill];
        }
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Private methods
- (void)setupVariables {
    _mode = JXCollapsibleViewModeAuto;
    _textAlignment = NSTextAlignmentLeft;
    _textColor = [UIColor blackColor];
    _arrowColor = [UIColor orangeColor];
    _lines = 2;
    _matchHeight = 0;
    self.font = [UIFont systemFontOfSize:16];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0)).priorityHigh();
    }];
}

- (void)setupSubviews {
    UIButton *fgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fgButton addTarget:self action:@selector(fgButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fgButton];
    [fgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Accessor methods
- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    if ([_font isEqual:font]) {
        return;
    }
    
    _font = font;
    _baseHeight = [kStringOK exSizeWithFont:_font width:UINT16_MAX].height;
}

#pragma mark - Action methods
- (void)fgButtonPressed:(id)sender {
    if (JXCollapsibleViewModeBase == _mode) {
        return;
    }
    
    _isButtonPressed = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0 animations:^{
        [self setNeedsDisplay];
    } completion:^(BOOL finished) {
        _isButtonPressed = NO;
        if (_pressedBlock) {
            _pressedBlock(_mode);
        }
    }];
}

#pragma mark - Public methods
- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines {
    _lines = lines;
    self.font = font;
    self.text = text;
}

- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor arrowColor:(UIColor *)arrowColor {
    _lines = lines;
    _textAlignment = textAlignment;
    _textColor = textColor;
    _arrowColor = arrowColor;
    
    self.font = font;
    self.text = text;
}

- (void)setBlockForPressed:(void (^)(JXCollapsibleViewMode mode))pressedBlock {
    _pressedBlock = pressedBlock;
}
@end
#endif