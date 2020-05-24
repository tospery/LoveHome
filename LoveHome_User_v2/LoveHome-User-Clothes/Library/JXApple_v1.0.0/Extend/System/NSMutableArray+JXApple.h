//
//  NSMutableArray+JXApple.h
//  TianlongHome
//
//  Created by 杨建祥 on 15/5/2.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (JXApple)
- (void)exInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index unduplicated:(BOOL)unduplicated;
- (void)exAddObject:(id)anObject;
@end
