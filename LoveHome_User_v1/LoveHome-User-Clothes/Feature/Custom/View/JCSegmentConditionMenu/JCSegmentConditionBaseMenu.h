//
//  JCSegmentConditionMenu.h
//  LoveHome
//
//  Created by Joe Chen on 15/2/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSegmentMenuBaseItemView.h"

@protocol JCSegmentConditionMenuDeleagate;
@interface JCSegmentConditionBaseMenu : UIView<JCSegmentMenuBaseItemViewDelegate>

@property (assign, nonatomic  ) id<JCSegmentConditionMenuDeleagate> delegate;
@property (nonatomic          ) NSInteger                       currentSelectedMenuIndex;  //当前选择的菜单index值，默认是从0开始
@property (strong, nonatomic  ) UIViewController                *targetObject;
@property (readonly, nonatomic) UIView                          *showContentView;


/*!
 *  @brief  刷新数据
 */
- (void)reloadView;


/*!
 *  @brief  获取menuItemView（分段菜单栏item）
 *
 *  @param index
 *
 *  @return JCSegmentMenuBaseItemView
 */
- (JCSegmentMenuBaseItemView *)menuItemViewForMenuViewAtIndex:(NSInteger)index;


/*!
 *  @brief  隐藏内容层
 *
 *  @param isAnimation 是否动画
 */
- (void)hiddenContentViewWithAnimation:(BOOL)isAnimation;


/*!
 *  @brief  获取内容显示层的size
 *
 *  @return CGSize
 */
- (CGSize)getContentViewSizeWithIndex:(NSInteger)index;

@end


/*!
 *  @brief  数据设置和用户响应相关的代理
 */
@protocol JCSegmentConditionMenuDeleagate <NSObject>

@required
/*!
 *  @brief  设置segmentMenu的数量
 *
 *  @param segmentConditionMenu
 *
 *  @return NSUInteger
 */
- (NSUInteger)numberOfSegmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu NS_AVAILABLE_IOS(6_0);


/*!
 *  @brief  设置segmentMenu的contentView
 *
 *  @param segmentConditionMenu
 *  @param index
 *
 *  @return JCSegmentMenuBaseItemView
 */
- (JCSegmentMenuBaseItemView *)segmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu baseItemViewForSegmentAtIndex:(NSUInteger)index NS_AVAILABLE_IOS(6_0);

@optional
/*!
 *  @brief  筛选内容展示层的高度(默认是屏幕内容展示高度-150.0f)
 *
 *  @param segmentConditionMenu
 *
 *  @return CGFloat
 */
- (CGFloat)heightOfSegmentConditionMenuContentView:(JCSegmentConditionBaseMenu *)segmentConditionMenu atMenuItemIndex:(NSUInteger)index;


/*!
 *  @brief  点击menuItem的回调
 *
 *  @param segmentConditionMenu
 *  @param index
 */
- (void)segmentConditionMenu:(JCSegmentConditionBaseMenu *)segmentConditionMenu didSelectMenuItemAtIndex:(NSUInteger)index;


/*!
 *  @brief  设置内容显示层的数据源
 *
 *  @param segmentConditionMenu
 *  @param index
 *
 *  @return NSArray
 */
- (NSArray *)dataOfSegmentConditionMenuContentView:(JCSegmentConditionBaseMenu *)segmentConditionMenu atMenuItemIndex:(NSUInteger)index;



@end