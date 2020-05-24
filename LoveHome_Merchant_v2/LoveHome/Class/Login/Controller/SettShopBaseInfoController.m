//
//  SettShopBaseInfoController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "SettShopBaseInfoController.h"
#import "LHTextViewCell.h"
#import "TextCellModel.h"
#import "AdressPicker.h"
#import "DatePicker.h"
#import "CategoryModel.h"
#import "OperateRangeViewController.h"
#import "AutoShopViewController.h"
#import "TextImageCell.h"
#import "ImageLibraryController.h"
#import "MapViewController.h"
#import "ServerRangeViewController.h"
#import "ServerDescriptionViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
@interface SettShopBaseInfoController ()<OperateRangeViewControllerDelegate,DatePickerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,AdressPickerDelegate>
@property (nonatomic,strong) NSString *shopTime;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *baseInfoData;
@property (nonatomic,strong) AdressPicker *adressPicker;
@property (nonatomic,strong) DatePicker *datePicker;

@end

@implementation SettShopBaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUpSubViews];


    // Do any additional setup after loading the view.
}


- (void)initData
{
    self.title = @"创建商铺基本信息";
    TextCellModel *model1 = [[TextCellModel alloc] initWithPlaceString:@"请输入店铺名称" andContent:@"" isInteractionEnbled:YES];
    TextCellModel *model2 = [[TextCellModel alloc] initWithPlaceString:@"请选择店铺经营类型" andContent:@"" isInteractionEnbled:NO];
     TextCellModel *model21 = [[TextCellModel alloc] initWithPlaceString:@"请选择所在区域范围" andContent:@"" isInteractionEnbled:NO];
    TextCellModel *model4 = [[TextCellModel alloc] initWithPlaceString:@"请选择服务时间" andContent:@"" isInteractionEnbled:NO];
    TextCellModel *model5 = [[TextCellModel alloc] initWithPlaceString:@"请输入负责人姓名" andContent:@"" isInteractionEnbled:YES];
    TextCellModel *model6 = [[TextCellModel alloc] initWithPlaceString:@"请输入联系电话固话格 028-xxxxxxxx" andContent:@"" isInteractionEnbled:YES];
    model6.keybordType = UIKeyboardTypeNumbersAndPunctuation;
    TextCellModel *model7 = [[TextCellModel alloc] initWithPlaceString:@"描述" andContent:@"" isInteractionEnbled:NO];
    
    _baseInfoData = [[NSMutableArray alloc] initWithObjects:@[model1],@[model4,model21,model2],@[model5,model6],@[model7],nil];
    
    
    
    
//    [UserTools sharedUserTools].registShopModel.serviceStartTime = @"01:00";
//    [UserTools sharedUserTools].registShopModel.serviceEndTime   = @"24:00";
    
}
- (void)setUpSubViews
{
   
    [self.view addSubview:self.myTableView];
    _adressPicker = [[AdressPicker alloc] initWithFrame:self.view.bounds];
    _adressPicker.delegate = self;
    
    // DatePicker
    NSMutableArray *starTime = [[NSMutableArray alloc] init];
    NSMutableArray *endTime = [[NSMutableArray alloc] init];;
    for (int i=0; i<24; i++)
    {
        NSString *timeStr = ((i+1)<10)?[NSString stringWithFormat:@"0%d",(i+1)]:[NSString stringWithFormat:@"%d",(i+1)];
        [starTime addObject:[NSString stringWithFormat:@"%@:00",timeStr]];
        [endTime addObject:[NSString stringWithFormat:@"%@:00",timeStr]];
    }
    
    self.datePicker = [[DatePicker alloc] initWithtitle:@[@"开始时间",@"结束时间"]];
    self.datePicker.delegate = self;
    [_datePicker setContentData:starTime andSconde:endTime];
    [_datePicker scrollRow:0  inComponent:0 animated:YES];
    [_datePicker scrollRow:23 inComponent:1 animated:YES];
}

- (void)changeDelegateString:(NSString *)contetnt
{
    TextCellModel *model = self.baseInfoData[1][0];
    model.contentString = contetnt;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 设置模型时间
    [UserTools sharedUserTools].registShopModel.serviceStartTime = [[contetnt substringToIndex:5]   stringByAppendingString:@":00"];
    [UserTools sharedUserTools].registShopModel.serviceEndTime   = [[contetnt substringFromIndex:6] stringByAppendingString:@":00"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _baseInfoData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *data =_baseInfoData[section];
        return data.count + 1;
    }
    else
    {
        NSArray *data =_baseInfoData[section];
        return data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *dataSource = _baseInfoData[indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LHTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHTextViewCell"];
            cell.textModel = dataSource[indexPath.row ];
            return cell;
        }
        else
        {
            TextImageCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"TextImageCell"];
            cell.contentLable.text = @"商铺Logo";
            if ([UserTools sharedUserTools].registShopModel.shopLogo) {
                cell.headImageView.image = [UserTools sharedUserTools].registShopModel.shopLogo;
            }
            return cell;
        }
    }
    else
    {
        LHTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHTextViewCell"];
        cell.textModel = dataSource[indexPath.row];
        return cell;
    }
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ) {
        UIActionSheet *_userAutoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [_userAutoSheet showInView:self.view.superview];
        return;
        
    }
    NSArray *sectionData = _baseInfoData[indexPath.section];
    TextCellModel *mode = sectionData[indexPath.row];
    NSString  *modeName = mode.placeString;
   
    
    if ([modeName isEqualToString:@"请选择服务时间"]) {
        [_datePicker coverStarAnimation];
        return;
    }
    if ([modeName isEqualToString:@"请选择店铺经营类型"]) {
        [self setOperateRange];
        return;
        
    }
    if ([modeName isEqualToString:@"请选择所在区域范围"]) {
        [self chooseAdress:indexPath];
        return;
    }
    if ([modeName isEqualToString:@"描述"]) {
        [self selectmoreshopDescriptions];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)adressPickerDidChangeStatus:(AdressPicker *)picker
{
    
    NSString *adressTex = [NSString stringWithFormat:@"%@ %@ %@",picker.state,picker.city,picker.district];
    // 设置模型地址
    [UserTools sharedUserTools].registShopModel.shopProvince = @"510000";
    [UserTools sharedUserTools].registShopModel.shopCity = @"510100";
    [UserTools sharedUserTools].registShopModel.shopDistrict =  [RegistShopModel selectDistictIdWithDistrictName:picker.district];
    TextCellModel *model = _baseInfoData[2];
    model.contentString = adressTex;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            case 2:
                return;
                
        }
    }
    else {
        if (buttonIndex == 0 ) {
            //NSLog(@"您的设备不支持照相功能");
            return;
        } else if (buttonIndex == 1)
        {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } else if (buttonIndex == 2)
        {
            return;
        }
    }
    
    // 跳转到相机或相册页面
     ImageLibraryController *vc = [[ImageLibraryController alloc] initWithPickerType:sourceType andScale:1];
     vc.imageBlock = ^(UIImage *image)
    {
        [UserTools sharedUserTools].registShopModel.shopLogo = image;
        [_myTableView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
    

}


#pragma mark - 类别选择回调
- (void)chooseSelectCategory:(NSArray *)cates
{
    TextCellModel *showMode = _baseInfoData[1][2];
    NSMutableString *categoryString = [[NSMutableString alloc] init];
    NSMutableString *cateId = [[NSMutableString alloc] init];
    for (CategoryModel *mode in cates) {
        [categoryString appendString:[NSString stringWithFormat:@"%@,",mode.categName]];
        [cateId appendString:[NSString stringWithFormat:@"%ld,",mode.cid]];
        
    }
    
    [categoryString deleteCharactersInRange:NSMakeRange(categoryString.length - 1, 1)];
    [cateId deleteCharactersInRange:NSMakeRange(cateId.length - 1, 1)];
    [UserTools sharedUserTools].registShopModel.bussinessScope = cateId;
    showMode.contentString = categoryString;
    [_myTableView reloadData];
    
}

#pragma mark - 私有方法
//描述
- (void)selectmoreshopDescriptions
{
    TextCellModel *showMode = _baseInfoData[3][0];
    ServerDescriptionViewController *des = [[ServerDescriptionViewController alloc] init];
    des.contentBlcok = ^(NSString *content) {
        showMode.contentString = content;
        [UserTools sharedUserTools].registShopModel.shopDescription = content;
        [_myTableView reloadData];
    };
    des.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:des animated:YES];
}

// 选择经营范围
- (void)setOperateRange
{
    OperateRangeViewController *vc = [[OperateRangeViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}




// 选择地址
- (void)chooseAdress:(NSIndexPath *)indexPath
{
    
    ServerRangeViewController *server = [[ServerRangeViewController alloc] init];
    server.hidesBottomBarWhenPushed = YES;
    
    __weak __typeof(self)weakSelf = self;
    server.chooseServerRange = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSArray *ary = _baseInfoData[indexPath.section];
        TextCellModel *showMode = ary[indexPath.row];
       showMode.contentString = [strongSelf getServerRageTitle];
        [strongSelf.myTableView reloadData];
        
    };
    [self.navigationController pushViewController:server animated:YES];
    return;
    
}

- (NSString *)getServerRageTitle {
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@", [UserTools sharedUserTools].registShopModel.serverCoverStr,[UserTools sharedUserTools].registShopModel.cityDistrict,[UserTools sharedUserTools].registShopModel.shopAddress];
    
    return [string stringReplaceNullStrs];
}

#pragma mark 下一步
- (void)commitAccountCheck:(UIButton *)sender
{
    
    [self.view endEditing:YES];

    for (NSArray *data in _baseInfoData) {
        for (TextCellModel *showModel in data) {
            if (JudgeContainerCountIsNull(showModel.contentString)) {
                ShowWaringAlertHUD(@"请填写完整的商铺信息", nil);
                return;
            }
        }
    }
    
    BOOL isEffect  = [self checkUserEffectiveness];
    if (!isEffect) {
        return;
    }
    [UserTools sharedUserTools].registShopModel.shopName = ((TextCellModel *)_baseInfoData[0][0]).contentString;
    [UserTools sharedUserTools].registShopModel.telPhone= ((TextCellModel *)_baseInfoData[2][1]).contentString;
    [UserTools sharedUserTools].registShopModel.shopContartName = ((TextCellModel *)_baseInfoData[2][1]).contentString;
    AutoShopViewController *vc = [[AutoShopViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (BOOL)checkUserEffectiveness {
    BOOL effect = YES;
    RegistShopModel *mode = [UserTools sharedUserTools].registShopModel;
    if (mode.shopLogo == nil) {
        ShowWaringAlertHUD(@"请填选取商铺图标", nil);
        effect = NO;
    }
    
    if (!mode.latitude || !mode.latitude) {
        ShowWaringAlertHUD(@"请选择详细地址", nil);
        effect = NO;
    }
    if (JudgeContainerCountIsNull(mode.serverCoverStr) || JudgeContainerCountIsNull(mode.cityDistrict)) {
        ShowWaringAlertHUD(@"请选这服务区域", nil);
        effect = NO;
    }
    NSString *regex =   @"^1[34578]\\d{9}|[0]{1}[0-9]{2,3}-[0-9]{7,8}$";
    NSRegularExpression *regex1 = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:nil];
    TextCellModel *model = _baseInfoData[2][1];
    NSArray *results = [regex1 matchesInString:model.contentString options:0 range:NSMakeRange(0, model.contentString.length)];
    if (!results.count) {
        ShowWaringAlertHUD(@"请输入正确的电话格式", self.view);
        effect = NO;
    }

    return effect;
}

#pragma mark - Get Set
- (UITableView *)myTableView
{
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT - 64) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"LHTextViewCell" bundle:nil] forCellReuseIdentifier:@"LHTextViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"TextImageCell" bundle:nil] forCellReuseIdentifier:@"TextImageCell"];
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 40)];
        commitButton.backgroundColor = COLOR_CUSTOM(220, 0, 0, 5) ;
        commitButton.layer.cornerRadius = 4;
        [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
        [commitButton addTarget:self action:@selector(commitAccountCheck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:commitButton];
        _myTableView.tableFooterView = view ;
        
    }
    return _myTableView;
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
