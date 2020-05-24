//
//  IncomeMothDetailViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/6.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "IncomeMothDetailViewController.h"
#import "IncomDetailModel.h"
#import "HomeTool.h"
#import "IncomTableViewCell.h"
@interface IncomeMothDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,assign) NSInteger currenPage;
@property (nonatomic,strong) NSArray *detailData;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIView *nulView;

@end

@implementation IncomeMothDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单收入明细";
    _currenPage = 1;
    _titleLable.text = [NSString stringWithFormat:@"%@%@",[_mothModel.startDate substringToIndex:7],_mothModel.half];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"IncomTableViewCell" bundle:nil] forCellReuseIdentifier:@"IncomTableViewCell"];

    
    __weak __typeof(self)weakSelf = self;
    ShowProgressHUD(YES, self.view);
    [HomeTool sendSelectDetailListStarDate:_mothModel.startDate endDate:_mothModel.endDate currentPage:_currenPage paSize:1000 andsuceess:^(AFHTTPRequestOperation *operation, id responsObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        ShowProgressHUD(NO, self.view);
        NSArray *arry = responsObject[@"data"];
        NSMutableArray *mArry = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arry) {
            IncomDetailModel *model = [[IncomDetailModel alloc] init];
            [model setKeyValues:dic];
            [mArry addObject:model];
        }
        strongSelf.nulView.hidden = arry.count < 1 ? NO : YES;
        strongSelf.detailData = mArry;
        [strongSelf.myTableView reloadData];
        
    } andFail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ShowProgressHUD(NO, self);
        ShowWaringAlertHUD(error.localizedDescription, self.view);
    }];

    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detailData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IncomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IncomTableViewCell"];
    cell.inconModel = _detailData[indexPath.section];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
