//
//  LoginsViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/5.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "LoginsViewController.h"
#import "Regist1ViewController.h"
#import "RegistSuceesViewController.h"
#import "JXCodeButton.h"
@interface LoginsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *telePhone;
@property (weak, nonatomic) IBOutlet UITextField *codeLbale;
@property (weak, nonatomic) IBOutlet JXCodeButton *sendCodeButton;


@end

@implementation LoginsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";


    
    
    [_sendCodeButton setupWithEnableTextColor:[UIColor whiteColor]
                            enableBgColor:JXColorHex(0xDC0005)
                        enableBorderColor:[UIColor clearColor]
                         disableTextColor:JXColorHex(0xAAAAAA)
                           disableBgColor:JXColorHex(0xE5E5E5)
                       disableBorderColor:[UIColor clearColor]
                                 duration:50];
    [_sendCodeButton setStartBlock:^BOOL(void) {
        BOOL flag = [self verifyInputForCode];
        if (flag) {
            [self requestCodeWithMode];
        }
        return flag;
    }];


    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];    // Do any additional setup after loading the view from its nib.
}
- (BOOL)verifyInputForCode {
    NSString *result = [JXInputManager verifyPhoneNumber:_telePhone.text original:nil];
    if (result.length != 0) {
        ShowWaringAlertHUD(@"输入手机号", nil);
        return NO;
    }
    
    return YES;
}


- (void)requestCodeWithMode
{
    
    [self.view endEditing:YES];

    [UserTools getcodeWithPhone:_telePhone.text success:^(AFHTTPRequestOperation *operation, id responsObject) {
        ShowProgressHUD(NO, nil);
        
        //        button.enabled = NO;
        //        _sendCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        _codeLbale.text = responsObject;
        //NSLog(@"%@",responsObject);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ShowProgressHUD(NO, nil);
//        ShowWaringAlertHUD(error.localizedDescription, self.view);
        [_sendCodeButton stopTiming];
        
    }];
    

}





/*!
 *  @brief  点击登录
 *
 *  @param sender
 */
- (IBAction)loginButton:(id)sender
{
    
      
    [self.view endEditing:YES];
    ShowProgressHUDWithText(YES, nil, @"登录中");
   [UserTools loginWithPhone:_telePhone.text code:_codeLbale.text device:@"231" success:^(AFHTTPRequestOperation *operation, id responsObject) {
       ShowProgressHUDWithText(NO, nil, @"登录中");
       UserDataModel *user = [[UserDataModel alloc] init];
       [user  setKeyValues:responsObject];
       
       if (user.authStatus != AutoStatusSuceess) {
           [UserTools sharedUserTools].registShopModel = nil;
           [UserTools sharedUserTools].registShopModel.token = user.token;
           [self checkShopStatu:user.authStatus];
           return ;
       }
       
       [UserTools sharedUserTools].userModel = user;
       [[NSNotificationCenter defaultCenter] postNotificationName:kHomePageReload object:nil];
       NSNumber *shopState = responsObject[@"shopState"];
       [[NSUserDefaults standardUserDefaults] setObject:shopState forKey:AWKS_GET_ShopStatu];
       [[NSUserDefaults standardUserDefaults] synchronize];
       
       _loginSucessBlock(operation,responsObject);
       [UserTools sharedUserTools].isLoginWindow = NO;
       [self dismissViewControllerAnimated:YES completion:NULL];
       
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       ShowProgressHUDWithText(NO, nil, @"登录中");
       ShowWaringAlertHUD(error.localizedDescription, nil);

   }];
    
}


/*!
 *  @brief  去注册
 *
 *  @param sender
 */
- (IBAction)registPress:(id)sender
{
    
    Regist1ViewController *vc = [[Regist1ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];


}


/*!
 *  @brief  检查商铺状态
 *
 *  @param status
 */
- (void)checkShopStatu:(AutoStatus)status
{
    RegistSuceesViewController *vc = [[RegistSuceesViewController alloc] init];
    vc.autoStatu = status;
    vc.autoStatuString = @"认证失败";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)back:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _telePhone) {
        
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
