//
//  NSManagedObject+LoveHome.h
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/10.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (LoveHome)
// 创建entity实体
+ (id)CreatEntityName:(NSString *)name;

// 创建新的Model对象
+ (id)CreatNewMoldeWithName:(NSString *)name;
@end
