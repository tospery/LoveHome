//
//  LHCoreDataManager.h
//  LoveHome-User-Clothes
//
//  Created by 李俊辉 on 15/7/28.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHCoreDataManager : NSObject

// 数据添加
+ (BOOL)insertObjectWithParameters:(NSDictionary *)parameters entityName:(NSString *)entityName;

// 数据查询
+ (NSArray *)searchObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

// 数据删除
+ (BOOL)deleteObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

//
+ (BOOL)updateObjectsWithEntityName:(NSString*)entityName predicateString:(NSString *)predicateString  withNewData:(NSDictionary*)newData;

@end
