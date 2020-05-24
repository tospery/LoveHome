//
//  LHReceiptModify2ViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/12/18.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptModify2ViewController.h"
#import "LHCityViewController.h"
#import "LHLocationSearchViewController.h"

@interface LHReceiptModify2ViewController ()
@property (nonatomic, assign) BOOL isChoosedAddress;
@property (nonatomic, strong) BMKPoiInfo *poi;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UITextField *detailTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

@implementation LHReceiptModify2ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_receipt) {
        self.navigationItem.title = @"修改收货地址";
        if (_receipt.addressExpand.length != 0) {
            _isChoosedAddress = YES;
            _addressLabel.text = _receipt.address;
            _detailTextField.text = _receipt.addressExpand;
        }else {
            _isChoosedAddress = NO;
            _detailTextField.text = _receipt.address;
        }
        _nameTextField.text = _receipt.name;
        _phoneTextField.text = _receipt.mobile;
    }else {
        self.navigationItem.title = @"新建收货地址";
        _phoneTextField.text = gLH.user.info.phoneNumber;
    }
    
    ConfigButtonStyle(_saveButton);
    
    [_nameTextField exSetupLimit:6];
    [_phoneTextField exSetupLimit:11];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAddressChoosed:) name:kNotifyAddressChoosed object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSString *)verifyInput {
    if (!_isChoosedAddress) {
        return @"请选择有效的收货地址";
    }
    
    NSString *result = [JXInputManager verifyInput:_detailTextField.text least:0 original:nil ltSpaces:NO symbols:nil title:@"楼层、门牌号" message:@"请填写有效的楼层、门牌号"];
    if (0 != result.length) {
        return result;
    }
    
    result = [JXInputManager verifyInput:_nameTextField.text least:0 original:nil ltSpaces:NO symbols:nil title:@"收货人姓名" message:@"请填写有效的收货人姓名"];
    if (0 != result.length) {
        return result;
    }
    
    result = [JXInputManager verifyPhoneNumber:_phoneTextField.text original:nil];
    if (0 != result.length) {
        return result;
    }
    
    return nil;
}

- (void)requestAddWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    
    LHReceipt *r = [[LHReceipt alloc] init];
    r.name = _nameTextField.text;
    r.mobile = _phoneTextField.text;
    r.provinceId = 510000;
    r.cityId = 510100;
    r.areaId = -1;
    r.address = _addressLabel.text;
    r.addressExpand = _detailTextField.text;
    r.longitude = _poi.pt.longitude;
    r.latitude = _poi.pt.latitude;
    
    [self.operaters exAddObject:
     [LHHTTPClient addReceipt:r success:^(AFHTTPRequestOperation *operation, LHReceipt *receipt) {
        if (receipt.isDefault) {
            gLH.user.info.receiptAddr = receipt.address;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptChanged object:receipt];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JXHUDHide();
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:NULL];
    }]];
}

- (void)requestUpdate {
    LHReceipt *r = [[LHReceipt alloc] init];
    r.receiptID = self.receipt.receiptID;
    r.name = _nameTextField.text;
    r.mobile = _phoneTextField.text;
    r.provinceId = 510000;
    r.cityId = 510100;
    r.areaId = -1;
    r.address = _addressLabel.text;
    r.addressExpand = _detailTextField.text;
    if (_poi) {
        r.longitude = _poi.pt.longitude;
        r.latitude = _poi.pt.latitude;
    }else {
        r.longitude = self.receipt.longitude;
        r.latitude = self.receipt.latitude;
    }
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient updateReceipt:r success:^(AFHTTPRequestOperation *operation, LHReceipt *receipt) {
        receipt.isDefault = self.receipt.isDefault;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptChanged object:receipt];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JXHUDHide();
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:NULL];
    }]];
}


- (IBAction)saveButtonPressed:(id)sender {
    NSString *verify = [self verifyInput];
    if (0 != verify.length) {
        Toast(verify);
        return;
    }
    
    if (self.receipt) {
        [self requestUpdate];
    }else {
        [self requestAddWithMode:JXWebLaunchModeHUD];
    }
}

- (IBAction)cityButtonPressed:(id)sender {
    LHCityViewController *vc = [[LHCityViewController alloc] init];
    vc.isPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addressButtonPressed:(id)sender {
    LHLocationSearchViewController *vc = [[LHLocationSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)notifyAddressChoosed:(NSNotification *)notification {
    _poi = notification.object;
    if (0 != _poi.name.length) {
        _isChoosedAddress = YES;
        _addressLabel.textColor = JXColorHex(0x333333);
        _addressLabel.text = _poi.name;
    }
}

@end





