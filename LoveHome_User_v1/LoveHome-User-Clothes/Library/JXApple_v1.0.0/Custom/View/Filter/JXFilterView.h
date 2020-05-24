//
//  JXFilterView.h
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/25.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXFilterViewCategory.h"
#import "JXFilterViewSelection.h"
#import "JXFilterViewSelectionContentTable.h"

@class JXFilterView;

@protocol JXFilterViewDataSource <NSObject>
@required
- (NSInteger)numberOfCategoriesInFilterView:(JXFilterView *)filterView;
- (JXFilterViewCategory *)filterView:(JXFilterView *)filterView categoryAtIndex:(NSInteger)index;
- (JXFilterViewSelection *)filterView:(JXFilterView *)filterView selectionAtIndex:(NSInteger)index;

@end

@protocol JXFilterViewDelegate <NSObject>
@required
- (void)filterView:(JXFilterView *)filterView
          category:(JXFilterViewCategory *)category
         selection:(JXFilterViewSelection *)selection
             index:(NSInteger)index
            object:(id)object;

@end

@interface JXFilterView : UIView <JXFilterViewCategoryDelegate, JXFilterViewSelectionDelegate>
@property (nonatomic, weak) id<JXFilterViewDataSource> dataSource;
@property (nonatomic, weak) id<JXFilterViewDelegate> delegate;

- (void)reloadData;
@end
