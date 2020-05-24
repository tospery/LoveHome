//
//  JXItemViewController.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/26.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#ifdef JXEnableMasonry
#import <UIKit/UIKit.h>

@interface JXItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *items;

@end
#endif