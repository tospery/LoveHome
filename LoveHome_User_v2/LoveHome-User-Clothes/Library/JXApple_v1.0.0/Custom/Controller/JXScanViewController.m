//
//  JXScanViewController.m
//  iOSLibrary
//
//  Created by 杨建祥 on 15/7/20.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "JXScanViewController.h"

#ifdef JXEnableZXing
@interface JXScanViewController ()
@property (nonatomic, assign) BOOL scanToken;
@property (nonatomic, assign) BOOL lifeToken;
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIView *scanView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *bgViews;
@property (nonatomic, copy) JXScanViewControllerResultBlock resultBlock;
@end

@implementation JXScanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_lifeToken) {
        _lifeToken = YES;
        
        _capture.layer.frame = self.view.bounds;
        CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(_capture.scanSize.width / self.view.frame.size.width,
                                                                            _capture.scanSize.height / self.view.frame.size.height);
        _capture.scanRect = CGRectApplyAffineTransform(_scanView.frame, captureSizeTransform);
    }
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    _capture = [[ZXCapture alloc] init];
    _capture.delegate = self;
    _capture.camera = _capture.back;
    _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    _capture.rotation = 90.0f;
    
    _capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:_capture.layer];
}

- (void)initView {
    [_scanView exSetBorder:[UIColor redColor] width:1.0 radius:0.1];
    
    for (UIView *view in _bgViews) {
        [self.view bringSubviewToFront:view];
    }
    [self.view bringSubviewToFront:_scanView];
    [self.view bringSubviewToFront:_cancelButton];
}

#pragma mark assist
- (void)stopScan {
    [_capture.layer removeFromSuperlayer];
    [_capture stop];
}

#pragma mark - Action methods
- (IBAction)cancelButtonPressed:(id)sender {
    if (![self isBeingDismissed]) {
        [self stopScan];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Delegate methods
#pragma mark ZXCaptureDelegate
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    if (_scanToken) {
        return;
    }
    _scanToken = YES;
    
    if (![self isBeingDismissed]) {
        [self stopScan];
        [self dismissViewControllerAnimated:YES completion:^{
            if (_resultBlock) {
                _resultBlock(capture, result);
            }
        }];
    }
}

#pragma mark - Public methods
- (void)setupResultBlock:(JXScanViewControllerResultBlock)resultBlock {
    _resultBlock = resultBlock;
}
@end
#endif