//
//  JCSegmentConditionChildMenu.h
//  LoveHome
//
//  Created by Joe Chen on 15/2/11.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentConditionBaseMenu.h"
#import "JCSegmentMenuChildItemView.h"

@protocol JCSegmentConditionChildMenuDelegate;
@interface JCSegmentConditionChildMenu : JCSegmentConditionBaseMenu

@property (assign, nonatomic) id<JCSegmentConditionChildMenuDelegate>childDelegate;

/*!
 *  @brief  设置分段菜单的标题
 *
 *  @param titleStr
 *  @param index
 */
- (void)setMenuItemTitle:(NSString *)titleStr atIndex:(NSInteger)index;


/*!
 *  @brief  刷新菜单栏item的标题
 *
 *  @param index
 */
- (void)reloadMenuItemTitleAtIndex:(NSInteger)index;

@end


@protocol JCSegmentConditionChildMenuDelegate <NSObject>

@required
/*!
 *  @brief  设置menuItem的默认显示title
 *
 *  @param segmentConditionMenu
 *  @param index
 *
 *  @return NSString
 */
- (NSString *)titleOfSegmentConditionMenu:(JCSegmentConditionChildMenu *)segmentConditionMenu atMenuItemIndex:(NSInteger)index;

@optional
/*!
 *  @brief  点击contentItem的回调
 *
 *  @param segmentConditionMenu
 *  @param columnIndex          栏目index
 *  @param index
 */
- (void)segmentConditionMenu:(JCSegmentConditionChildMenu *)segmentConditionMenu didSelectContentItemAtIndex:(NSUInteger)index;

@end