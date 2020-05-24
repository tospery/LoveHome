//
//  LHAddressManager.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/7/27.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "JXAddressManager.h"

@implementation JXProvince

@end

@implementation JXCity

@end

@implementation JXZone

@end


@implementation JXAddressManager
+ (NSArray *)getAllProvinces {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:50];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *rows = [doc nodesForXPath:@"//row" error:nil];
    for (DDXMLElement *row in rows) {
        JXProvince *province = [[JXProvince alloc] init];
        NSArray *elements = [row elementsForName:@"province_id"];
        province.uid = [(DDXMLElement *)elements[0] stringValue].integerValue;
        elements = [row elementsForName:@"province_name"];
        province.name = [(DDXMLElement *)elements[0] stringValue];
        [results addObject:province];
    }
    
    return results;
}

+ (NSArray *)findCitiesWithProvince:(JXProvince *)province {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:50];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *rows = [doc nodesForXPath:@"//row" error:nil];
    if(province) {
        for (DDXMLElement *row in rows) {
            NSArray *elements = [row elementsForName:@"province_id"];
            NSInteger provinceID = [(DDXMLElement *)elements[0] stringValue].integerValue;
            if (province.uid == provinceID) {
                JXCity *city = [[JXCity alloc] init];
                city.provinceID = provinceID;
                elements = [row elementsForName:@"is_hot"];
                city.isHot = [(DDXMLElement *)elements[0] stringValue].boolValue;
                elements = [row elementsForName:@"city_id"];
                city.uid = [(DDXMLElement *)elements[0] stringValue].integerValue;
                elements = [row elementsForName:@"state"];
                city.state = [(DDXMLElement *)elements[0] stringValue].integerValue;
                elements = [row elementsForName:@"city_name"];
                city.name = [(DDXMLElement *)elements[0] stringValue];
                elements = [row elementsForName:@"first_letter"];
                city.firstLetter = [(DDXMLElement *)elements[0] stringValue];
                [results addObject:city];
            }else {
                continue;
            }
        }
    }else {
        for (DDXMLElement *row in rows) {
            JXCity *city = [[JXCity alloc] init];
            NSArray *elements = [row elementsForName:@"is_hot"];
            city.isHot = [(DDXMLElement *)elements[0] stringValue].boolValue;
            elements = [row elementsForName:@"city_id"];
            city.uid = [(DDXMLElement *)elements[0] stringValue].integerValue;
            elements = [row elementsForName:@"province_id"];
            city.provinceID = [(DDXMLElement *)elements[0] stringValue].integerValue;
            elements = [row elementsForName:@"state"];
            city.state = [(DDXMLElement *)elements[0] stringValue].integerValue;
            elements = [row elementsForName:@"city_name"];
            city.name = [(DDXMLElement *)elements[0] stringValue];
            elements = [row elementsForName:@"first_letter"];
            city.firstLetter = [(DDXMLElement *)elements[0] stringValue];
            [results addObject:city];
        }
    }
    
    return results;
}

+ (NSArray *)findZonesWithCity:(JXCity *)city {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:50];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *rows = [doc nodesForXPath:@"//row" error:nil];
    if(city) {
        for (DDXMLElement *row in rows) {
            NSArray *elements = [row elementsForName:@"city_id"];
            NSInteger cityID = [(DDXMLElement *)elements[0] stringValue].integerValue;
            if (city.uid == cityID) {
                JXZone *region = [[JXZone alloc] init];
                region.cityID = cityID;
                elements = [row elementsForName:@"region_id"];
                region.uid = [(DDXMLElement *)elements[0] stringValue].integerValue;
                elements = [row elementsForName:@"region_name"];
                region.name = [(DDXMLElement *)elements[0] stringValue];
                [results addObject:region];
            }else {
                continue;
            }
        }
    }else {
        for (DDXMLElement *row in rows) {
            JXZone *region = [[JXZone alloc] init];
            NSArray *elements = [row elementsForName:@"city_id"];
            region.cityID = [(DDXMLElement *)elements[0] stringValue].integerValue;
            elements = [row elementsForName:@"region_id"];
            region.uid = [(DDXMLElement *)elements[0] stringValue].integerValue;
            elements = [row elementsForName:@"region_name"];
            region.name = [(DDXMLElement *)elements[0] stringValue];
            [results addObject:region];
        }
    }
    
    return results;
}
@end
