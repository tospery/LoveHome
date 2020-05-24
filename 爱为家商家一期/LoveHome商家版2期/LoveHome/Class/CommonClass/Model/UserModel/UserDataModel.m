//
//  UserModel.m
//  LoveHome
//
//  Created by Joe Chen on 14/11/24.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "UserDataModel.h"

@implementation UserDataModel

MJCodingImplementation

+ (UserDataModel *)fetch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[UserDataModel getLocalFile]];
}

+ (void)storage:(UserDataModel *)user {
    [NSKeyedArchiver archiveRootObject:user toFile:[UserDataModel getLocalFile]];
}

+ (NSString *)getLocalFile
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"];
}

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
    return oldValue;
}






@end
