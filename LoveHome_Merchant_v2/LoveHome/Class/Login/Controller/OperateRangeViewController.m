//
//  OperateRangeViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OperateRangeViewController.h"
#import "CategoryModel.h"
#import "MoreItemCell.h"
@interface OperateRangeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSArray *category;
@end

@implementation OperateRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.view addSubview:self.myTableView];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    self.title = @"选择服务项目";
    
    CategoryModel *mode1 = [[CategoryModel alloc] init];
    mode1.categName = @"洗衣";
    mode1.cid = 1;
    
    CategoryModel *mode2 = [[CategoryModel alloc] init];
    mode2.categName = @"洗鞋";
    mode2.cid = 2;
    
    CategoryModel *mode3 = [[CategoryModel alloc] init];
    mode3.categName = @"皮具洗护";
    mode3.cid = 3;
    
    CategoryModel *mode4 = [[CategoryModel alloc] init];
    mode4.categName = @"奢侈品洗护";
    mode4.cid = 4;
    
    CategoryModel *mode5 = [[CategoryModel alloc] init];
    mode5.categName = @"其他";
    mode5.cid = 5;
    
    _category = [[NSArray alloc] initWithObjects:mode1,mode2,mode3,mode4 ,mode5,nil];
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"MoreItemCell" bundle:nil] forCellReuseIdentifier:@"MoreItemCell"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor clearColor];
        _myTableView.tableFooterView = view;

    }
    return _myTableView;
}

- (void)commitAccount:(UIButton *)sender
{
    NSMutableArray *cateList = [[NSMutableArray alloc] init];
    for (CategoryModel *mode in _category) {
        if (mode.isSelect) {
            [cateList addObject:mode];
        }
    }
    
    if (_changeCategory) {
        _changeCategory(cateList);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _category.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreItemCell"];
    cell.categroy = _category[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"123312312");
    MoreItemCell *cell = (MoreItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectButton.selected = !cell.selectButton.selected;
    cell.categroy.isSelect = cell.selectButton.selected;
    
    NSMutableArray *cateList = [[NSMutableArray alloc] init];
    for (CategoryModel *mode in _category) {
        if (mode.isSelect) {
            [cateList addObject:mode];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(chooseSelectCategory:)]) {
        [_delegate chooseSelectCategory:cateList];
    }
//    if (_changeCategory) {
//        _changeCategory(cateList);
//    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
