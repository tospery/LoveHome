//
//  NSManagedObject+LoveHome.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/10.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "NSManagedObject+LoveHome.h"

@implementation NSManagedObject (LoveHome)
+ (id)CreatEntityName:(NSString *)name
{
    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:kContentx];
    NSManagedObject *obj = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:kContentx];
    return obj;
    
}

+ (id)CreatNewMoldeWithName:(NSString *)name
{
    NSEntityDescription *desc = [NSEntityDescription entityForName:name inManagedObjectContext:kContentx];
    NSManagedObject *newModel = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:nil];
    return newModel;
}
@end
