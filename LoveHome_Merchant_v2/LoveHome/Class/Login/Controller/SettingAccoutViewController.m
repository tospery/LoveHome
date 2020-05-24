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
#import "IQKeyboardManager.h"

static NSString *kTextFiledCell  =  @"TextFiledShuruCell";
static NSString *kPayoneLineCell =  @"LHPayOnlineCell";

@interface SettingAccoutViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *accoutTypes;
@property (nonatomic, strong) NSIndexPath *disSelectPath;
@property (nonatomic, strong) NSMutableArray *dateArr;

@end

@implementation SettingAccoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateArr = @[@"请输入资金账号", @"再次确认资金账号", @"请输入用户名"].mutableCopy;
    
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
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"yinlian"];
        if ([str isEqualToString:@"you"]) {
            return self.dateArr.count;
        } else {
            return self.dateArr.count;
        }
        
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
    return  height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        LHPayOnlineCell *cell = (LHPayOnlineCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectButton.selected = YES;
        cell.model.isSelect = YES;
        if (_disSelectPath!= indexPath)
        {
            LHPayOnlineCell *disCell = (LHPayOnlineCell *)[tableView cellForRowAtIndexPath:_disSelectPath];
            disCell.selectButton.selected = NO;
            disCell.model.isSelect = NO;
        }
        // 当前支付方式
        _disSelectPath = indexPath;
        if (indexPath.row == 2) {
            [self.dateArr removeAllObjects];
            self.dateArr = [NSMutableArray arrayWithObjects:@"请选择开户银行",@"请输入支行名称", @"请输账号", @"请再次输入账号", @"请输入姓名", nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"you" forKey:@"yinlian"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.myTableView reloadData];
            
        } else {
            [self.dateArr removeAllObjects];
            self.dateArr = @[@"请输入资金账号", @"再次确认资金账号", @"请输入用户名"].mutableCopy;
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"yinlian"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.myTableView reloadData];
        }
        
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
    else if (indexPath.section == 1)
    {
        TextFiledShuruCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kTextFiledCell];
        cell.textFiledShuru.keyboardType = UIKeyboardAppearanceDefault;
        NSString *title;
        if (self.dateArr.count == 3) {
            if (indexPath.row == 0) {
                title = [self.dateArr objectAtIndex:0];
                cell.textFiledShuru.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            else if (indexPath.row == 1)
            {
                title = [self.dateArr objectAtIndex:1];
            }
            else
            {
                title = [self.dateArr objectAtIndex:2];
            }
            cell.textFiledShuru.placeholder = title;
            return cell;
        } else if (self.dateArr.count == 5) {
            if (indexPath.row == 0) {
                title = [self.dateArr objectAtIndex:0];
                cell.textFiledShuru.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            else if (indexPath.row == 1)
            {
                title = [self.dateArr objectAtIndex:1];
            }
            else if (indexPath.row == 2)
            {
                title = [self.dateArr objectAtIndex:2];
            }
            else if (indexPath.row == 3)
            {
                title = [self.dateArr objectAtIndex:3];
            }
            else if (indexPath.row == 4)
            {
                title = [self.dateArr objectAtIndex:4];
            }
            cell.textFiledShuru.placeholder = title;
            return cell;

        }
        
    }
    return nil;
}
- (void)commitAccount:(UIButton *)sender
{
    // 防止Token连带
    [UserTools sharedUserTools].registShopModel.token = nil;
    
    NSLog(@"%ld", _disSelectPath.row) ;
    if (self.dateArr.count == 3) {
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
    } else if (self.dateArr.count == 5) {
        TextFiledShuruCell *text1 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        TextFiledShuruCell *text2 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        TextFiledShuruCell *text3 =  (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        TextFiledShuruCell *text4 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        TextFiledShuruCell *text5 = (TextFiledShuruCell *)[_myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
        
        if (text1.textFiledShuru.text.length < 1 || text2.textFiledShuru.text.length < 1) {
            ShowWaringAlertHUD(@"请输入正确的银行信息", nil);
            return;

        }
        if (text3.textFiledShuru.text.length < 1) {
            ShowWaringAlertHUD(@"请输入正确的账号", nil);
            return;
        }
        if ([text3.textFiledShuru.text isEqualToString:text4.textFiledShuru.text])
        {
            [UserTools sharedUserTools].registShopModel.channel = @(_disSelectPath.row + 1);
            [UserTools sharedUserTools].registShopModel.bankCardNo = text4.textFiledShuru.text;
            [UserTools sharedUserTools].registShopModel.bankCardName = text5.textFiledShuru.text;
            SettShopBaseInfoController *vc = [[SettShopBaseInfoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else
        {
            ShowWaringAlertHUD(@"两次账号不一致", nil);
        }

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
