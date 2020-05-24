//
//  CoreDataManager.h
//  2014.10.17-数据持久化
//
//  Created by  on 14-10-17.
//  Copyright (c) 2014年 MRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

// 数据添加
+ (BOOL)insertObjectWithParameters:(NSDictionary *)parameters entityName:(NSString *)entityName;

// 数据查询
+ (NSArray *)searchObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

// 数据删除
+ (BOOL)deleteObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

//
+ (BOOL)updateObjectsWithEntityName:(NSString*)entityName predicateString:(NSString *)predicateString  withNewData:(NSDictionary*)newData;

@end










