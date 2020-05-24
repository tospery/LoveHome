//
//  JCSegmentConditionChildMenu.m
//  LoveHome
//
//  Created by Joe Chen on 15/2/11.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "JCSegmentConditionChildMenu.h"
#import "JCSegmentConditionTableViewCell.h"


static NSString *const kSegmentMenuTableViewCell_Nomal_Indentifer = @"indentifer";

@interface JCSegmentConditionChildMenu()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView    *myTableView;
@property (strong, nonatomic) NSMutableArray *contentDataArray;     //展开菜单内容数据容器
@property (strong, nonatomic) NSArray        *showContentDataArray; //当前展示的数据容器

@property (nonatomic) NSInteger currentSelectDistanceIndex; //记录当前选择的距离index
@property (nonatomic) NSInteger currentSelectCategoryIndex; //记录当前选择的类别index
@property (nonatomic) NSInteger currentSelectConditionIndex;//记录当前选择的条件index

@end

@implementation JCSegmentConditionChildMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _contentDataArray = [[NSMutableArray alloc] initWithCapacity:1];
        _currentSelectDistanceIndex  = 0;
        _currentSelectCategoryIndex  = 0;
        _currentSelectConditionIndex = 0;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _myTableView            = [[UITableView alloc] initWithFrame:self.showContentView.bounds style:UITableViewStylePlain];
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor whiteColor];
    [self.showContentView addSubview:_myTableView];
    
    
    [_myTableView registerNib:[UINib nibWithNibName:@"JCSegmentConditionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kSegmentMenuTableViewCell_Nomal_Indentifer];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - PrivateMethod
- (void)reloadView
{
    [super reloadView];
    
    [self initContentDataArray];
    
    [_myTableView reloadData];
}


/*!
 *  @brief  初始化content的数据
 */
- (void)initContentDataArray
{
    NSInteger count = [self.delegate numberOfSegmentConditionMenu:self];
    
    for (int i=0; i<count; i++)
    {
        NSArray *itemArray = [self.delegate dataOfSegmentConditionMenuContentView:self atMenuItemIndex:i];
        
        if (itemArray && [itemArray count] > 0)
        {
            [_contentDataArray addObject:itemArray];
        }
    }
}


/*!
 *  @brief  设置分段菜单的标题
 *
 *  @param titleStr
 *  @param index
 */
- (void)setMenuItemTitle:(NSString *)titleStr atIndex:(NSInteger)index
{
    JCSegmentMenuChildItemView *itemView = (JCSegmentMenuChildItemView *)[self menuItemViewForMenuViewAtIndex:index];
    if (itemView && titleStr && [titleStr length] > 0)
    {
        [itemView.showTitleLabel setText:titleStr];
        
        if (index == 1)
        {
            _currentSelectCategoryIndex = [self getIndexOfCurrentSetTitle:titleStr atIndex:index];
        }
    }
}



/*!
 *  @brief 获取当前设置title时，对应的列表里面的index
 *
 *  @param titleStr
 *  @param index
 *
 *  @return index
 */
- (NSInteger)getIndexOfCurrentSetTitle:(NSString *)titleStr atIndex:(NSInteger)index
{
    if (titleStr && [titleStr length] > 0)
    {
        NSArray *itemArray = [self.delegate dataOfSegmentConditionMenuContentView:self atMenuItemIndex:index];
        
        if (itemArray && [itemArray count] > 0)
        {
            for (int i=0; i<[itemArray count]; i++)
            {
                NSString *currentTitleStr = [itemArray objectAtIndex:i];
                if (currentTitleStr && [currentTitleStr length] > 0)
                {
                    if ([currentTitleStr isEqualToString:titleStr])
                    {
                        return i;
                    }
                }
            }
        }
    }
    return 0;
}

/*!
 *  @brief  刷新菜单栏item的标题
 *
 *  @param index
 */
- (void)reloadMenuItemTitleAtIndex:(NSInteger)index
{
    NSString *titleStr = [self getMenuItemTitleIndex:index];
    
    JCSegmentMenuChildItemView *itemView = (JCSegmentMenuChildItemView *)[self menuItemViewForMenuViewAtIndex:index];
    if (itemView && titleStr && [titleStr length] > 0)
    {
        [itemView.showTitleLabel setText:titleStr];
    }
}


/*!
 *  @brief  获取菜单标题
 *
 *  @param index
 *
 *  @return NSString
 */
- (NSString *)getMenuItemTitleIndex:(NSUInteger)index
{
    if (_childDelegate && [_childDelegate respondsToSelector:@selector(titleOfSegmentConditionMenu:atMenuItemIndex:)])
    {
       return [_childDelegate titleOfSegmentConditionMenu:self atMenuItemIndex:index];
    }
    return nil;
}

- (void)updateTableViewFrameWhenClickedIndex:(NSInteger)index
{
    CGSize contentViewSize     = [self getContentViewSizeWithIndex:index];

    CGRect tableViewFrame      = _myTableView.frame;
    tableViewFrame.size.height = contentViewSize.height;
    [_myTableView setFrame:tableViewFrame];
}

#pragma mark - JCSegmentMenuBaseItemViewDelegate
- (void)segmentMenuBaseItemView:(JCSegmentMenuBaseItemView *)itemView didClickedItem:(NSUInteger)index
{
    [self updateTableViewFrameWhenClickedIndex:index];

    [super segmentMenuBaseItemView:itemView didClickedItem:index];
 
    if (_contentDataArray && [_contentDataArray count] > 0)
    {
        _showContentDataArray = [_contentDataArray objectAtIndex:index];

        [_myTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showContentDataArray && [_showContentDataArray count] > 0)
    {
        return [_showContentDataArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCSegmentConditionTableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSegmentMenuTableViewCell_Nomal_Indentifer];
    
    if (_showContentDataArray && [_showContentDataArray count] > 0)
    {
        cell.showTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.showTitleLabel.text = [NSString stringWithFormat:@"%@",[_showContentDataArray objectAtIndex:indexPath.row]];
    }
    
    NSInteger currentSelectCellIndex = -1;
    switch (self.currentSelectedMenuIndex)
    {
        case 0:{
            currentSelectCellIndex = _currentSelectDistanceIndex;
            break;}
        case 1:{
            currentSelectCellIndex = _currentSelectCategoryIndex;
            break;}
        case 2:{
            currentSelectCellIndex = _currentSelectConditionIndex;
            break;}
        default:
            break;
    }
    
    if (currentSelectCellIndex >= 0 && indexPath.row == currentSelectCellIndex)
    {
        [cell setCellStateIsHighlight:YES];
    }else
    {
        [cell setCellStateIsHighlight:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenContentViewWithAnimation:YES];
    
    switch (self.currentSelectedMenuIndex)
    {
        case 0:{
            _currentSelectDistanceIndex = indexPath.row;
            break;}
        case 1:{
            _currentSelectCategoryIndex = indexPath.row;
            break;}
        case 2:{
            _currentSelectConditionIndex = indexPath.row;
            break;}
        default:
            break;
    }
    
    if (_childDelegate && [_childDelegate respondsToSelector:@selector(segmentConditionMenu:didSelectContentItemAtIndex:)])
    {
        [_childDelegate segmentConditionMenu:self didSelectContentItemAtIndex:indexPath.row];
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
