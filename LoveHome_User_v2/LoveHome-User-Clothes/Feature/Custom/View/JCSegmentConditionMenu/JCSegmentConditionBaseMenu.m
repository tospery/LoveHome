//
//  JCSegmentConditionMenu.m
//  LoveHome
//
//  Created by Joe Chen on 15/2/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentConditionBaseMenu.h"
#import <Availability.h>

@interface JCSegmentConditionBaseMenu()

//布局
//显示下拉菜单
@property (strong, nonatomic)  UIView       *showFilterContentRootView;
@property (strong, nonatomic)  UIView       *showFilierContentBackgroudView;
@property (strong, nonatomic)  UIView       *mySegmentShieldingView;  //屏蔽层（在用户点击后，动画还没有结束，不允许再点击）
@property (strong, nonatomic)  UIView       *controlContentAnimationView; //内容展示动画控制层


//布局层存储容器
@property (strong, nonatomic) NSMutableArray *childViewArray;
@property (nonatomic          ) NSInteger                       currentSelectedIndex; //内部使用的，当前选择的menuIndex


/*!
 *  @brief  获取segmentMenu的itemNumber
 *
 *  @param segmentConditionMenu
 *
 *  @return NSUInteger
 */
- (NSUInteger)get_NumberOfSegmentConditionMenu;


/*!
 *  @brief  获取segmentMenu的contentView
 *
 *  @param segmentConditionMenu
 *  @param index
 *
 *  @return JCSegmentMenuBaseItemView
 */
- (JCSegmentMenuBaseItemView *)get_BaseItemViewForSegmentAtIndex:(NSUInteger)index;


/*!
 *  @brief  获取内容展示层的高度
 *
 *  @return CGFloat
 */
- (CGFloat)get_heightOfContentViewWithIndex:(NSInteger)index;


@end

@implementation JCSegmentConditionBaseMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _childViewArray           = [[NSMutableArray alloc] initWithCapacity:1];
        _currentSelectedIndex     = -1;
        _currentSelectedMenuIndex = 0;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self initItemContentView];
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    if (currentSelectedIndex >= 0)
    {
        if (_currentSelectedIndex != currentSelectedIndex)
        {
            if (_childViewArray && [_childViewArray count] > 0)
            {
                if (_currentSelectedIndex >= 0)
                {
                    JCSegmentMenuBaseItemView *oldBaseItemView = [_childViewArray objectAtIndex:_currentSelectedIndex];
                    [oldBaseItemView setSelected:NO];
                }
            }
            
            _currentSelectedIndex = currentSelectedIndex;
            
            
            if (_childViewArray && [_childViewArray count] > 0)
            {
                JCSegmentMenuBaseItemView *newBaseItemView = [_childViewArray objectAtIndex:_currentSelectedIndex];
                [newBaseItemView setSelected:YES];
            }
        }else
        {
            if (_childViewArray && [_childViewArray count] > 0)
            {
                JCSegmentMenuBaseItemView *newBaseItemView = [_childViewArray objectAtIndex:_currentSelectedIndex];
                
                BOOL isSelect = newBaseItemView.isSelected;
                
                [newBaseItemView setSelected:!isSelect];

                if (isSelect)
                {
                    _currentSelectedIndex = -1;
                }
            }
        }
    }
}


#pragma mark - PrivateMethods
/*!
 *  @brief  初始化contentView
 */
- (void)initItemContentView
{
    //移除contentView
    [self removeAllContentView];
    
    //安装contentView
    NSUInteger count = [self get_NumberOfSegmentConditionMenu];
    
    CGFloat itemWidth = self.bounds.size.width/count;
    
    for (int i=0; i<count; i++)
    {
        JCSegmentMenuBaseItemView *itemView = [self get_BaseItemViewForSegmentAtIndex:i];
        [itemView setBackgroundColor:[UIColor clearColor]];
        itemView.index                      = i;
        itemView.delegate                   = self;
        itemView.frame                      = CGRectMake(itemWidth*i, 0.5f,itemWidth, self.bounds.size.height-0.5f);
        [self addSubview:itemView];
        
        [_childViewArray addObject:itemView];
    }
    
    //安装中间间隔线
    [self initMiddleSeperateLineView:count andItemWidth:itemWidth];
    
    //安装上下分割线
    [self initTopAndBottomSeperateLineView];
    
    //安装contentView
    [self initFliterContentView];
    
    //初始化用户行为控制屏蔽层
    _mySegmentShieldingView                 = [[UIView alloc] initWithFrame:self.bounds];
    _mySegmentShieldingView.backgroundColor = [UIColor clearColor];
    _mySegmentShieldingView.hidden          = YES;
    [self addSubview:_mySegmentShieldingView];
}


/*!
 *  @brief  初始化筛选内容
 */
- (void)initFliterContentView
{
    if (_showFilterContentRootView == nil)
    {
        //显示filter内容的底层view
        //_targetObject.view.bounds.size.height-self.bounds.size.height-self.frame.origin.y
        _showFilterContentRootView                      = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
        _showFilterContentRootView.backgroundColor      = [UIColor clearColor];
        _showFilterContentRootView.hidden               = YES;
        [_targetObject.view addSubview:_showFilterContentRootView];

        //内容背景层
        _showFilierContentBackgroudView                 = [[UIView alloc] initWithFrame:_showFilterContentRootView.bounds];
        _showFilierContentBackgroudView.backgroundColor = [UIColor blackColor];
        _showFilierContentBackgroudView.alpha           = 0.7f;
        [_showFilterContentRootView addSubview:_showFilierContentBackgroudView];
  
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            _showFilierContentBackgroudView.alpha           = 1.0f;
            _showFilierContentBackgroudView.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect       *blurEffectObject = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffectObject];
            visualEffectView.alpha = 0.8f;
            visualEffectView.frame               = _showFilierContentBackgroudView.bounds;
            [_showFilierContentBackgroudView addSubview:visualEffectView];
        }
#endif
        
        

        //内容动画控制层
        CGFloat contentHeight                           = [self get_heightOfContentViewWithIndex:0];
        
        _controlContentAnimationView                    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _showFilterContentRootView.bounds.size.width, 0.0f)];
        _controlContentAnimationView.backgroundColor    = [UIColor whiteColor];
        _controlContentAnimationView.clipsToBounds      = YES;
        [_showFilterContentRootView addSubview:_controlContentAnimationView];
        
        //内容展示层
        _showContentView                                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _showFilterContentRootView.bounds.size.width, contentHeight)];
        _showContentView.backgroundColor                = [UIColor whiteColor];
        _showContentView.clipsToBounds                  = YES;
        [_controlContentAnimationView addSubview:_showContentView];

        //添加半透层点击事件
        UITapGestureRecognizer *gesture                 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFilterRootViewAction)];
        [_showFilierContentBackgroudView addGestureRecognizer:gesture];
    }
}

/*!
 *  @brief  初始化中间分割线
 */
- (void)initMiddleSeperateLineView:(NSUInteger)count andItemWidth:(CGFloat)width
{
    if (count < 2)
    {
        return;
    }
    
    NSUInteger lineCount  = count-1;
    CGFloat    lineWidth  = 0.5f;
    UIColor    *lineColor = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];
    
    for (int i=0; i<lineCount; i++)
    {
        UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(width*(i+1),10.0f,lineWidth, self.bounds.size.height-20.0f)];
        middleLineView.backgroundColor = lineColor;
        [self addSubview:middleLineView];
    }
}

/*!
 *  @brief  初始化上下分割线
 */
- (void)initTopAndBottomSeperateLineView
{
    CGFloat lineHeight             = 0.5f;
    UIColor *lineColor             = [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0];

    //top
    UIView *topLineView            = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f, self.bounds.size.width, 0.5f)];
    topLineView.backgroundColor    = lineColor;
//    [self addSubview:topLineView];

    //bottom
    UIView *bottomLineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-lineHeight, self.bounds.size.width, lineHeight)];
    bottomLineView.backgroundColor = lineColor;
    [self addSubview:bottomLineView];
}


/*!
 *  @brief  刷新数据
 */
- (void)reloadView
{
    [self initItemContentView];
}


/*!
 *  @brief  获取menuItemView（分段菜单栏item）
 *
 *  @param index
 *
 *  @return JCSegmentMenuBaseItemView
 */
- (JCSegmentMenuBaseItemView *)menuItemViewForMenuViewAtIndex:(NSInteger)index
{
    if ((_childViewArray) && ([_childViewArray count] > 0) && (index < ([_childViewArray count])))
    {
        return [_childViewArray objectAtIndex:index];
    }
    return nil;
}


/*!
 *  @brief  隐藏内容层
 *
 *  @param isAnimation 是否动画
 */
- (void)hiddenContentViewWithAnimation:(BOOL)isAnimation
{
    if (isAnimation)
    {
        [self controlShowFilterDataTableViewIsShow:NO andCurrentIndex:_currentSelectedIndex];
    }else
    {
        [self resetContentViewFrame];
    }
    
    [self resetSegmentConditionMenuState];
}


/*!
 *  @brief  获取内容显示层的size
 *
 *  @return CGSize
 */
- (CGSize)getContentViewSizeWithIndex:(NSInteger)index
{
    CGFloat height = [self get_heightOfContentViewWithIndex:index];
    return CGSizeMake(_showContentView.bounds.size.width, height);
}


/*!
 *  @brief  移除所有ContentView
 */
- (void)removeAllContentView
{
    if (_childViewArray && [_childViewArray count] > 0)
    {
        [_childViewArray removeAllObjects];
    }
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}


/*!
 *  @brief  隐藏内容展示层
 */
- (void)cancelFilterRootViewAction
{
    [self controlShowFilterDataTableViewIsShow:NO andCurrentIndex:_currentSelectedIndex];
    
    [self resetSegmentConditionMenuState];
}


/*!
 *  @brief  重置内容展示层的frame
 */
- (void)resetContentViewFrame
{
    CGRect showFilterContentViewFrame      = _controlContentAnimationView.frame;
    showFilterContentViewFrame.size.height = 0.0f;
    [_controlContentAnimationView setFrame:showFilterContentViewFrame];
    
    
    [_showFilterContentRootView setHidden:YES];
    [_mySegmentShieldingView    setHidden:YES];
}


/*!
 *  @brief  重置SegmentConditionMenu的状态
 */
- (void)resetSegmentConditionMenuState
{
    NSInteger index = _currentSelectedIndex;
    [self setCurrentSelectedIndex:index];
    _currentSelectedIndex = -1;
}

/*!
 *  @brief  获取segmentMenu的itemNumber
 *
 *  @param segmentConditionMenu
 *
 *  @return NSUInteger
 */
- (NSUInteger)get_NumberOfSegmentConditionMenu
{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfSegmentConditionMenu:)])
    {
        return [_delegate numberOfSegmentConditionMenu:self];
    }else
    {
        NSAssert(1, @"没有实现此代理: numberOfSegmentConditionMenu");
    }
    return 0;
}


/*!
 *  @brief  获取segmentMenu的contentView
 *
 *  @param segmentConditionMenu
 *  @param index
 *
 *  @return JCSegmentMenuBaseItemView
 */
- (JCSegmentMenuBaseItemView *)get_BaseItemViewForSegmentAtIndex:(NSUInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentConditionMenu:baseItemViewForSegmentAtIndex:)])
    {
        return [_delegate segmentConditionMenu:self baseItemViewForSegmentAtIndex:index];
    }else
    {
        NSAssert(1, @"没有实现此代理: segmentConditionMenu:baseItemViewForSegmentAtIndex:");
    }
    return nil;
}


/*!
 *  @brief  获取内容展示层的高度
 *
 *  @return CGFloat
 */
- (CGFloat)get_heightOfContentViewWithIndex:(NSInteger)index
{
    CGFloat height        = 0.0f;
    CGFloat defaultHeight = _showFilterContentRootView.bounds.size.height-150.0f;
    
    if (_delegate && [_delegate respondsToSelector:@selector(heightOfSegmentConditionMenuContentView:atMenuItemIndex:)])
    {
        height = [_delegate heightOfSegmentConditionMenuContentView:self atMenuItemIndex:index];
    }
    
    //如果没有设置内容层的高度或超过了默认的最大高度，默认设置为当前targetObject的view的高度减150.0f
    if (height <= 0.0f || height > defaultHeight)
    {
        height =  defaultHeight;
    }
    
    return height;
}


#pragma mark - JCSegmentMenuBaseItemViewDelegate
- (void)segmentMenuBaseItemView:(JCSegmentMenuBaseItemView *)itemView didClickedItem:(NSUInteger)index
{
    [_mySegmentShieldingView setHidden:NO];
        
    //点击新的item后
    [self controlShowFilterDataTableViewIsShow:((index != _currentSelectedIndex)?YES:NO)
                               andCurrentIndex:index];
    [self setCurrentSelectedIndex:index];
    
    _currentSelectedMenuIndex = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(segmentConditionMenu:didSelectMenuItemAtIndex:)])
    {
        [_delegate segmentConditionMenu:self didSelectMenuItemAtIndex:index];
    }
}


#pragma mark 控制显示筛选内容tableview的动画显示
- (void)controlShowFilterDataTableViewIsShow:(BOOL)isShow andCurrentIndex:(NSInteger)index
{
    //如果当前是显示状态，就不用再设置tableview的显示了
    if (isShow)
    {
        if (!_showFilterContentRootView.isHidden)
        {
            CGRect showFilterContentViewFrame      = _controlContentAnimationView.frame;
            showFilterContentViewFrame.size.height = 0.0f;
            [_controlContentAnimationView setFrame:showFilterContentViewFrame];
            _showFilterContentRootView.alpha       = 0.0f;
            [_showFilterContentRootView setHidden:YES];
        }
    }
    
    //允许显示
    if (isShow)
    {
        [_showFilterContentRootView setHidden:!isShow];
        [_showFilterContentRootView setAlpha:1.0f];
        
        CGFloat contentViewHeight = [self get_heightOfContentViewWithIndex:index];
        
        //强制设置shwoContentView的大小
        CGRect showContentViewFrame            = _showContentView.frame;
        showContentViewFrame.size.height       = contentViewHeight;
        [_showContentView setFrame:showContentViewFrame];
        
        [UIView animateWithDuration:0.2f animations:^(void)
         {
             CGRect showFilterContentViewFrame      = _controlContentAnimationView.frame;
             showFilterContentViewFrame.size.height = contentViewHeight;
             [_controlContentAnimationView setFrame:showFilterContentViewFrame];
         }
                         completion:^(BOOL finish){
                             [_mySegmentShieldingView setHidden:YES];
                         }];
    }else
    {
        [UIView animateWithDuration:0.2f
                         animations:^(void)
         {
             CGRect showFilterContentViewFrame      = _controlContentAnimationView.frame;
             showFilterContentViewFrame.size.height = 0.0f;
             [_controlContentAnimationView setFrame:showFilterContentViewFrame];
             
         }
                         completion:^(BOOL finish)
         {
             [UIView animateWithDuration:0.2f
                              animations:^(void){
                                  _showFilterContentRootView.alpha = 0.0f;
                              }
                              completion:^(BOOL finish){
                                  
                                  [_showFilterContentRootView setHidden:YES];
                                  [_mySegmentShieldingView setHidden:YES];

                              }];
             
         }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
