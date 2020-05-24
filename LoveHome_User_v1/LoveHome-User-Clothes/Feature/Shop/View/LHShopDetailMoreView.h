//
//  LHShopDetailMoreView.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/14.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHSpecify.h"

typedef void(^LHShopDetailMoreViewSelectBlock)(LHProduct *product, LHSpecify *specify, BOOL select);
typedef void(^LHShopDetailMoreViewCloseBlock)();

@interface LHShopDetailMoreView : UIView
@property (nonatomic, assign) BOOL isOutOfService;
@property (nonatomic, strong) LHProduct *product;
//@property (nonatomic, strong) NSArray *products;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UIView *allView;

- (void)setupSelectBlock:(LHShopDetailMoreViewSelectBlock)selectBlock
              closeBlock:(LHShopDetailMoreViewCloseBlock)closeBlock;
@end
