//
//  Regist2ViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/6.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "Regist2ViewController.h"
#import "SettingAccoutViewController.h"
@interface Regist2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstPassWord;
@property (weak, nonatomic) IBOutlet UITextField *aginPassWord;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation Regist2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
}

- (IBAction)registButton:(id)sender
{
    
    if (_firstPassWord.text.length < 1) {
        ShowWaringAlertHUD(@"密码不能为空", nil);
        return;
    }

    if ([_firstPassWord.text isEqualToString:_aginPassWord.text]) {
        
        NSString *pawd = [NSString getMd5_32Bit_String:_firstPassWord.text];
        [UserTools sharedUserTools].registShopModel.passWord = pawd;
        SettingAccoutViewController *vc = [[SettingAccoutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ShowWaringAlertHUD(@"密码不一致请重新输入", nil);
    }
    
   
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
