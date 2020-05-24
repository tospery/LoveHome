//
//  ServerRangeViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/11/23.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "ServerRangeViewController.h"
#import "DatePicker.h"
#import "TextCellModel.h"
#import "AdressPicker.h"
#import "MapViewController.h"
#import "ServerMapViewController.h"

// configStr View
static NSString *const MarkWithServerRange  = @"店铺覆盖的服务区域";
static NSString *const MarkWithOnRange      = @"店铺所在区域";
static NSString *const MarkWithAdress       = @"设置店铺地址";
static NSString *const MarkWithpickerTitle  = @"店铺覆盖的服务区域";


@interface ServerRangeViewController ()<UITableViewDataSource,UITableViewDelegate,AdressPickerDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *dataSource;

// custom view property
@property (nonatomic,strong) DatePicker   *pickerView;
@property (nonatomic,strong) AdressPicker *adressPicker;

// select serverRange response
- (void)chooseShopServerRange;
// select shopCity response
- (void)chooseShopRange;
// select shopadress response
- (void)chooseShopAdress;
@end

@implementation ServerRangeViewController
- (void)dealloc
{
    [_pickerView removeFromSuperview];
    _pickerView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDB];
    [self setUpUI];
    [self SetUpNet];
    
}


#pragma mark - PraviteFuction

- (void)setUpDB
{
    self.title = @"服务区域";
    TextCellModel *range    = [[TextCellModel alloc] initWithPlaceString:MarkWithServerRange
                                                              andContent:JudgeContainerCountIsNull([UserTools sharedUserTools].registShopModel.serverCoverStr) ? @"" :[UserTools sharedUserTools].registShopModel.serverCoverStr isInteractionEnbled:NO];
    TextCellModel *onRange  = [[TextCellModel alloc] initWithPlaceString:MarkWithOnRange
                                                              andContent:JudgeContainerCountIsNull([UserTools sharedUserTools].registShopModel.cityDistrict) ? @"" :[UserTools sharedUserTools].registShopModel.cityDistrict  isInteractionEnbled:NO];
    TextCellModel *adress   = [[TextCellModel alloc] initWithPlaceString:MarkWithAdress
                                                              andContent:JudgeContainerCountIsNull([UserTools sharedUserTools].registShopModel.shopAddress) ? @"" :[UserTools sharedUserTools].registShopModel.shopAddress  isInteractionEnbled:NO];
    _dataSource             = @[range,onRange,adress];
}

- (void)setUpUI
{
    _mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _mTableView.delegate = self;
    _mTableView.dataSource  = self;
    _mTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mTableView];
#pragma mark - 修改区域选择器
    
    __weak __typeof(self)weakSelf = self;
    _pickerView = [[DatePicker alloc] initWithtitle:@[MarkWithpickerTitle]];
    [_pickerView setContentData:@[@"500M",@"1KM",@"2KM",@"3KM",@"5KM",@"10KM",@"全城"] andSconde:nil];
    _pickerView.block = ^(NSString *content1,id category)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        TextCellModel *mode =  strongSelf.dataSource[0];
        mode.contentString = content1;
        [strongSelf.mTableView reloadData];
        [UserTools sharedUserTools].registShopModel.serverCoverStr = content1;
        if (strongSelf.chooseServerRange) {
            strongSelf.chooseServerRange();
        }

    };
    _adressPicker = [[AdressPicker alloc] initWithFrame:self.view.bounds];
    _adressPicker.delegate = self;
    
}

- (void)SetUpNet
{


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
    
    static NSString *indentifer = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFontSizeFirst;
        cell.detailTextLabel.font = kFontSizeSecond;
    }
    TextCellModel *mode = _dataSource[indexPath.row];
    cell.textLabel.text = mode.placeString;
    cell.detailTextLabel.text = mode.contentString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // select different control
    switch (indexPath.row) {
        case 0:
            [self chooseShopServerRange];
            break;
        case 1:
            [self chooseShopRange];
            break;
        case 2:
            [self chooseShopAdress];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RHTableViewCellNormalHeihgt;
}

#pragma mark - SelectRange

- (void)chooseShopServerRange
{
    // show main
    [_pickerView coverStarAnimation];
}

- (void)chooseShopRange
{
    // show main
    [_adressPicker show];
}

- (void)chooseShopAdress
{
    TextCellModel *mode1 = _dataSource[0];
    TextCellModel *model2 = _dataSource[1];
    
    if (JudgeContainerCountIsNull(mode1.contentString) || JudgeContainerCountIsNull(model2.contentString)) {
        ShowWaringAlertHUD(@"请选择区域和地址", nil);
        return;
    }
    
    ServerMapViewController *vc = [[ ServerMapViewController  alloc] initWithNibName:@"ServerMapViewController" bundle:nil];

    vc.adressBlcok = ^(NSString *adressString,CGFloat latitude,CGFloat longitude)
    {

        TextCellModel *showMode = _dataSource[2];
        showMode.contentString = adressString;
        [UserTools sharedUserTools].registShopModel.shopAddress = adressString;
        [UserTools sharedUserTools].registShopModel.latitude = @(latitude);
        [UserTools sharedUserTools].registShopModel.longitude = @(longitude);
        [_mTableView reloadData];
        if (_chooseServerRange) {
            _chooseServerRange();
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)adressPickerDidChangeStatus:(AdressPicker *)picker
{
    
    NSString *adressTex = [NSString stringWithFormat:@"%@ %@ %@",picker.state,picker.city,picker.district];
    
    // 设置模型地址
    [UserTools sharedUserTools].registShopModel.shopProvince = @"510000";
    [UserTools sharedUserTools].registShopModel.shopCity = @"510100";
    [UserTools sharedUserTools].registShopModel.shopDistrict =  [RegistShopModel selectDistictIdWithDistrictName:picker.district];
    [UserTools sharedUserTools].registShopModel.cityDistrict = adressTex;
    TextCellModel *mode =  _dataSource[1];
    mode.contentString = adressTex;
    [_mTableView reloadData];
    
    if (_chooseServerRange) {
        _chooseServerRange();
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
