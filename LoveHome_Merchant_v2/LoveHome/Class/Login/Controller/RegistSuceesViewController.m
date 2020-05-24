//
//  RegistSuceesViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/28.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "RegistSuceesViewController.h"
#import "SettShopBaseInfoController.h"
@interface RegistSuceesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *autonInfo;
@property (weak, nonatomic) IBOutlet UIButton *autoAgin;
@property (weak, nonatomic) IBOutlet UILabel *selectSorceContent;
@property (strong, nonatomic) IBOutlet UIView *allView;


@end

@implementation RegistSuceesViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证";

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];;
    if (_autoStatu == AutoStatusNoOne) {
        [self ShowendTime];
    }
    if (_autoStatu == AutoStatusUnPass) {
        [self ShowendTime];
    }
    if (_autoStatu == AutoStatusWating) {
        
        [self ShowendTime];
    }
    if (_autoStatu == AutoStatusFail) {
        //_endTimeLable.hidden = NO;
        [_endTimeLable removeFromSuperview];
        _selectSorceContent.hidden = NO;
        NSString *sss = [_authDescription stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        _selectSorceContent.text = sss;
        _selectSorceContent.textColor = JXColorHex(0xff4400);
        _autonInfo.font = [UIFont systemFontOfSize:18];
        _autonInfo.text = @"认证未通过";
        
        UIButton *autoAgin = [UIButton buttonWithType:UIButtonTypeSystem];
        autoAgin.frame = CGRectMake(50, 160, 100, 40);
        [autoAgin setTitle:@"重新认证" forState:UIControlStateNormal];
        [autoAgin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        autoAgin.layer.cornerRadius = 4;
        autoAgin.layer.borderColor  = [UIColor lightGrayColor].CGColor;
        autoAgin.layer.borderWidth  = 0.5;
        autoAgin.hidden = NO;
        [self.allView addSubview:autoAgin];
        [autoAgin addTarget:self action:@selector(aginAuto) forControlEvents:UIControlEventTouchUpInside];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)aginAuto
{
    [self.navigationController pushViewController:[[SettShopBaseInfoController alloc] init] animated:YES];
}

- (void)ShowendTime
{

    self.endTimeLable.hidden = NO;
    // 倒计时
    __block  int timeout = 5; //倒计时时间
    __weak RegistSuceesViewController *myself = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //停止时
                NSMutableArray *childs = [NSMutableArray array];
                [childs addObject:[self.navigationController.childViewControllers objectAtIndex:0]];
                [childs addObject:self];
                [self.navigationController setViewControllers:childs];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //                //NSLog(@"____%@",strTime);
                myself.endTimeLable.text = [NSString stringWithFormat:@"%@秒后自动跳转登录界面",strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
