//
//  RegistShopModel.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "RegistShopModel.h"
@implementation RegistShopModel
MJCodingImplementation




+(NSString *)selectDistictIdWithDistrictName:(NSString *)district
{
    NSString *districtId;
    if ([district isEqualToString:@"成华区"])  {
       
            districtId = @"510108";
    }
    if ([district isEqualToString:@"龙泉驿区"])  {
       
            districtId = @"510112";
    }
    if ([district isEqualToString:@"金牛区"])  {
        
            districtId = @"510106";
    }
    if ([district isEqualToString:@"武侯区"])  {
        
            districtId = @"510107";
    }
    if ([district isEqualToString:@"锦江区"])  {
        
            districtId = @"510104";
    }
    if ([district isEqualToString:@"青羊区"])  {
       
            districtId = @"510105";
    }
    if ([district isEqualToString:@"高新区"])  {
       
            districtId = @"510109";
    }
    if ([district isEqualToString:@"都江堰市"])  {
     
            districtId = @"510181";
    }
    if ([district isEqualToString:@"温江区"])  {
       
            districtId = @"510115";
    }

    if ([district isEqualToString:@"邛崃市"])  {
       
            districtId = @"510183";
    }

    if ([district isEqualToString:@"彭州市"])  {
       
            districtId = @"510182";
    }
    if ([district isEqualToString:@"新津县"])  {
     
            districtId = @"510132";
    }
    if ([district isEqualToString:@"郫县"])  {
        
            districtId = @"510124";
    }

    if ([district isEqualToString:@"青白江区"])  {

            districtId = @"510113";
    }
    if ([district isEqualToString:@"新都区"])  {
        
            districtId = @"510114";
    }
    if ([district isEqualToString:@"双流县"])  {
        
            districtId = @"510122";
    }
    if ([district isEqualToString:@"大邑县"])  {
        
            districtId = @"510129";
    }
    if ([district isEqualToString:@"崇州市"])  {
     
            districtId = @"510184";
    }
    if ([district isEqualToString:@"蒲江县"])  {
        
            districtId = @"510131";
    }
    if ([district isEqualToString:@"金堂县"])  {
        
            districtId = @"510121";
    }

        return districtId;
}
@end
