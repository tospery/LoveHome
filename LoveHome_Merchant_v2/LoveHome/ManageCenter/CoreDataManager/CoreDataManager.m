//
//  CoreDataManager.m
//  2014.10.17-数据持久化
//
//  Created by MRH on 14-7-22.
//  Copyright (c) 2014年 MRH. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

@interface CoreDataManager ()

+ (NSManagedObjectContext *)managedObjectContext;

@end

@implementation CoreDataManager

+ (NSManagedObjectContext *)managedObjectContext {
    
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (BOOL)insertObjectWithParameters:(NSDictionary *)parameters entityName:(NSString *)entityName {
    
    // 异常判断
    if ([entityName length] == 0) {
        return NO;
    }
    
    // 获取程序唯一上下文
    NSManagedObjectContext *context = [self managedObjectContext];
    // 创建对象
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];

    for (NSString *key in parameters) {
        [object setValue:parameters[key] forKey:key];
    }

   
    
    // 保存上下文
    NSError *error = nil;
    BOOL success = [context save:&error];
    if (!success) {
//        //NSLog(@"context save operation did failed with error message '%@'.", [error localizedDescription]);
    }
    
    return success;
}

+ (NSArray *)searchObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString {
    
        
        if ([entityName length] == 0) {
            return nil;
        }
        // 获取唯一上下文
        NSManagedObjectContext *context = [self managedObjectContext];
        // 初始化查询请求
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];

//        排序
//        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
//        fetchRequest.sortDescriptors = [NSArray arrayWithObject:sort];
        // 初始化谓词查询条件
        if ([predicateString length] != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            fetchRequest.predicate = predicate;
        }
        // 执行查询
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        // 失败
        if (error) {
//            //NSLog(@"context fetch operation did failed with error message '%@'.", [error localizedDescription]);
            return nil;
        }
        // 成功
        else {
            return objects;
        }
    
}

+ (BOOL)deleteObjectsWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString {
    
    if ([entityName length] == 0) {
        return NO;
    }
    // 查询需要删除对象
    NSArray *objects = [self searchObjectsWithEntityName:entityName predicateString:predicateString];
    // 遍历删除
    NSManagedObjectContext *context = [self managedObjectContext];
    for (id object in objects) {
        [context deleteObject:object];
    }
    // 保存
    NSError *error = nil;
    BOOL success = [context save:&error];
    if (!success) {
//        //NSLog(@"delete operation did failed with error message '%@'.", [error localizedDescription]);
    }
    return success;
}

+ (BOOL)updateObjectsWithEntityName:(NSString*)entityName predicateString:(NSString *)predicateString  withNewData:(NSDictionary*)newData
{
    if (entityName.length != 0) {
        //需要修改的对象
        NSArray *arry = [CoreDataManager searchObjectsWithEntityName:entityName predicateString:predicateString];
        id obj = NSClassFromString(entityName);
        for (obj in arry) {
            for (NSString *key in newData) {
                [obj setValue:newData[key] forKey:key];
            }
        }
        
        NSManagedObjectContext *context = [self managedObjectContext];
        // 保存
        NSError *error = nil;
        BOOL success = [context save:&error];
        if (!success) {
//            //NSLog(@"delete operation did failed with error message '%@'.", [error localizedDescription]);
        }

    }
        return YES;
}

- (void)connection
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"sad"]];
    request.HTTPMethod = @"POST";

//    NSURLConnection *con =  [NSURLConnection connectionWithRequest:<#(NSURLRequest *)#> delegate:self];

}

@end











