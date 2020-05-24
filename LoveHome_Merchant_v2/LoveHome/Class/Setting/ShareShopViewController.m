//
//  ShareShopViewController.m
//  LoveHome
//
//  Created by 石光 on 16/2/1.
//  Copyright © 2016年 卡莱博尔. All rights reserved.
//

#import "ShareShopViewController.h"

@interface ShareShopViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ShareShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_shareUrl]]];

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
