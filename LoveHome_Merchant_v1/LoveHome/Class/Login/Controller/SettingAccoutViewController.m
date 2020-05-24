//
//  SettingAccoutViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/6.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "SettingAccoutViewController.h"
#import "LHMyWalletTool.h"
#import "LHPayOnlineCell.h"
#import "TextFiledShuruCell.h"
#import "SettShopBaseInfoController.h"
static NSString *kTextFiledCell  =  @"TextFiledShuruCell";
static NSString *kPayoneLineCell =  @"LHPayOnlineCell";

@interface SettingAccoutViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *accoutTypes;
@property (nonatomic, strong) NSIndexPath *disSelectPath;

@end

@implementation SettingAccoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}




#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0)
    {
        return  _accoutTypes.count;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self configCurrentCell:indexPath];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = indexPath.section == 0 ? 63 : 50;
    return  height;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        LHPayOnlineCell *cell      = (LHPayOnlineCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectButton.selected = YES;
        cell.model.isSelect        = YES;
        if (_disSelectPath!= indexPath)
        {
            LHPayOnlineCell *disCell      = (LHPayOnlineCell *)[tableView cellForRowAtIndexPath:_disSelectPath];
            disCell.selectButton.selected = NO;
            disCell.model.isSelect        = NO;
        }
        // 当前支付方式
        _disSelectPath = indexPath;
    }

    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = section == 0 ? @"选择账号类型":@"";
    return string;
}

#pragma mark - private 私有方法

- (void)initView
{
    _myTableView.contentInset = UIEdgeInsetsMake(-18, 0, 0, 0);
    [_myTableView registerNib:[UINib nibWithNibName:kPayoneLineCell bundle:nil] forCellReuseIdentifier:kPayoneLineCell];
    [_myTableView registerNib:[UINib nibWithNibName:kTextFiledCell bundle:nil] forCellReuseIdentifier:kTextFiledCell];
    
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    footerView.backgroundColor = [UIColor clearColor];
//    
//    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 30, 40)];
//    commitButton.backgroundColor =  COLOR_CUSTOM(220, 0, 0, 5);
//    commitButton.layer.cornerRadius = 4;
//    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
//    [commitButton addTarget:self action:@selector(commitAccount:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:commitButton];
//    _myTableView.tableFooterView = footerView;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 70)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 40)];
    commitButton.backgroundColor = COLOR_CUSTOM(220, 0, 0, 5) ;
    commitButton.layer.cornerRadius = 4;
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitAccount:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commitButton];
    _myTableView.tableFooterView = view ;

    
}

- (void)initData
{
    self.title = @"确认资金账号";
    self.accoutTypes = [LHMyWalletTool getOnlinePayMent];
    _disSelectPath = [NSIndexPath indexPathForItem:0 inSection:0];
}



- (UITableViewCell *)configCurrentCell:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LHPayOnlineCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kPayoneLineCell];
        cell.model = _accoutTypes[indexPath.row];
        return cell;
    }
    else
    {
        TextFiledShuruCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kTextFiledCell];
        
        cell.textFiledShuru.keyboardType = UIKeyboardAppearanceDefault;
        NSString *title;
        if (indexPath.row == 0) {
            title = @"请输入资金账号";
            cell.textFiledShuru.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        else if (indexPath.row == 1)
        {
            title = @"再次确认资金账号";
        }
        else
        {
            title = @"请输入用户名";
        }
        cell.textFiledShuru.placeholder = title;
        return cell;
    }

   
}



- (void)commitAccount:(UIButton *)sender
{
    
    // 防止Token连带
    [UserTools sharedUserTools].registShopModel.token = nil;
    
    //NSLog(@"%ld", _disSelectPath.row) ;
    
    if (_disSelectPath.row != 0)
    {
        ShowWaringAlertHUD(@"抱歉，目前只支持支付宝支付", nil);
        return;
    }

    
    TextFiledShuruCell *text1 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     TextFiledShuruCell *text2 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    TextFiledShuruCell *text3 =  (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (text1.textFiledShuru.text.length < 1) {
        ShowWaringAlertHUD(@"请输入正确的账号", nil);
        return;
    }
    
    if ([text1.textFiledShuru.text isEqualToString:text2.textFiledShuru.text])
    {
        [UserTools sharedUserTools].registShopModel.channel = @(_disSelectPath.row + 1);
        [UserTools sharedUserTools].registShopModel.bankCardNo = text1.textFiledShuru.text;
        [UserTools sharedUserTools].registShopModel.bankCardName = text3.textFiledShuru.text;
        SettShopBaseInfoController *vc = [[SettShopBaseInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        ShowWaringAlertHUD(@"两次账号不一致", nil);
    }
    
   
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
