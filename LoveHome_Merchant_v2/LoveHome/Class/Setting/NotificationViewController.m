//
//  NotificationViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/15.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationViewCell.h"
#import "NotificationModel.h"
@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation NotificationViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"消息通知";
    [_myTableView registerNib:[UINib nibWithNibName:@"NotificationViewCell" bundle:nil] forCellReuseIdentifier:@"NotificationViewCell"];
    _myTableView.backgroundColor = [UIColor clearColor];

    _dataSource = [[NSMutableArray alloc] init];
    [self sendMeassage];

    // Do any additional setup after loading the view from its nib.
}

- (void)reloadMessageCount
{
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/modifyOrderMsgReadState" andToken:YES andParameterDic:nil andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)sendMeassage
{
  
    NSDictionary *dic = @{@"page" : @1,@"row" : @1000,@"messageType" : @2};
    
    [HttpServiceManageObject sendPostRequestWithPathUrl:@"general/getPushMessage" andToken:YES andParameterDic:dic andParameterType:kHttpRequestParameterType_KeyValue andSucceedCallback:^(AFHTTPRequestOperation *operation, id responsObject) {
        

        NSArray *data = responsObject[@"data"];
        if (data.count < 1) {
            ShowWaringAlertHUD(@"暂无新的推送消息", nil);
            return ;
        }
        
        [_dataSource removeAllObjects];
        for (NSDictionary *dic in data) {
            NotificationModel *mode = [[NotificationModel alloc] init];
            [mode setKeyValues:dic];
            [_dataSource addObject:mode];
            
        }
        [_myTableView reloadData];
        
        [self reloadMessageCount];
        
    } andFailedCallback:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationViewCell"];
    cell.notiModel = _dataSource[indexPath.row];
    return cell;
    

 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NotificationViewCell cellHeightWithData:_dataSource[indexPath.row]];;
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
