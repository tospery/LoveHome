////
////  LoveHomeTests.m
////  LoveHomeTests
////
////  Created by Joe Chen on 14/11/3.
////  Copyright (c) 2014年 卡莱博尔. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "UserUtility.h"
//#import "UserDataModel.h"
//#import "ManageProductsViewController.h"
//#import "ProductDataModelTool.h"
//#import "BaseDataModel.h"
//#import "CatagoryDataModel.h"
//
//#import "UIImageView+WebCache.h"
//
//#import "AFURLSessionManager.h"
//
//#import "ClassManageObject.h"
//
//
//@interface LoveHomeTests : XCTestCase
//
//@end
//
//@implementation LoveHomeTests
//
//- (void)setUp
//{
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown
//{
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}
//
//
///*!
// *  @brief  测试sdimage
// *
// *  @return
// */
//
//- (void)testSDImageWebCache
//{
//    NSArray * _items;
//    _items = @[@"https://battlingthedemonswithin.files.wordpress.com/2013/09/earth-cd321c592915ddb9165e20d1053edce9ee78cd3b-s6-c30.jpg",
//               @"http://1.bp.blogspot.com/-AWQC0Kw9q_Q/Uq8uHsrQkpI/AAAAAAAAFVo/GHOKcf7nrXw/s640/cars.png",
//               @"http://www.german-concept-cars.com/wp-content/uploads/2010/05/German-concept-Cars-Home1.jpg",
//               @"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSOUxre9MKwPxFwb89wO33V4PzzCFnZ5ttP6tWmP5YQzRtk_40h",
//               @"http://assets.esquire.co.uk/images/uploads/fourbythree/_540_43/l_236-four-of-the-best-american-muscle-cars-2.jpg",
//               @"http://sportscommunity.com.au/wp-content/uploads/2013/01/sports-collage.jpg",
//               @"http://i.telegraph.co.uk/multimedia/archive/01806/earth_1806334c.jpg",
//               @"https://battlingthedemonswithin.files.wordpress.com/2013/09/earth-cd321c592915ddb9165e20d1053edce9ee78cd3b-s6-c30.jpg",
//               @"http://upload.wikimedia.org/wikipedia/commons/c/cc/2008_Ducati_848_Showroom.jpg",
//               @"http://kickstart.bikeexif.com/wp-content/uploads/2014/01/ducati-999.jpg",
//               @"http://kickstart.bikeexif.com/wp-content/uploads/2012/09/ducati-pantah-2.jpg",
//               @"http://static.derapate.it/derapate/fotogallery/625X0/3775/ducati-999.jpg",
//               @"http://siliconangle.com/files/2012/03/github_logo.jpg",
//               @"https://octodex.github.com/images/octobiwan.jpg",
//               @"https://octodex.github.com/images/murakamicat.png",
//               @"http://tinyurl.com/q7xc48y"];
//    
//    
//    
//    
//    
//    for (int i = 0; i < _items.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        //        [imageView sd_setImageWithURL:_items[i] placeholderImage:nil options:SDWebImageRetryFailed |SDWebImageLowPriority];
//        NSURL *url = [NSURL URLWithString:_items[i]];
//        [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            //NSLog(@"----%ld",cacheType);
//        }];
//        //NSLog(@"22222222");
//    }
//}
//
//
//
//
//
//
///*!
// *  @brief  测试UserUtility的自我观察
// */
//- (void)testUserNameOfUserDataModelObserver
//{
//    [UserUtility useStorageDataToAllocUser];
//    
//    UserDataModel *userModel1 = [[UserDataModel alloc] init];
//    [[UserUtility shareUserUtility] setUserModel:userModel1];
//    
//    
//    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:@"237737347843",@"telphone",@"99999",@"password",@"asdfads",@"token",@"1003",@"userid",@"menghaoran",@"userName", nil];
//    UserDataModel *userModel = [[UserDataModel alloc] init];
//    [userModel setValuesForKeysWithDictionary:userDic];
//    
//    [[UserUtility shareUserUtility] setUserModel:userModel];
//    
//    //    [UserUtility shareUserUtility].userModel.userName = @"Maicle";
//    //    [UserUtility shareUserUtility].userModel.telphone = @"1234";
//    //
//    //
//    //    [UserUtility shareUserUtility].userModel.userName = @"Lucy";
//    //    [UserUtility shareUserUtility].userModel.telphone = @"567";
//    //
//    //
//    //    [UserUtility shareUserUtility].userModel.userName = @"Joe";
//    //    [UserUtility shareUserUtility].userModel.telphone = @"899";
//    
//}
//
//- (void)testUserUtility
//{
//    //测试，从序列化存储数据初始化
//    [UserUtility useStorageDataToAllocUser];
//    
//    TTRSLog(@"%@",[[UserUtility shareUserUtility].userModel objectToDictionary]);
//    
//    
//    //    [[UserUtility shareUserUtility] setToken:@"1223443"];
//    //    //NSLog(@"获取：%@",[UserUtility shareUserUtility].token);
//    
//    //不自动存储
//    [UserUtility shareUserUtility].isAutoLogin = NO;
//    
//    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:@"237737347843",@"telphone",@"99999",@"password",@"asdfads",@"token",@"1003",@"userid",@"menghaoran",@"userName", nil];
//    UserDataModel *userModel = [[UserDataModel alloc] init];
//    [userModel setValuesForKeysWithDictionary:userDic];
//    
//    [[UserUtility shareUserUtility] setUserModel:userModel];
//    
//    TTRSLog(@"%@",[[UserUtility shareUserUtility].userModel objectToDictionary]);
//    
//    //NSLog(@"%d",[[UserUtility shareUserUtility] isLogin]);
//    
//    
//    //自动存储
//    [UserUtility shareUserUtility].isAutoLogin = YES;
//    
//    NSDictionary *userDic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"19837762365",@"telphone",@"7777",@"password",@"asdfads",@"token",@"1008",@"userid",@"Jack",@"userName", nil];
//    UserDataModel *userModel2 = [[UserDataModel alloc] init];
//    [userModel2 setValuesForKeysWithDictionary:userDic2];
//    
//    [[UserUtility shareUserUtility] setUserModel:userModel2];
//    
//    TTRSLog(@"%@",[[UserUtility shareUserUtility].userModel objectToDictionary]);
//    
//}
//
//
//- (void)testGetProductListFunction
//{
////    ManageProductsViewController *controller = [[ManageProductsViewController alloc] init];
//    
//}
//
//
//
//- (void)testProductListSetDataFunction
//{
//    NSArray *shopProductList = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"PROD14169706970680000",@"prodid",@"洗衣",@"prodname",@"100.55",@"price",@"shop001",@"shopid",@"描述",@"comment", nil]];
//    
//    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"parentid",[NSNumber numberWithInteger:101],@"ptypeid",@"家政服务",@"ptypename",shopProductList,@"shopProductList",nil];
//    
//    ProductDataModelTool *productTool = [[ProductDataModelTool alloc] init];
//    [productTool setDataWithDic:resultDic];
//    
//    //    [((CatagoryDataModel *)productTool.catagoryModel) objectToDictionary]
//    
//    
//    //NSLog(@"%@",[productTool.catagoryModel objectToDictionary]);
//}
//
//
//- (void)testAccessVariable
//{
////    NSInteger outsideVariable = 10;
//    __block NSInteger outsideVariable = 10;
//    NSMutableArray * outsideArray = [[NSMutableArray alloc] init];
//    
////    __block NSInteger newOutsideVariable = outsideVariable;
//    
//    void (^blockObject)(void) = ^(void)
//    {
//        NSInteger insideVariable = 20;
////        KSLog(@"  > member variable = %d", self.memberVariable);
//        //NSLog(@"  > outside variable = %ld", outsideVariable);
////        //NSLog(@"  > new outside variable = %ld", newOutsideVariable);
//
////        newOutsideVariable = 60;
//        
////        //NSLog(@"  > new outside variable = %ld", newOutsideVariable);
//        
//        //NSLog(@"  > inside variable = %ld", insideVariable);
//        
//        [outsideArray addObject:@"AddedInsideBlock"];
//    };
//    
//    outsideVariable = 30;
////    self.memberVariable = 30;
//    
//    blockObject();
//    
//    //NSLog(@"  > %ld items in outsideArray", [outsideArray count]);
//}
//
//
//
//
//- (void)testMD5
//{
//    NSString *test = @"111111";
//    NSString *test2 = @"999999";
//    
//    //NSLog(@"11111: %@",[NSString getMd5_16Bit_String:test]);
//    //NSLog(@"99999: %@",[NSString getMd5_16Bit_String:test2]);
//}
//
//
//- (void)testArrayJson
//{
//    NSError *error;
//    NSArray *array = [NSArray arrayWithObjects:@"PROD14176796715590004",@"PROD14176789367310003", nil];
//    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
//    
//    //NSLog(@"%@",data);
//    
//    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//    
//    //NSLog(@"%@",object);
//}
//
//
//- (void)testCreatImageWithColorFunction
//{
//    UIImage *image = [UIImage creatImageWithColor:[UIColor blueColor] andSize:CGSizeMake(1280, 500)];
//    UIImage *imageSecond = [UIImage creatImageWithColor:[UIColor blueColor] andSize:CGSizeMake(1280, 900)];
//
//    //NSLog(@"%@",image);
//    
//    UIImage *newIamge       = [UIImage cutImageByHeightScale:0.618 andOrginImage:image];
//    UIImage *newIamgeSecond = [UIImage cutImageByHeightScale:0.618 andOrginImage:imageSecond];
//
//    //    NSData  *newImageData   = [UIImage imageObjectToData:newIamge andCompressionQuality:1.0 andMaxSize:50000];
//    
////    [UIImage savePhotoFileToFolderWithFolderName:@"testFolder" andFileName:[NSString stringWithFormat:@"testImage%@.jpeg",GetCurrentTime()] andData:newImageData];
//    
//    NSData *originImageData = UIImageJPEGRepresentation(newIamge, 1.0);
//    NSData *originImageSecondData = UIImageJPEGRepresentation(newIamgeSecond, 1.0);
//    
//    [UIImage savePhotoFileToFolderWithFolderName:@"testFolder" andFileName:[NSString stringWithFormat:@"originImage%@_A.jpeg",GetCurrentTime()] andData:originImageData];
//    
//    [UIImage savePhotoFileToFolderWithFolderName:@"testFolder" andFileName:[NSString stringWithFormat:@"originImageSecond%@.jpeg",GetCurrentTime()] andData:originImageSecondData];
//
//}
//
//- (void)testImage
//{
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:@"shop" forKey:@"modeltype"];
//    [parameter setObject:@"14187011811100592" forKey:@"modelid"];
//
//    
//    NSString *imageStr = @"图片数据";
//    NSData *imageData = [imageStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *paraString = @"modelid:14187011811100592";
//    
//    NSMutableData* jsonData = [NSMutableData dataWithData:[paraString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    NSString *boundary = @"ea4e308e-7e89-4e12-b368-963765a4018d";
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",boundary];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//    
//    //http body的字符串
//    NSMutableString *imageBodyString = [[NSMutableString alloc]init];
//    [imageBodyString appendFormat:@"%@\r\n",MPboundary];
//    //添加字段名称，换2行
//    [imageBodyString appendFormat:@"Content-Disposition: form-data; name=\"PICFile\"; filename=\"1234.JPG\"\r\n"];
//    [imageBodyString appendString:@"Content-Type: application/json\r\n"];
//    [imageBodyString appendFormat:@"Content-Length: %d\r\n",[imageData length]];
//    [imageBodyString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
//    
//    
//    NSMutableString *picBodyString2 = [[NSMutableString alloc]init];
//    [picBodyString2 appendFormat:@"\r\n%@\r\n",MPboundary];
//    //添加字段名称，换2行
//    [picBodyString2 appendFormat:@"Content-Disposition: form-data; name=\"pic\"\r\n"];
//    [picBodyString2 appendString:@"Content-Type: application/json; charset=UTF-8\r\n"];
//    [picBodyString2 appendFormat:@"Content-Length: %d\r\n",[jsonData length]];
//    [picBodyString2 appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    
//    [myRequestData appendData:[imageBodyString dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData appendData:imageData];
//    [myRequestData appendData:[picBodyString2 dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData appendData:jsonData];
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//   
//    
//    NSString *resultString = [[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding];
//    
//    //NSLog(@"%@",resultString);
//}
//
//
//- (void)testUploadImage
//{
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:@"shop" forKey:@"modeltype"];
//    [parameter setObject:@"14187011811100592" forKey:@"modelid"];
//
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://192.168.10.209/sdp/awj/attachment.json/upload" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//    {
//        UIImage *image = [UIImage imageNamed:@"100"];
//        
//        [formData appendPartWithFileData:[UIImage imageObjectToData:image andCompressionQuality:1.0 andMaxSize:100] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
//    } error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error)
//        {
//            //NSLog(@"Error: %@", error);
//        } else
//        {
//            //NSLog(@"%@ %@", response, responseObject);
//        }
//    }];
//    
//    [uploadTask resume];
//}
//
//@end
