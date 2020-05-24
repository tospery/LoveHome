//
//  JXFilterViewSelectionContentTable.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/9/26.
//  Copyright © 2015年 杨建祥. All rights reserved.
//

#import "JXFilterViewSelectionContentTable.h"

@interface JXFilterViewSelectionContentTable ()
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, assign) NSInteger index;

@end

@implementation JXFilterViewSelectionContentTable
#pragma mark - Private methods
- (void)setup {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJXIdentifierCellSystem];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJXStandardCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJXIdentifierCellSystem];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _options[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    if (indexPath.row == _index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = JXColorRGB(251.0f, 251.0f, 251.0f);
        cell.textLabel.textColor = JXColorHex(0x007AFF);
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _index = indexPath.row;
    [tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(filterViewSelection:didSelectIndex:withObject:)]) {
        [self.delegate filterViewSelection:(JXFilterViewSelection *)self.superview didSelectIndex:(self.superview.tag - JXFilterViewTagBegin) withObject:_options[indexPath.row]];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

#pragma mark - Public methods
- (instancetype)initWithOptions:(NSArray *)options defaultIndex:(NSInteger)index {
    if (self = [self initWithFrame:CGRectMake(0, 0, kJXScreenWidth, options.count * kJXStandardCellHeight)]) {
        _options = options;
        _index = index;
        [self setup];
    }
    return self;
}
@end
