//
//  NSString+StringManage.h
//  BangBang
//
//  Created by Joe Chen on 13-10-6.
//  Copyright (c) 2013年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 宏管理 -
#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define TT_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

#if TT_ARC_ENABLED
#define TT_RETAIN(xx) (xx)
#define TT_RELEASE(xx)  xx = nil
#define TT_AUTORELEASE(xx)  (xx)
#else
#define TT_RETAIN(xx)           [xx retain]
#define TT_RELEASE(xx)          [xx release], xx = nil
#define TT_AUTORELEASE(xx)      [xx autorelease]
#endif

#ifndef TTRSLog
#if DEBUG
# define TTRSLog(fmt, ...) //NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TTRSLog(fmt, ...)
#endif
#endif

/*
 * 判断当前系统是否大于自定的version
 */
#define SYSTEM_VERSION_MORETHAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending)
/*
 * 判断当前系统是否小于自定的version
 */
#define SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)


/*
 * 判断当前系统是否是IOS7
 */
#define isIOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)?YES:NO)
/*
 * 获取Document的路径
 */
#define DocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
/*
 * PushController
 */
#define JCPUSHCCONTROLLER(classname,x) {classname *registerController = [[classname alloc] initWithNibName:x bundle:[NSBundle mainBundle]];[self.navigationController pushViewController:registerController animated:YES];[registerController release];}

#define IMAGE_WITH_NAME(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:name]]

#define kCellLineColor                  (COLOR_CUSTOM(225, 225, 225,1))

#define COLOR_CUSTOM(redColor,greenColor,blueColor,alphaColor) [UIColor colorWithRed:redColor/255.0 green:greenColor/255.0 blue:blueColor/255.0 alpha:alphaColor]
#define COLOR_HEX(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kPlainTextColor                 (ColorHex(0x333333))
#define kPlainTextLightColor            (ColorHex(0x666666))
#define ColorHex(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LOGIN @"login"
#define SCREEN_HIGHT     [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width


/*
 *  通知Key管理
 */
#pragma mark - 个人中心设置通知
#define kHomePageReload @"homePageReload"
#define Change_MyselfInfo @"mySettingViewReloadData"
#define kChangeHomeData @"changeMyHomePageData"
#define kDeviceUpdate @"isDeviceUpdate"
#define kUserLoginOut @"userLoginOut"

#define AWKS_GET_AUTOLOGIN  @"aiweiksautologins"                   //自动登录
#define AWKS_GET_ShopStatu @"shopStatus"                           //是否开店

#pragma mark - 静态文字信息管理 -
/*******************网络相关keys管理******************/
/*
 * 功能说明： 获取登录
 *
 * 参数说明:
 *          phoneNumber   : 手机号
 *          password      : 密码
 */
#define AWKS_GetLoginUrl    @"awj/user.json/login"




/*
 * 功能说明： 验证手机号码是否有效
 *
 * 参数说明:
 *          telphone   : 手机号
 *          type       : 接口功能类型（1:注册 2:忘记密码 3:更改绑定手机）
 */
#define AWKS_ValidateTelphoneNumberCodeUrl    @"awj/user.json/telnovalidate"


/*
 * 功能说明： 获取验证码
 *
 * 参数说明:
 *          telphone   : 手机号
 */
#define AWKS_GetSecurityCodeUrl    @"awj/user.json/getseccode"

/*!
 *  @brief  修改用户信息
 *
 *  @return 
 */

#define AWKS_EditingUserInfo @"awj/user.json/usermsgupdate"


/*
 * 功能说明： 注册
 *
 * 参数说明:
 *          telphone        : 手机号
 *          password        : 密码
 *          securityCode    : 验证码
 */
#define AWKS_GetRegistUrl    @"awj/user.json/regist"


/*
 * 功能说明： 忘记密码
 *
 * 参数说明:
 *          telphone        : 手机号
 *          password        : 新密码
 *          securityCode    : 验证码
 */
#define AWKS_GetResetPasswordUrl    @"awj/user.json/retrievepwd"


/*
 * 功能说明： 更新用户基本信息
 *
 * 参数说明:
 */
#define AWKS_GetUpdateUserUrl    @"awj/user.json/usermsgUpdate"


/*
 * 功能说明： 获取产品列表
 *
 * 参数说明:
 */
#define AWKS_GetProductListUrl    @"awj/product.json/list"


/*
 * 功能说明： 获取商铺2级类别及产品类别
 *
 * 参数说明:
 */



#define AWKS_GetShopCategory @"awj/prodtype.json/listtemp"



/*
 * 功能说明： 创建店铺
 *
 * 参数说明:
 */
#define AWKS_CreatShopUrl   @"awj/shop.json/add"

/*!
 *  @brief  编辑店铺
 *
 *  @return
 */
	

#define AWKS_EditingShioUrl @"awj/shop.json/edit"

/*!
 *  @brief  上传附件
 */
#define AWKS_UpLoadUrl @"awj/attachment.json/upload?modeltype=%@&modelid=%@"


/*!
 *  @brief  认证接口
 *
 *  @return
 */
#define AWKS_AutoInfoUrl @"awj/authentication.json/doapple"

/*!
 *  @brief  获取分类
 *
 *  @return 
 */
#define AWKS_GetCategoryUrl @"awj/prodtype.json/listtype"


/*
 * 功能说明： 添加商品
 *
 * 参数说明:
 */
#define AWKS_GetAddProductUrl   @"awj/product.json/add"


#define AWKS_GetShevel @"awj/product.json/shelves"	


/****************模板相关接口****************/



/*
 * 功能说明：添加类别模块
 *
 * 参数说明:
 */
#define AWKS_AddCategoryUrl @"awj/prodtype.json/doinsert"

/*
 * 功能说明： 修改类别模板
 *
 * 参数说明:
 */
#define AWKS_EditingCategoryModel @"awj/prodtype.json/doupdate"


/*
 * 功能说明： 删除类别模板
 *
 * 参数说明:
 */


#define AWKS_DeleteCategoryModelUrl @"awj/prodtype.json/dodeleteprodtype"

/*
 * 功能说明： 添加产品模板
 *
 * 参数说明:
 */
#define AWKS_AddProductModel @"awj/prodtmp.json/doinsert"



/*
 * 功能说明： 修改产品模板
 *
 * 参数说明:
 */
#define AWKS_EditingModel @"awj/prodtmp.json/doupdate"



/*
 * 功能说明： 删除产品模板
 *
 * 参数说明:
 */

#define AWKS_DeleteProTmModel @"awj/prodtmp.json/dodeletetmp"


/*
 * 功能说明： 删除商品
 *
 * 参数说明:
 */
#define AWKS_GetDeleteProductUrl   @"awj/product.json/delete"


/*
 * 功能说明： 更新商品
 *
 * 参数说明:
 */
#define AWKS_GetUpdateProductUrl   @"awj/product.json/edit"

/*
 * 功能说明： 编辑产品模板
 *
 * 参数说明:
 */
#define AWKS_EditingProTmUrl @""


/*
 * 功能说明： 获取订单
 *
 * 参数说明:
 */
#define AWKS_GetOrderstUrl @"awj/order.json/listshoporder"

/*
 * 功能说明： 订单状态改变
 *
 * 参数说明:
 */
#define AWKS_ChangeOrderFlow @"awj/order.json/changeorderflow"

/*
 * 功能说明： 获取广告数据
 *
 * 参数说明:
 */
#define AWKS_GetAdvertDataUrl @"awj/poster.json/doselectbytype"

/*
 * 功能说明： 获取用户钱包信息
 *
 * 参数说明:
 */

/*
 * 功能说明： 页面背景
 * 参数说明:
 */

#define BackGroudColor  [UIColor colorWithRed:244/255.0 green:243/255.0 blue:241/255.0 alpha:1]

#define AWKS_GetUserWalletMoney @"awj/wallet.json/getwallet"

/*******************网络相关异常消息的keys管理******************/
//Session过期
static  NSString *const HttpRequestFailed_MsgKey_SessionInvaild              = @"EXCEPTION_LOGIN_ERROR_1";
//手机号码已被注册
static  NSString *const HttpRequestFailed_MsgKey_TelphoneDidRegisted         = @"USER_TELNOVALIDATE_FAIL_1";
//手机号码尚未注册
static  NSString *const HttpRequestFailed_MsgKey_TelphoneUnRegisted          = @"USER_TELNOVALIDATE_FAIL_2";
//手机号码重复绑定
static  NSString *const HttpRequestFailed_MsgKey_TelphoneDidBinding          = @"USER_TELNOVALIDATE_FAIL_3";
//登录－用户没有注册
static  NSString *const HttpRequestFailed_MsgKey_UserUnRegisted              = @"USER_LOGIN_FAIL_1";
//登录－用户账号或密码错误
static  NSString *const HttpRequestFailed_MsgKey_UserAccountAndPasswordError = @"USER_LOGIN_FAIL_2";


/*******************提示消息管理******************/
//图片上传失败
static  NSString *const AppAlertMessageManage_UploadImageFailed      = @"图片上传失败";
//图片删除失败
static  NSString *const AppAlertMessageManage_UpdateImageFailed      = @"图片更新失败";
//产品创建成功
static  NSString *const AppAlertMessageManage_AddProductSucceed      = @"商品创建成功";
//产品创建失败
static  NSString *const AppAlertMessageManage_AddProductFailed       = @"商品创建失败";
//产品更新成功
static  NSString *const AppAlertMessageManage_UpdateProductSucceed   = @"商品更新成功";
//产品更新失败
static  NSString *const AppAlertMessageManage_UpdateProductFailed    = @"商品更新失败";
//没有店铺提示
static  NSString *const AppAlertMessageManage_WithoutShop            = @"您还没有店铺哦，请先创建店铺。";


#pragma mark - 归档路径

// 我的商铺
#define kShopLocalPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"myShop.data"]

// 上架产品类别
#define kShopItemsShelvesPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"myShopItemShelves.data"]



// 下架产品类别
#define kShopItemsUnShelvesPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"myShopItemUnShelves.data"]


// 模板类别数据
#define kShopCategoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"myShopCategory.data"]



#define KshopCategoryWithProduct @"currentShopCategory"

#pragma mark - 正则表达式 -



#pragma mark - 通知名管理 -
//注册成功的通知
static NSString *const AWKS_App_UserModule_RigistSucceed = @"rigistrusseedofusermodule";


#pragma mark - SQLite数据存储table名 -



#pragma mark - 数据库的DBName -



#pragma mark - 数据存储－文件名管理 -


#pragma mark - 数据请求超时时间限定 -
#define NET_REQUEST_OUTTIMELIMIT 30


#pragma mark - App数据同步管理机制 -



#pragma mark - App全局数据设置 -

//应用是否第一次启动使用的标识
#define APP_FIRST_OPEN_MARK @"bsjWBNappFirstOpenMark"


@interface NSString (StringManage)

- (BOOL)containsString:(NSString *)aString;
- (NSString*)telephoneWithReformat;
+(BOOL)isNullString:(id)vaule;


/*!
 *  @brief  获取某个对象的某个属性的名字
 *
 *  @param property  对象的某个属性
 *  @param className 解析的对象
 *
 *  @return NSString
 */
NSString     * NSStringFromProperty(NSObject* property, NSObject* className);

/*!
 *  @brief  获取某个对象的所有属性名字
 *
 *  @param className 解析的对象
 *
 *  @return 所有的属性名数组
 */
NSArray * NSArrayFromClassAllProperty(NSObject* className);



/**************************字符加密相关******************************/
//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;
//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString;
//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString;
//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString;
//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString;
/**************************字符加密相关******************************/


#define kStringServerException          (@"服务器异常，请稍后重试")
@end
