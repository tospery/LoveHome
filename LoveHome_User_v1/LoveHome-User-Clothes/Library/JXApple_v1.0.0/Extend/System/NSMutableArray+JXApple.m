//
//  NSMutableArray+JXApple.m
//  TianlongHome
//
//  Created by 杨建祥 on 15/5/2.
//  Copyright (c) 2015年 杨建祥. All rights reserved.
//

#import "NSMutableArray+JXApple.h"
#import "NSArray+JXApple.h"

@implementation NSMutableArray (JXApple)
- (void)exInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index unduplicated:(BOOL)unduplicated {
    if (!unduplicated) {
        NSRange range = NSMakeRange(index, objects.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self insertObjects:objects atIndexes:indexSet];
        return;
    }
    
    for (id obj in objects) {
        if (![self containsObject:obj]/* && ![self exContainsValue:obj]*/) {
            [self insertObject:obj atIndex:index++];
        }
    }
}

- (void)exAddObject:(id)anObject {
    if (!anObject) {
        return;
    }
    
    [self addObject:anObject];
}
@end
