//
//  JXTermView.h
//  MyVBFPopFlatButton
//
//  Created by 杨建祥 on 15/4/6.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableVBFPopFlatButton
#import <UIKit/UIKit.h>

@interface JXTermView : UIView
@property (nonatomic, assign) BOOL checked;

- (void)configColor:(UIColor *)color;
@end
#endif