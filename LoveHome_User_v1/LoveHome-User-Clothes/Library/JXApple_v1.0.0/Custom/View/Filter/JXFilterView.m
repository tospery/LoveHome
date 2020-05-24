//
//  JXFilterView.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/25.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import "JXFilterView.h"

@interface JXFilterView ()
@property (nonatomic, strong) NSArray *categories;
@end

@implementation JXFilterView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    JXLogDebug(@"aaaaaaaa");
//    [super willMoveToSuperview:newSuperview];
//    [self reloadData];
//}

- (void)updateConstraints {
    JXLogDebug(@"aaaaaaaa");
    [self reloadData];
    
    [super updateConstraints];
}

#pragma mark - Private methods
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)reloadData {
    NSInteger categoryCount = [self get_numberOfCategories];
    if (categoryCount <= 0) {
        return;
    }
    
    [self removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5f);
    }];
    
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:categoryCount];
    for (int i = 0; i < categoryCount; ++i) {
        BOOL isLast = (i == (categoryCount - 1));
        JXFilterViewCategory *category = [self get_categoryAtIndex:i];
        category.tag = i;
        category.delegate = self;
        [self addSubview:category];
        [category mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-0.5f);
            make.width.equalTo(self).dividedBy(categoryCount).offset(isLast ? 0 : -0.5f);
            make.centerX.equalTo(self.mas_centerX).multipliedBy((i * 2 + 1) / (CGFloat)categoryCount).offset(isLast ? 0 : -0.5f);
        }];
        
        if (!isLast) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
            [self addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(category.mas_trailing);
                make.top.equalTo(self).offset(12);
                make.bottom.equalTo(self).offset(-12);
                make.width.equalTo(@0.5f);
            }];
        }
        
        [categories addObject:category];
    }
    _categories = categories;
}

#pragma mark implement
- (NSInteger)get_numberOfCategories {
    if ([_dataSource respondsToSelector:@selector(numberOfCategoriesInFilterView:)]) {
        return [_dataSource numberOfCategoriesInFilterView:self];
    }
    
    return 0;
}

- (JXFilterViewCategory *)get_categoryAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(filterView:categoryAtIndex:)]) {
        return [_dataSource filterView:self categoryAtIndex:index];
    }
    
    return nil;
}

- (JXFilterViewSelection *)get_selectionAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(filterView:selectionAtIndex:)]) {
        return [_dataSource filterView:self selectionAtIndex:index];
    }
    
    return nil;
}

#pragma mark assist
- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)resetAllSelectionExcept:(NSInteger)index{
    NSInteger categoryCount = [self get_numberOfCategories];
    for (int i = 0; i < categoryCount; ++i) {
        if (i == index) {
            continue;
        }
        
        JXFilterViewCategory *category = [_categories objectAtIndex:i];
        if (category.actionButton.selected) {
            category.actionButton.selected = NO;
            [self rotateCategory:category begin:NO];
        }
        
        JXFilterViewSelection *selection = (JXFilterViewSelection *)[self.superview viewWithTag:(JXFilterViewTagBegin + i)];
        if (selection) {
            CGFloat contentHeight = selection.contentView.frame.size.height;
            selection.contentView.frame = CGRectMake(0, -contentHeight, kJXScreenWidth, contentHeight);
            selection.alpha = 0.0f;
            selection.hidden = YES;
            selection.isAnimating = NO;
        }
    }
}

//- (void)rotateCategory:(JXFilterViewCategory *)category
//                  start:(BOOL)start {
//    CGAffineTransform transform;
//    if (start) {
//        transform = CGAffineTransformRotate(indicator.transform, M_PI);
//    }else {
//        transform = CGAffineTransformRotate(indicator.transform, M_PI * -3);
//    }
//    [UIView beginAnimations:@"JXFilterViewCategory-AnimRotate" context:nil];
//    [UIView setAnimationDuration:0.25];
//    [indicator setTransform:transform];
//    [UIView commitAnimations];
//}

- (void)rotateCategory:(JXFilterViewCategory *)category begin:(BOOL)begin {
    NSValue *value;
    if (begin) {
        value = @(M_PI * 1);
    }else {
        value = @0;
    }
    
    POPSpringAnimation *anim = [category.indicatorImageView.layer pop_animationForKey:@"rotate"];
    if (!anim) {
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        anim.springSpeed = 12;
        anim.springBounciness = 1;
        anim.toValue = value;
        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                category.isAnimating = NO;
            }
        }];
        [category.indicatorImageView.layer pop_addAnimation:anim forKey:@"rotate"];
    }else {
        anim.toValue = value;
    }
}


#pragma mark - Delegate methods
#pragma mark JXFilterViewCategoryDelegate
- (void)filterViewCategory:(JXFilterViewCategory *)category
            didSelectIndex:(NSInteger)index {
    [self resetAllSelectionExcept:index];
    
    UIView *view = [self.superview viewWithTag:(JXFilterViewTagBegin + index)];
    if (view && ![view isKindOfClass:[JXFilterViewSelection class]]) {
        return;
    }
    JXFilterViewSelection *selection;
    if (view) {
        selection = (JXFilterViewSelection *)view;
    }else {
        selection = [self get_selectionAtIndex:index];
        selection.delegate = self;
        selection.contentView.delegate = self;
        selection.tag = JXFilterViewTagBegin + index;
        selection.hidden = YES;
        [self.superview addSubview:selection];
        [self.superview bringSubviewToFront:self];
    }
    
    if (selection.isAnimating) {
        return;
    }
    
    CGFloat contentHeight = selection.contentView.frame.size.height;
    selection.isAnimating = YES;
    selection.frame = CGRectMake(0, CGRectGetMaxY(self.frame), kJXScreenWidth, kJXScreenHeight);
    if (selection.hidden) {
        [self rotateCategory:category begin:YES];
        
        selection.hidden = NO;
        selection.alpha = 1.0f;
        selection.contentView.frame = CGRectMake(0, -contentHeight, kJXScreenWidth, contentHeight);
        [UIView animateWithDuration:0.25 animations:^{
            selection.contentView.frame = CGRectMake(0, 0, kJXScreenWidth, contentHeight);
        } completion:^(BOOL finished) {
            selection.isAnimating = NO;
        }];
    }else {
        [self rotateCategory:category begin:NO];
        
        [UIView animateWithDuration:0.25 animations:^{
            selection.contentView.frame = CGRectMake(0, -contentHeight, kJXScreenWidth, contentHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                selection.alpha = 0.0f;
            } completion:^(BOOL finished) {
                selection.hidden = YES;
                selection.isAnimating = NO;
            }];
        }];
    }
}

#pragma mark JXFilterViewSelectionDelegate
- (void)filterViewSelection:(JXFilterViewSelection *)selection
             didSelectIndex:(NSInteger)index
                 withObject:(id)obj {
    JXFilterViewCategory *category = [_categories objectAtIndex:index];
    if (category.isAnimating || !category.actionButton.selected) {
        return;
    }
    
    if (category.actionButton.selected) {
        category.actionButton.selected = NO;
        [self rotateCategory:category begin:NO];
    }
    
    category.isAnimating = YES;
    CGFloat contentHeight = selection.contentView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        selection.contentView.frame = CGRectMake(0, -contentHeight, kJXScreenWidth, contentHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            selection.alpha = 0.0f;
        } completion:^(BOOL finished) {
            selection.hidden = YES;
            selection.isAnimating = NO;
        }];
    }];
    
    if (obj) {
        if ([_delegate respondsToSelector:@selector(filterView:category:selection:index:object:)]) {
            [_delegate filterView:self category:category selection:selection index:index object:obj];
        }
    }
}

@end

















