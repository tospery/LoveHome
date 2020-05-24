//
//  JCSegmentConditionItemView.h
//  LoveHome
//
//  Created by Joe Chen on 15/2/11.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCSegmentMenuBaseItemViewDelegate;
@interface JCSegmentMenuBaseItemView : UIView

@property (nonatomic,assign) id<JCSegmentMenuBaseItemViewDelegate>delegate;
@property (nonatomic,strong)            UILabel    *showTitleLabel;
@property (nonatomic,getter=isSelected) BOOL       selected;
@property (nonatomic,assign)            NSUInteger index;

@end


@protocol JCSegmentMenuBaseItemViewDelegate <NSObject>

@optional
- (void)segmentMenuBaseItemView:(JCSegmentMenuBaseItemView *)itemView didClickedItem:(NSUInteger)index;


@end