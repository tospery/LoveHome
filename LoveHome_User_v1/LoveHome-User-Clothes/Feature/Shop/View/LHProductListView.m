//
//  LHSpecifyListView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/14.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProductListView.h"
#import "LHProductListCell.h"

@interface LHProductListView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, copy) LHProductListViewPressedBlock pressedBlock;
@end

@implementation LHProductListView
- (instancetype)initWithProducts:(NSArray *)products {
    if (self = [self init]) {
        _products = products;
        [self custom];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

- (void)custom {
    self.backgroundColor = ColorHex(0xF4F4F4);
    
    if (self.products.count == 0) {
        [JXLoadView showResultAddedTo:self rect:CGRectZero image:nil message:@"暂时没有相关商品" functitle:nil callback:NULL];
        return;
    }
    [JXLoadView hideForView:self];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UINib *cellNib = [UINib nibWithNibName:@"LHProductListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHProductListCell identifier]];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
}

- (void)setupPressedBlock:(LHProductListViewPressedBlock)pressedBlock {
    self.pressedBlock = pressedBlock;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.products.count == 0) {
        return 0;
    }
    return ceil((float)self.products.count / 3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHProductListCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
    if (![view viewWithTag:1022]) {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, 48.0f)];
        myView.backgroundColor = JXColorHex(0xF4F4F4);
        myView.tag = 1022;
        [view addSubview:myView];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHProductListCell identifier]];
    
    NSMutableArray *products = [NSMutableArray arrayWithCapacity:3];
    
    int index = 0;
    int i = (int)indexPath.row;
    for (int j = 0; j < 3; ++j) {
        index = i * 3 + j;
        if (index >= self.products.count) {
            break;
        }
        [products addObject:self.products[index]];
    }
    
    [(LHProductListCell *)cell setIsOutOfService:_isOutOfService];
    [(LHProductListCell *)cell setProducts:products];
    [(LHProductListCell *)cell setupPressedBlock:self.pressedBlock];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}
@end
