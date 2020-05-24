//
//  MMDrawerController+JXApple.h
//  TianlongHome
//
//  Created by 杨建祥 on 15/4/26.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMMDrawerController
#import "MMDrawerController.h"

@interface MMDrawerController (JXApple)
+ (MMDrawerController *)exDrawerControllerWithCenterVC:(UIViewController *)centerVC
                                                leftVC:(UIViewController *)leftVC
                                               rightVC:(UIViewController *)rightVC
                                             leftWidth:(CGFloat)leftWidth
                                            rightWidth:(CGFloat)rightWidth;
@end
#endif