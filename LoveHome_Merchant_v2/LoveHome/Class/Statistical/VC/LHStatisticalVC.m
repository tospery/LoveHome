//
//  LHStatisticalVC.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHStatisticalVC.h"
#import "LoveHome-Swift.h"
#import "LHOrderIncomViewController.h"
#import "LHVistorsViewController.h"
#import "LHActionOrderViewController.h"
#import "LHOrdeStatisViewController.h"
#import "RHType.h"
#import "RHRequstLauchTool.h"
@interface LHStatisticalVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSArray *dataSource;

@end

#pragma mark - 统计页面
@implementation LHStatisticalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
}

#pragma mark - PraviteFuction

- (void)setUpDB
{
    CellConfig *section1 = [CellConfig new];
    CellConfig *section2 = [CellConfig new];
    CellConfig * section3 = [CellConfig new];
    CellConfig * section4 = [CellConfig new];
    
    [section1 setTitle:@"访客数量" imgUrl: @"statistical_list_visitors"];
    [section2 setTitle:@"订单收入统计" imgUrl: @"statistical_list_income"];
    [section3  setTitle:@"订单统计" imgUrl: @"statistical_list_order"];
    [section4  setTitle:@"活动统计"  imgUrl: @"statistical_list_activity"];
    
    self.dataSource = @[section1,section2,section3,section4];
}
#pragma mark - 添加到视图
- (void)setUpUI
{
    [self.view addSubview:self.myTableView];
}

- (void)SetUpNet
{
    
    
}
#pragma mark - 懒加载tableView
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.tableFooterView = [UIView new];
        _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _myTableView.backgroundColor =  RHColorHex(0xF4F4F4,1);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.sectionFooterHeight = 10;
        _myTableView.sectionHeaderHeight = 1;
        [_myTableView registerNib:[UINib nibWithNibName:@"StatistiListCell" bundle:nil] forCellReuseIdentifier:@"StatistiListCell"];
     
    }
    return _myTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellConfig *mode = _dataSource[indexPath.section];
    StatistiListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatistiListCell"];
    cell.titleLable.text = mode.titleName;
    cell.showImageView.image = [UIImage imageNamed:mode.imageUrl];
    return cell;

}
#pragma mark - row 不同 进入的页面也不同
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            LHVistorsViewController *vc = [[LHVistorsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            LHOrderIncomViewController *vc = [[LHOrderIncomViewController alloc] initWithNibName:@"LHOrderIncomViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            LHOrdeStatisViewController *vc = [[LHOrdeStatisViewController alloc] initWithNibName:@"LHOrdeStatisViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case 3:
        {
            LHActionOrderViewController *vc = [[LHActionOrderViewController alloc] initWithNibName:@"LHActionOrderViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
