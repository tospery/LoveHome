//
//  AlphaLableView.h
//  LoveHome
//
//  Created by MRH-MAC on 14/12/4.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlphaLableView : UIView
@property (nonatomic ,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic , strong) NSString *ContentText;
@property (nonatomic ,strong) UILabel *lable;
@end
