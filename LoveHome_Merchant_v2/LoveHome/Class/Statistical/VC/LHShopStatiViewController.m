//
//  LHShopStatiViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/5.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "LHShopStatiViewController.h"
#import "LoveHome-Swift.h"
@interface LHShopStatiViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *quarterBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currentDyas;
//商品为空时的提示框  以及 页面上显示 的 label
//@property (nonatomic, strong) UIAlertView *warningAlert;
@property (nonatomic, strong) UILabel *warningLabel;
@end

#pragma mark - 商品统计VC
@implementation LHShopStatiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];

}

#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"商品统计";
    _dataSource = [[NSMutableArray alloc] init];
    _weekBtn.selected = YES;
    _currentBtn = _weekBtn;
    _currentDyas = 7;
}

- (void)setUpUI
{
    _myTableView.tableFooterView = [UIView new];
    _myTableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0);
    _myTableView.sectionFooterHeight = 10;
    _myTableView.sectionHeaderHeight = 1;
    [_myTableView registerNib:[UINib nibWithNibName:@"ProductStatusCell" bundle:nil] forCellReuseIdentifier:@"ProductStatusCell"];
}

- (void)SetUpNet
{
    [self requestWihtModel:RHWebLaunchTypeHUD];
    
  }

- (void)requestWihtModel:(RHWebLaunchType)mode {
    
    [RHRequstLauchTool showLauchWithType:mode toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LHHttpClient requestStatistiGetCountWithDays:_currentDyas Success:^(AFHTTPRequestOperation *operation, id responsObject) {
            _dataSource = responsObject;
            [_myTableView reloadData];
            [RHRequstLauchTool handleSuceessRequestType:mode toView:self.view];
#pragma mark - 在网络请求成功之后调用懒加载, 弹出提示信息
            [self warningView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [RHRequstLauchTool handleErrorFailureForView:self.view lauchType:mode ToastWay:RHErrorShowTypeLoad error:error callback:^{
                [self requestWihtModel:mode];
            }];
        }];
    });
}
- (IBAction)selectTypeDay:(UIButton *)sender {
    NSInteger days = sender.tag - 300;
    _currentBtn.selected = NO;
    sender.selected = !sender.selected;
    _currentBtn = sender;
    _currentDyas = days;
#pragma mark - 避免点到90天的时候还会出现的 bug
    [_warningLabel removeFromSuperview];
    [self requestWihtModel:RHWebLaunchTypeHUD];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 新增, 空白页面的提示信息
- (void)warningView
{
    if (_dataSource.count == 0) {
        ShowWaringAlertHUD(@"最近暂无商品信息", self.view);
//        _warningAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最近暂无商品" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [_warningAlert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2 - 64, self.view.frame.size.width, 30)];
            _warningLabel.text = @"最近暂无商品信息";
            _warningLabel.textAlignment = NSTextAlignmentCenter;
            _warningLabel.textColor = [UIColor lightGrayColor];
            [self.view addSubview:_warningLabel];
        });
        
    } else if (_dataSource.count != 0 && _warningLabel) {
        [_warningLabel removeFromSuperview];
    }
    //return _warningAlert;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductStatusCell"];
    cell.product = _dataSource[indexPath.section];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
