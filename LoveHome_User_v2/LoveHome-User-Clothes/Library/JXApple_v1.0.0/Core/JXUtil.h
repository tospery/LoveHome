//
//  JXUtil.h
//  LoveHome-User
//
//  Created by 杨建祥 on 15/7/3.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

void JXDownloadImage(NSString *urlString, UIImage *placeholderImage, UIImageView *imageView);

BOOL JXJudgeContainerIsEmptyOrNull(id container);

UIBarButtonItem * JXCreateLeftBarItem(id target);

NSArray * JXAllPropertyFromClass(NSObject* className);
NSString * JXBuildFilepathInDocument(NSString *pathComponent);