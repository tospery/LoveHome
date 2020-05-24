//
//  LHReceiptModifyViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/25.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptModifyViewController.h"
#import "MapViewController.h"

@interface LHReceiptModifyViewController ()
@property (nonatomic, strong) LHReceipt *preReceipt;
@property (nonatomic, strong) LHReceipt *curReceipt;
//@property (nonatomic, strong) AdressPicker *picker;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *mobileTextField;
@property (nonatomic, weak) IBOutlet UITextField *areaTextField;
@property (nonatomic, weak) IBOutlet UITextField *addressTextField;

@end

@implementation LHReceiptModifyViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVars];
    [self initView];
}

#pragma mark - Private methods
#pragma mark init
- (void)initVars {
    self.curReceipt = [[LHReceipt alloc] init];
}

- (void)initView {
    if (self.preReceipt) {
        self.navigationItem.title = @"修改收货地址";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    }else {
        self.navigationItem.title = @"添加收货地址";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.mobileTextField exSetupLimit:11];
    //[_addressTextField exSetupLimit:14];
    
    NSInteger pID = _preReceipt ? _preReceipt.provinceId : 510000;
    NSInteger cID = _preReceipt ? _preReceipt.cityId : 510100;
    NSInteger zID = _preReceipt ? _preReceipt.areaId : 510101;
    JXInputView *inputView = [[JXInputView alloc] initWithDefaultProvinceID:pID
                                                              defaultCityID:cID
                                                              defaultZoneID:zID];
    [inputView setDidSelectBlock:^(JXProvince *province, JXCity *city, JXZone *zone) {
        self.curReceipt.provinceId = province.uid;
        self.curReceipt.provinceName = province.name;
        self.curReceipt.cityId = city.uid;
        self.curReceipt.cityName = city.name;
        self.curReceipt.areaId = zone.uid;
        self.curReceipt.areaName = zone.name;
        self.areaTextField.text = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, zone.name];
        [self enableRightItemIfNeed];
    }];
    self.areaTextField.inputView = inputView;
    
    [self configInfo];
}

#pragma mark config
- (void)configInfo {
    if (!self.preReceipt) {
        return;
    }
    
    self.nameTextField.text = self.preReceipt.name;
    self.mobileTextField.text = self.preReceipt.mobile;
    self.areaTextField.text = [NSString stringWithFormat:@"%@%@%@", self.preReceipt.provinceName, self.preReceipt.cityName, self.preReceipt.areaName];
    self.addressTextField.text = self.preReceipt.address;
}

- (BOOL)verifyInput {
    NSString *verify = [JXInputManager verifyInput:self.nameTextField.text least:1 original:nil ltSpaces:NO symbols:nil title:@"收货人" message:@"请输入有效的收货人"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    verify = [JXInputManager verifyPhoneNumber:self.mobileTextField.text original:nil];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    verify = [JXInputManager verifyInput:self.areaTextField.text least:0 original:nil ltSpaces:NO symbols:nil title:@"所在区域" message:@"请输入有效的区域"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    verify = [JXInputManager verifyInput:self.addressTextField.text least:1 original:nil ltSpaces:NO symbols:nil title:@"详细地址" message:@"请输入有效的详细地址"];
    if (verify) {
        Toast(verify);
        return NO;
    }
    
    return YES;
}

- (void)enableRightItemIfNeed {
    if (self.nameTextField.text.length == 0 ||
        self.mobileTextField.text.length == 0 ||
        self.areaTextField.text.length == 0 ||
        self.addressTextField.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark web
- (void)requestUpdate {
    if (![self verifyInput]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    self.curReceipt.receiptID = self.preReceipt.receiptID;
    self.curReceipt.name = self.nameTextField.text;
    self.curReceipt.mobile = self.mobileTextField.text;
    self.curReceipt.address = self.addressTextField.text;
    
    if (self.curReceipt.provinceId == 0) {
        self.curReceipt.provinceId = self.preReceipt.provinceId;
        self.curReceipt.provinceName = self.preReceipt.provinceName;
        self.curReceipt.cityId = self.preReceipt.cityId;
        self.curReceipt.cityName = self.preReceipt.cityName;
        self.curReceipt.areaId = self.preReceipt.areaId;
        self.curReceipt.areaName = self.preReceipt.areaName;
    }
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient updateReceipt:self.curReceipt success:^(AFHTTPRequestOperation *operation, LHReceipt *receipt) {
        receipt.isDefault = self.preReceipt.isDefault;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptChanged object:receipt];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JXHUDHide();
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestUpdate];
        }];
    }]];
}

- (void)requestAdd {
    if (![self verifyInput]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    self.curReceipt.name = self.nameTextField.text;
    self.curReceipt.mobile = self.mobileTextField.text;
    self.curReceipt.address = self.addressTextField.text;
    
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient addReceipt:self.curReceipt success:^(AFHTTPRequestOperation *operation, LHReceipt *receipt) {
        if (receipt.isDefault) {
            gLH.user.info.receiptAddr = receipt.address;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptChanged object:receipt];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JXHUDHide();
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestAdd];
        }];
    }]];
}

#pragma mark - Action methods
- (void)rightItemPressed:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.preReceipt) {
        [self requestUpdate];
    }else {
        [self requestAdd];
    }
}

- (IBAction)detailButtonPressed:(id)sender {
    MapViewController *vc = [[MapViewController alloc] init];
    vc.adressBlcok = ^(NSString *adressString,CGFloat latitude,CGFloat longitude) {
//        TextCellModel *showMode = _baseInfoData[indexPath.row];
//        showMode.contentString = adressString;
//        [UserTools sharedUserTools].registShopModel.shopAddress = adressString;
//        [UserTools sharedUserTools].registShopModel.latitude = @(latitude);
//        [UserTools sharedUserTools].registShopModel.longitude = @(longitude);
//        [tableView reloadData];
        _addressTextField.text = adressString;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegate methods
- (IBAction)textDidChanged:(id)sender {
    [self enableRightItemIfNeed];
}

#pragma mark - Public methods
- (instancetype)initWithReceipt:(LHReceipt *)receipt {
    if (self = [self init]) {
        _preReceipt = receipt;
    }
    return self;
}
@end
