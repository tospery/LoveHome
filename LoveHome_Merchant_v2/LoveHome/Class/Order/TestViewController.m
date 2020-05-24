//
//  TestViewController.m
//  LoveHome
//
//  Created by MRH on 15/12/11.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

#import "TestViewController.h"
#import "RHLoadView.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%ld",self.view.subviews.count);
    // Do any additional setup after loading the view from its nib.
    [RHLoadView showProcessingAddedTo:self.view rect:CGRectZero];
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
