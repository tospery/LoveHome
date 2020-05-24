//
//  LHIntroViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/21.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHIntroViewController.h"
#import "AppDelegate.h"
#import "LHIntroStep4Panel.h"

@interface LHIntroViewController ()
@end

@implementation LHIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight) nibNamed:@"LHIntroStep1Panel"];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight) nibNamed:@"LHIntroStep2Panel"];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight) nibNamed:@"LHIntroStep3Panel"];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight) nibNamed:@"LHIntroStep4Panel"];
    
    NSArray *panels = @[panel1, panel2, panel3, panel4];
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight)];
    introductionView.delegate = self;
    [introductionView.RightSkipButton setHidden:YES];
    [introductionView.PageControl setHidden:NO];
    introductionView.PageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    introductionView.PageControl.currentPageIndicatorTintColor = JXColorHex(0x38D8D5);
    [introductionView buildIntroductionWithPanels:panels];
    
    [self.view addSubview:introductionView];
    [introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - MYIntroduction Delegate
-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    gLH.version = [JXApp version];
    [[AppDelegate appDelegate] entryHomeWithAnimated:YES];
}

@end
