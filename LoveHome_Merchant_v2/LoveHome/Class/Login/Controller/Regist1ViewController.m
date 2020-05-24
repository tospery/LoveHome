//
//  Regist1ViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/6.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "Regist1ViewController.h"
#import "Regist2ViewController.h"
#import "WebViewController.h"
#import "JXCodeButton.h"
@interface Regist1ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet JXCodeButton *codeButton;

@end

@implementation Regist1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _telephoneTextF.delegate = self;
    self.navigationItem.title = @"注册";
       // Do any additional setup after loading the view from its nib.
    
    
    [_codeButton setupWithEnableTextColor:[UIColor whiteColor]
                                enableBgColor:JXColorHex(0xDC0005)
                            enableBorderColor:[UIColor clearColor]
                             disableTextColor:JXColorHex(0xAAAAAA)
                               disableBgColor:JXColorHex(0xE5E5E5)
                           disableBorderColor:[UIColor clearColor]
                                     duration:50];
    [_codeButton setStartBlock:^BOOL(void) {
        BOOL flag = [self verifyInputForCode];
        if (flag) {
            [self requestCodeWithMode];
        }
        return flag;
    }];

}

- (BOOL)verifyInputForCode {
    NSString *result = [JXInputManager verifyPhoneNumber:_telephoneTextF.text original:nil];
    if (result.length != 0) {
        ShowWaringAlertHUD(@"输入手机号", nil);
        return NO;
    }
    
    return YES;
}

- (void)requestCodeWithMode
{
    [self.view endEditing:YES];

    [UserTools getcodeWithPhone:_telephoneTextF.text success:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, nil);
        //        _codeTextF.text = responsObject;
        //        _codeButton.enabled = NO;
        //        _codeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        NSLog(@"%@",responsObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowProgressHUD(NO, nil);
//        ShowWaringAlertHUD(error.localizedDescription, nil);
        [_codeButton reset];
        
    }];

}

- (IBAction)registButton:(id)sender
{
    [self.view endEditing:YES];
    ShowProgressHUD(YES, nil);
    [UserTools signinWithPhone:_telephoneTextF.text code:_codeTextF.text success:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, nil);
        [UserTools sharedUserTools].registShopModel.mobile = _telephoneTextF.text;
        Regist2ViewController *vc = [[Regist2ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowProgressHUD(NO, nil);
        
        ShowWaringAlertHUD(error.localizedDescription, nil);
    }];
    

    

}
- (IBAction)readProtocol:(id)sender {
    
    WebViewController *web = [[WebViewController alloc] init];
    web.url = @"http://www.appvworks.com/merchat_agree.html";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _telephoneTextF) {
        
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (toBeString.length > 11 && range.length!=1){
            
            return NO;
            
        }
        return YES;

    }
    else
    {
        return YES;
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
