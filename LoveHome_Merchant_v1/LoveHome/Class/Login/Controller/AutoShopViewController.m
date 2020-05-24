//
//  AutoShopViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/1/9.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "AutoShopViewController.h"
#import "ImageLibraryController.h"
#import "RegistSuceesViewController.h"
#import "UIImage+ImageEffects.h"

#define autoTag 3000

@interface AutoShopViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentChoose;
@property (weak, nonatomic) IBOutlet UIView *companyAutoView;
@property (weak, nonatomic) IBOutlet UIView *userAutoView;


/******企业认证******/
@property (weak, nonatomic) IBOutlet UIButton *companyBusinessPhoto;
@property (weak, nonatomic) IBOutlet UIButton *companyUserFrontPhoto;
@property (weak, nonatomic) IBOutlet UIButton *companyUserReversePhoto;

@property (nonatomic , strong) UIActionSheet *companyBusinessPhotoSheet;
@property (nonatomic , strong) UIActionSheet *companyUserFrontPhotoSheet;
@property (nonatomic , strong) UIActionSheet *companyUserReversePhotoSheet;
@property (nonatomic , strong) NSArray *imagesData;
@property (nonatomic , assign) BOOL isAuto;
/******个人认证*****/
@property (weak, nonatomic) IBOutlet UIButton *userAutoPhoto;
@property (nonatomic , strong) UIActionSheet *userAutoSheet;


@property (nonatomic , strong)  NSMutableArray  *companyImages;


@end

@implementation AutoShopViewController

- (void)dealloc
{

}


- (id)initWithIsAfterAuton:(BOOL)isAuto
{
    self = [super init];
    if (self) {
        _isAuto = isAuto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"店铺认证";
    self.view.backgroundColor = BackGroudColor;

    
    _companyImages = [[NSMutableArray alloc] initWithCapacity:3];
    
    [_segmentChoose addTarget:self action:@selector(chooseAutoUserType:) forControlEvents:UIControlEventValueChanged];
    
    [_companyBusinessPhoto addTarget:self action:@selector(_companyBusinessPhoto)
                    forControlEvents:UIControlEventTouchUpInside];
    [_companyUserFrontPhoto addTarget:self action:@selector(_companyUserFrontPhoto)
                     forControlEvents:UIControlEventTouchUpInside];
    [_companyUserReversePhoto addTarget:self action:@selector(_companyUserReversePhoto)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [_userAutoPhoto addTarget:self action:@selector(_userAutoPhoto)
            forControlEvents:UIControlEventTouchUpInside];
    [UserTools sharedUserTools].registShopModel.authType = @2;
    
    
}

#pragma mark 提交照片
- (IBAction)submitPhoto:(id)sender
{
    
    ShowProgressHUDWithText(YES, nil, @"注册中");

    if (_segmentChoose.selectedSegmentIndex == 0) {

        UIImage *image = _companyBusinessPhoto.imageView.image;
        UIImage *image2 = _companyUserFrontPhoto.imageView.image;
        UIImage *image3 = _companyUserReversePhoto.imageView.image;
        
        if (image == nil || image2 == nil || image3 == nil) {
            
            ShowProgressHUDWithText(NO, nil, @"注册中");
            ShowAlertView(@"提示", @"请选取上传的图片", @"确定", nil);
            return;
        }

        
        __block NSData *data1,*data2,*data3;
        
/**NSOpration操作模式
        NSBlockOperation *operation1 = [[NSBlockOperation alloc]init ];
        [operation1 addExecutionBlock:^{
            data1   = [UIImage imageObjectToData:image andCompressionQuality:1 andMaxSize:500];
        }];
        [operation1 addExecutionBlock:^{
            data2   = [UIImage imageObjectToData:image2 andCompressionQuality:1 andMaxSize:500];
        }];
        [operation1 addExecutionBlock:^{
            data3   = [UIImage imageObjectToData:image3 andCompressionQuality:1 andMaxSize:500];
        }];

        NSBlockOperation *endOpreation = [NSBlockOperation blockOperationWithBlock:^{
            
            
            NSArray *images = @[data1,data2,data3];
            self.imagesData = images;
            [self submitAutoShopWithImages:_imagesData];

        }];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [endOpreation addDependency:operation1];
        [queue addOperations:@[operation1,endOpreation] waitUntilFinished:NO];

NSOpration操作模式**/
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 186569
            data1   = [UIImage imageObjectToData:image  andCompressionQuality:1 andMaxSize:300];
            data2   = [UIImage imageObjectToData:image2 andCompressionQuality:1 andMaxSize:300];
            data3   = [UIImage imageObjectToData:image3 andCompressionQuality:1 andMaxSize:300];
    
        dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *images = @[data1,data2,data3];
                self.imagesData = images;
                [self submitAutoShopWithImages:_imagesData];

            });
            
        });

    
        
    }
    else
    {
        
        UIImage *images = _userAutoPhoto.imageView.image;
        NSData *data1   = [UIImage imageObjectToData:images andCompressionQuality:1 andMaxSize:500];
        if (images == nil) {
            ShowProgressHUDWithText(NO, nil, @"注册中");
            ShowAlertView(@"提示", @"请选取上传的图片", @"确定", nil);

            return;
        }
        self.imagesData =@[data1];

        [self submitAutoShopWithImages:_imagesData];
    }
    
}

- (void)submitAutoShopWithImages:(NSArray *)images
{
    
    NSMutableDictionary *parmater = [[NSMutableDictionary alloc] initWithDictionary: [[UserTools sharedUserTools].registShopModel objectToDictionary]];
    [parmater removeObjectForKey:@"shopLogo"];
    [parmater removeObjectForKey:@"token"];

    // ImageDic
    NSData *shopLogoData =  [UIImage imageObjectToData:[UserTools sharedUserTools].registShopModel.shopLogo andCompressionQuality:1 andMaxSize:300];
    NSMutableDictionary *imageParmete = [[NSMutableDictionary alloc] init];
    [imageParmete setObject:shopLogoData forKey:@"shopLogo"];
    
    //13678013231
    
    NSArray *keys = @[@"licenseImg",@"idPositiveImg",@"idCounterImg"];
    int i = 0;
    for (NSData *data in images) {
        [imageParmete setObject:data forKey:keys[i]];
        i++;
    }

    
    [HttpServiceManageObject sendPostUploadImageRequestWithPathUrl:@"accountMerchant/register" andToken:[UserTools sharedUserTools].registShopModel.token andParameterDic:parmater andImageArray:imageParmete andSucceedCallback:^(id response) {
        ShowProgressHUDWithText(NO, nil, @"注册中");
        
        [UserTools sharedUserTools].registShopModel = nil;
        RegistSuceesViewController *vc = [[RegistSuceesViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } andFailedCallback:^(NSError *error) {
        
        ShowProgressHUDWithText(NO, nil, @"注册中");
        ShowWaringAlertHUD(@"服务器异常", nil);
        
    }];
    

}

- (void)updateImage:(NSArray *)images
{


}

- (void)autoSuceess
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [UserUtility shareUserUtility].shops.status = @2;
//        [NSKeyedArchiver archiveRootObject:[UserUtility shareUserUtility].shops toFile:GetShopLocalPath()];
//        
//        if (_isAuto) {
//            [self.navigationController popToRootViewControllerAnimated :YES];
//        }
//        else
//        {
//            RootViewController *rootController                             = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
//            [[UIApplication sharedApplication].keyWindow setRootViewController:rootController];
// 
//        }
//        
//        
//    });

   

}


#pragma mark - 跳过认证

- (void)jumpAuto:(UIBarButtonItem *)sender
{
    
//    if (_isAuto) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    RootViewController *rootController                             = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
//    [[UIApplication sharedApplication].keyWindow setRootViewController:rootController];

}

#pragma mark - 图像认证上传

- (void)_companyBusinessPhoto
{
    _companyBusinessPhotoSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [_companyBusinessPhotoSheet showInView:self.view.superview];
}
- (void)_companyUserFrontPhoto
{
    
    _companyUserFrontPhotoSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [_companyUserFrontPhotoSheet showInView:self.view.superview];
    
}
- (void)_companyUserReversePhoto
{
 
    _companyUserReversePhotoSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [_companyUserReversePhotoSheet showInView:self.view.superview];
}
- (void)_userAutoPhoto
{
    
     _userAutoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [_userAutoSheet showInView:self.view.superview];
}


#pragma mark - 图片选择SheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //NSLog(@"%ld",(long)buttonIndex);
    
    NSUInteger sourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
                
            case 2:
                return;
                
        }
    }
    else {
        if (buttonIndex == 0 ) {
//            //NSLog(@"您的设备不支持照相功能");
            return;
        } else if (buttonIndex == 1)
        {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } else if (buttonIndex == 2)
        {
            return;
        }
    }
    
    // 跳转到相机或相册页面
    [self skipPhotoPickerControllerWithType:sourceType sheet:actionSheet];
    
    
  
}




- (void)skipPhotoPickerControllerWithType:(NSInteger)source sheet:(UIActionSheet *)sheet
{
    // 获取照片
    __weak AutoShopViewController *_mySelf = self;
    
    ImageLibraryController *imageVc;
    
    if (sheet == _userAutoSheet)
    {
        ImageLibraryController *vc = [[ImageLibraryController alloc] initWithPickerType:source andScale:1];
        imageVc = vc;
    }
    else
    {
        ImageLibraryController *vc1 = [[ImageLibraryController alloc] initWithPickerType:source andScale:0.618];
        imageVc = vc1;
    }
   
    imageVc.imageBlock = ^(UIImage *image)
    {
        if (sheet == _companyBusinessPhotoSheet) {
            

            [_companyBusinessPhoto setImage:image forState:UIControlStateNormal];

            return ;
        }
        if (sheet == _companyUserFrontPhotoSheet) {
            

            [_companyUserFrontPhoto setImage:image forState:UIControlStateNormal];
            return ;

        }
        if (sheet == _companyUserReversePhotoSheet) {
            

            [_companyUserReversePhoto setImage:image forState:UIControlStateNormal];
            return ;

        }
        if (sheet == _userAutoSheet) {
            
        }   [_userAutoPhoto setImage:image forState:UIControlStateNormal];
        return ;

        
    };
    [self presentViewController:imageVc animated:YES completion:nil];
}


#pragma mark - segement选择上传类型
- (void)chooseAutoUserType:(id *)sender
{
    NSInteger index = _segmentChoose.selectedSegmentIndex;
    if (index == 0) {
        _companyAutoView.hidden = NO;
        _userAutoView.hidden    = YES;
        [UserTools sharedUserTools].registShopModel.authType = @2;
    }
    else
    {
        _companyAutoView.hidden = YES;
        _userAutoView.hidden    = NO;
        [UserTools sharedUserTools].registShopModel.authType = @1;
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
