//
//  AdvertDisplayerView.m
//  AdvertDisplayerView
//
//  Created by Joe Chen on 14/12/9.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "AdvertDisplayerView.h"

static const NSTimeInterval kScrollAnimationDefaultTimeInterval = 5.0;
static const NSInteger      kShowContentCustomViewBaseTag       = 3120;


@interface AdvertDisplayerView()<UIScrollViewDelegate>
{
    NSInteger                   pageCount;   //总数
    NSInteger                   currentPage; //当前显示的页数
}


@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer       *myTimer;     //用于控制 图片自动滑动的定时器
@property (strong, nonatomic) NSArray       *innerDataArray;    //显示的数据源


@end

@implementation AdvertDisplayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        currentPage    = 1;

        _animationTime = kScrollAnimationDefaultTimeInterval;
        
        [self addSubviewsToScrollView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - PerviteMethod
- (void)reloadData
{
    if (!JudgeContainerCountIsNull(_dataArray))
    {
        if (!JudgeContainerCountIsNull(_innerDataArray))
        {
            _innerDataArray = nil;
        }
        
        _innerDataArray = [NSArray arrayWithArray:_dataArray];
    }
    
    if (!JudgeContainerCountIsNull(_innerDataArray))
    {
        currentPage                = 1;
        
        pageCount                  = [_innerDataArray count];
        
        _pageControl.numberOfPages = pageCount;
        _pageControl.currentPage   = 0;
        
        [self loadScrollViewWithCurrentPage:0];

        if (pageCount > 1)
        {
            [_scrollView setScrollEnabled:YES];
            
            [self showAnimation];
        }else
        {
            [_scrollView setScrollEnabled:NO];
        }
    }
}


/*!
 *  @brief  启动动画
 */
- (void)showAnimation
{
    [self openTimeToScrollImageView];
}


/*!
 *  @brief  停止动画
 */
- (void)stopAnimation
{
    if ([_myTimer isValid])
    {
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}


/*!
 *  @brief  启动定时自动滑动图片
 */
- (void)openTimeToScrollImageView
{
    if ([_myTimer isValid])
    {
        [_myTimer invalidate];
        _myTimer = nil;
    }
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_animationTime target:self selector:@selector(pagecontorlAction) userInfo:nil repeats:YES];
}


- (void)pagecontorlAction
{

    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*2.0f, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}


/*!
 *  @brief  初始化视图层
 */
- (void)addSubviewsToScrollView
{
    //添加根滑动控制器
    _scrollView               = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate      = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.contentSize   = CGSizeMake(self.bounds.size.width*3.0f, self.bounds.size.height);
    [self addSubview:_scrollView];
    
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);

    
    //添加显示内容的view层
    for (int i=0; i<3; i++)
    {
        UIImageView *customContentView         = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        customContentView.tag             = kShowContentCustomViewBaseTag+i;
        customContentView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:customContentView];
        
    }
    
    
    //添加分页指示器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25.0f, self.bounds.size.width, 25.0f)];
    [self addSubview:_pageControl];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(buttonAction:)];
    
    [_scrollView addGestureRecognizer:tapGesture];
}


- (void)buttonAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(advertDisplayerView:didClickedItem:)])
    {
        [_delegate advertDisplayerView:self didClickedItem:currentPage];
    }
}


/*!
 *  @brief  加载数据内容到View
 *
 *  @param page 当前显示的页面
 */
- (void)loadScrollViewWithCurrentPage:(NSInteger)page  //加载某一页的内容
{
    UIImageView *firstPageView  = (UIImageView *)[_scrollView viewWithTag:kShowContentCustomViewBaseTag];
    UIImageView *secondPageView = (UIImageView *)[_scrollView viewWithTag:kShowContentCustomViewBaseTag+1];
    UIImageView *thirdPageView  = (UIImageView *)[_scrollView viewWithTag:kShowContentCustomViewBaseTag+2];
    
    id firstPageImageStr  = @"";
    id secondPageImageStr = @"";
    id thirdPageImageStr  = @"";
    
    if (!JudgeContainerCountIsNull(_innerDataArray))
    {
        if ([_innerDataArray count] > 1)
        {
            if (page == 0)
            {
                firstPageImageStr  = [_innerDataArray lastObject];
                secondPageImageStr = [_innerDataArray objectAtIndex:0];
                thirdPageImageStr  = [_innerDataArray objectAtIndex:1];
                
            }else if(page == (pageCount-1))
            {
                firstPageImageStr  = [_innerDataArray objectAtIndex:pageCount-2];
                secondPageImageStr = [_innerDataArray lastObject];
                thirdPageImageStr  = [_innerDataArray objectAtIndex:0];
                
            }else
            {
                firstPageImageStr  = [_innerDataArray objectAtIndex:page-1];
                secondPageImageStr = [_innerDataArray objectAtIndex:page];
                thirdPageImageStr  = [_innerDataArray objectAtIndex:page+1];
            }
            
            [self loadImageContentWithImageView:firstPageView  andContent:firstPageImageStr];
            [self loadImageContentWithImageView:secondPageView andContent:secondPageImageStr];
            [self loadImageContentWithImageView:thirdPageView  andContent:thirdPageImageStr];
        }else
        {
            secondPageImageStr = [_innerDataArray objectAtIndex:0];
            [self loadImageContentWithImageView:secondPageView andContent:secondPageImageStr];
        }
    }
}


- (void)loadImageContentWithImageView:(UIImageView *)imageView andContent:(id)content
{
    if (imageView && content)
    {
        if ([content isKindOfClass:[UIImage class]])
        {
            [imageView  setImage:(UIImage *)content];
            
        }else if ([content isKindOfClass:[NSString class]])
        {
            [ImageTool downloadImage:content placeholder:[UIImage imageNamed:@"defaultProduct"] imageView:imageView];
        }
    }
}

/*!
 *  @brief  改变PageControl的显示状态
 *
 *  @param page 当前显示的页面
 */
- (void)changePageControlCurrentPage:(NSInteger)page
{
    _pageControl.currentPage = page;
}


/*!
 *  @brief  计算自动滚动下一页将要显示的页数
 *
 *  @param page      当前页数
 *  @param totalPage 总页数
 *
 *  @return 将要显示的下一页
 */
- (NSInteger)caculateAutoScrollNextPageValueWithCurrentPage:(NSInteger)page
                                               andTotalPage:(NSInteger)totalPage
{
    NSInteger newCurrentPage = page;

    newCurrentPage++;
    
    if (newCurrentPage > totalPage)
    {
        newCurrentPage = 1;
    }
    
    return newCurrentPage;
}


/*!
 *  @brief  根据scrollView的偏移量计算当前显示的页面
 *
 *  @param scrollView
 *
 *  @return currentPage
 */
- (NSInteger)caculateCurrentPageValue:(UIScrollView *)scrollView
                         andTotalPage:(NSInteger)totalPage
                       andCurrentPage:(NSInteger)page;
{
    CGFloat pageWidth        = scrollView.bounds.size.width;
    NSInteger newCurrentPage = page;
    
    //滑到一半时，进入前一页 或 后一页。
    
    //向左滑，下一页
    if (scrollView.contentOffset.x > (pageWidth*1.5f))
    {
        newCurrentPage++;
        
        if (newCurrentPage > totalPage)
        {
            newCurrentPage = 1;
        }
        
    }else if(scrollView.contentOffset.x < (pageWidth/2.0f))  //向右滑，上一页
    {
        newCurrentPage--;
        
        if (newCurrentPage < 1)
        {
            newCurrentPage = totalPage;
        }
    }
    
    return newCurrentPage;
}


/*!
 *  @brief  当scrollView停止动画时，设置scrollView的状态
 *
 *  @param scrollView
 */
- (void)setScrollViewSateWhenDidStopedAnimation:(UIScrollView *)scrollView
{
    currentPage = [self caculateCurrentPageValue:scrollView
                                    andTotalPage:pageCount
                                  andCurrentPage:currentPage];
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0.0)];
    
    [self changePageControlCurrentPage:currentPage-1];
    [self loadScrollViewWithCurrentPage:currentPage-1];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        NSInteger newCurrentPage = [self caculateCurrentPageValue:scrollView
                                                     andTotalPage:pageCount
                                                   andCurrentPage:currentPage];
        
        [self changePageControlCurrentPage:newCurrentPage-1];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAnimation];

    [self setScrollViewSateWhenDidStopedAnimation:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        [self showAnimation];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView     // called when scroll view grinds to a halt
{
    
    [self setScrollViewSateWhenDidStopedAnimation:scrollView];
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    [self setScrollViewSateWhenDidStopedAnimation:scrollView];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
