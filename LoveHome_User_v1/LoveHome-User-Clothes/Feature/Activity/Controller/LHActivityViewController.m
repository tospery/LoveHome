//
//  LHActivityViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/21.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHActivityViewController.h"
#import "LHShopListViewController.h"
#import "LHShopDetailViewController.h"
#import "LHOrderConfirmViewController.h"

@interface LHActivityViewController ()
@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) NSString *myTitle;
@property (nonatomic, strong) NSString *myDescription;
@property (nonatomic, strong) LHActivity *activity;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIView *attendView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation LHActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [MobClick beginLogPageView:kStatisticPageActivity];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    [MobClick endLogPageView:kStatisticPageActivity];
}

- (void)initView {
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
    }];
    
    [_bridge registerHandler:@"shopDetailCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSInteger shopId = [[data objectForKey:@"shopId"] integerValue];
            NSInteger categoryId = [[data objectForKey:@"categoryId"] integerValue];
            LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shopId];
            detailVC.from = categoryId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }];
    
    [_bridge registerHandler:@"shopListCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        LHShopListViewController *listVC = [[LHShopListViewController alloc] init];
        listVC.from = LHEntryFromActivity;
        listVC.activity = _activity;
        [self.navigationController pushViewController:listVC animated:YES];
    }];
    
    [_bridge registerHandler:@"submitOrderCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSArray class]]) {
            if ([(NSArray *)data count] != 0) {
                NSArray *arr = data;
                NSMutableArray *cartShops = [NSMutableArray array];
                for (int i = 0; i < arr.count; ++i) {
                    LHSpecify *s = [[LHSpecify alloc] init];
                    s.productId = JXStringFromInteger([[arr[i] objectForKey:@"productId"] integerValue]);
                    s.uid = [s.productId copy];
                    s.name = [arr[i] objectForKey:@"productName"];
                    s.url = [arr[i] objectForKey:@"productUrl"];
                    s.price = [NSString stringWithFormat:@"%.2f", [[arr[i] objectForKey:@"price"] floatValue]];
                    s.pieces = [[arr[i] objectForKey:@"count"] integerValue];
                    
                    LHCartShop *cs = [[LHCartShop alloc] init];
                    cs.shopID = [arr[i] objectForKey:@"shopId"];
                    cs.shopName = [arr[i] objectForKey:@"shopName"];
                    [cs.specifies addObject:s];
                    
                    [cartShops addObject:cs];
                }
                
                LHOrderConfirmViewController *confirmVC = [[LHOrderConfirmViewController alloc] initWithCartShops:cartShops];
                confirmVC.from = LHEntryFromActivity;
                [self.navigationController pushViewController:confirmVC animated:YES];
            }
        }
    }];
    
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    _webView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//    
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    self.progressView.progressBarView.backgroundColor = JXColorHex(0x29D8D6);
    
    NSString *targetStr = [NSString stringWithFormat:@"%@?hideDownload=1&&showApple=1", _activity.targeturl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:targetStr]];
    [self.webView loadRequest:request];
}

#pragma mark - Action methods
- (void)shareItemPressed:(id)sender {
    JXHUDProcessing(nil);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_activity.imgurl] options:SDWebImageDownloaderHighPriority | SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        JXHUDHide();
        
        NSString *targetStr = [NSString stringWithFormat:@"%@?hideDownload=0&&showApple=1", _activity.targeturl];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"【%@】%@", [JXApp name], _myTitle];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"【%@】%@", [JXApp name], _myTitle];;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = targetStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = targetStr;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kUMAppkey
                                          shareText:_myDescription
                                         shareImage:image ? image : kImageAppIcon
                                    shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                           delegate:self];
    }];
}

- (IBAction)attendButtonPressed:(id)sender {
    LHShopListViewController *listVC = [[LHShopListViewController alloc] init];
    listVC.from = LHEntryFromActivity/*LHEntryFromCart*/;
    listVC.activity = _activity;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - Delegate methods
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _myTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _myDescription = [webView stringByEvaluatingJavaScriptFromString:@"(function(){ var meta=document.getElementsByTagName('meta');for (var i=0; i<meta.length; i++) {if (meta[i].name.toLowerCase()=='description') {return meta[i].content;}}; })();"];
    _myDescription = _myDescription ? _myDescription : _myTitle;
    
    if (_activity.type == LHActivityTypeInteract) {
        [_attendView setHidden:NO];
    }
    
    self.navigationItem.title = _myTitle;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"ic_share_gray"] size:CGSizeMake(20, 20) target:self action:@selector(shareItemPressed:)];
}


#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    Alert(kStringError, [error localizedDescription]);
}

#pragma mark NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (gLH.logined) {
            [self.operaters exAddObject:
             [LHHTTPClient requestGetLovebeanWhenSharedWithTaskid:LHShareTaskActivity success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
                gLH.user.info.loveBean += response.integerValue;
            } failure:NULL]];
        }
    }
}

#pragma mark - Public methods
- (instancetype)initWithActivity:(LHActivity *)activity {
    if (self = [self init]) {
        _activity = activity;
    }
    return self;
}
@end



