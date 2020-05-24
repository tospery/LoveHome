//
//  JXFilterViewSelectionContentTable.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/26.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXFilterViewSelection.h"

@interface JXFilterViewSelectionContentTable : JXFilterViewSelectionContent <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithOptions:(NSArray *)options defaultIndex:(NSInteger)index;

@end
