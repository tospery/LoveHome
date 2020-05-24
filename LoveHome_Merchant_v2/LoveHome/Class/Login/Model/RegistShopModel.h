//
//  RegistShopModel.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"

@interface RegistShopModel : BaseDataModel

@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *passWord;
@property (nonatomic,strong) NSNumber *channel;             //  支付方式 0电子钱包 1支付宝 2银联 3微信
@property (nonatomic,strong) NSString *bankCardNo;          //  银行卡号
@property (nonatomic,strong) NSString *bankCardName;        //  持卡人姓名
@property (nonatomic,strong) NSString *shopName;            //  商铺名称
@property (nonatomic,strong) NSString *bussinessScope;      //  经营范围
@property (nonatomic,strong) NSString *shopAddress;         //  详情地址
@property (nonatomic,strong) NSString *shopProvince;        //  省
@property (nonatomic,strong) NSString *shopCity;            //  市
@property (nonatomic,strong) NSString *shopDistrict;        //  区
@property (nonatomic,assign) NSInteger coverage;            //  -1 全城
@property (nonatomic,strong) NSString *serviceStartTime;    //  服务时间
@property (nonatomic,strong) NSString *serviceEndTime;
@property (nonatomic,strong) NSNumber *authType;            //  认证类型 1.个人 2.企业
@property (nonatomic,strong) NSString *telPhone;
@property (nonatomic,strong) NSNumber *latitude;            //  纬度
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSString *shopContartName;     //  负责人姓名

/*****temp表示临时显示字段不上去服务器*****/
@property (nonatomic,strong) NSString *cityDistrict;        //  省市区显示(temp)
@property (nonatomic,strong) NSString *serverCoverStr;      //  显示title(temp)
@property (nonatomic,strong) NSString *shopDescription;     //  商铺描述((temp))
@property (nonatomic,strong) UIImage *shopLogo;             //  商铺图片（temp）



+(NSString *)selectDistictIdWithDistrictName:(NSString *)district;
- (NSString *)getShopDesformat;

@end
