//
//  BSJ_ModelViewController.m
//  BangBang
//
//  Created by Joe Chen on 9/12/13.
//  Copyright (c) 2013 卡莱博尔. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()
{
}

@property (assign, nonatomic) NSUInteger requestFailedLimitTimes;    //业务请求次数限制
@property (assign, nonatomic) NSUInteger loginFailedLimitTimes;      //登录失败请求次数限制


@end

@implementation ModelViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        _loginFailedLimitTimes   = 0;
        _requestFailedLimitTimes = 0;

        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.currentDataRequest && ![self.currentDataRequest isFinished])
    {
        [self.currentDataRequest cancel];
    }
    
    if(self.userLoginRequest && ![self.userLoginRequest isFinished])
    {
        [self.userLoginRequest cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = COLOR_CUSTOM(244, 244, 244, 1);

}






#pragma mark - MemoryManager

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
