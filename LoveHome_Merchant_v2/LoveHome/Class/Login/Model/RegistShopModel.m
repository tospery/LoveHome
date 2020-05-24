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


- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    
    
    if (!oldValue||[oldValue isKindOfClass:[NSNull class]]) {
        
        if ([property.type.typeClass isSubclassOfClass:[NSString class]]) {
            return @"";
        }
        else
        {
            return nil;
        }
    }
    
    //    if ([property.name isEqualToString:@"orderTime"]) {
    //
    //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[oldValue doubleValue]/1000];
    //    }
    
    return oldValue;
}
- (NSString *)getShopDesformat
{

    NSString *shopDes = [_shopDescription stringByReplacingOccurrencesOfString:@"," withString:@"###"];
    return shopDes;
}


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

- (void)setServerCoverStr:(NSString *)serverCoverStr
{
#pragma mark - 修改区域选择器
    _serverCoverStr = serverCoverStr;
    //@"500M",@"1KM",@"2KM",@"3KM",@"5KM",@"10KM",@"全城"
    if ([_serverCoverStr isEqualToString:@"500M"]) {
        
        [UserTools sharedUserTools].registShopModel.coverage = 1;
    }
    if ([_serverCoverStr isEqualToString:@"1KM"]) {
        
        [UserTools sharedUserTools].registShopModel.coverage = 1;
    }
    if ([_serverCoverStr isEqualToString:@"2KM"]) {
        
        [UserTools sharedUserTools].registShopModel.coverage = 2;
    }

    if ([_serverCoverStr isEqualToString:@"3KM"]) {
        
        [UserTools sharedUserTools].registShopModel.coverage = 3;
    }
    if ([_serverCoverStr isEqualToString:@"5KM"]) {
        [UserTools sharedUserTools].registShopModel.coverage = 5;
    }
    if ([_serverCoverStr isEqualToString:@"10KM"]) {
        [UserTools sharedUserTools].registShopModel.coverage = 10;
    }
    if ([_serverCoverStr isEqualToString:@"全城"]) {
        [UserTools sharedUserTools].registShopModel.coverage = -1;
    }
}
@end
