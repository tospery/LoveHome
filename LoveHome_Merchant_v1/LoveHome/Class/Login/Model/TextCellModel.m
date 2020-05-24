//
//  TextCellModel.m
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "TextCellModel.h"

@implementation TextCellModel
- (instancetype)initWithPlaceString:(NSString *)place andContent:(NSString *)content isInteractionEnbled:(BOOL)enbled
{
    self = [super init];
    if (self) {
        self.placeString= place;
        self.contentString = content;
        self.isInteractionEnabled = enbled;
        self.keybordType = UIKeyboardTypeDefault;
    }
    return self;
}
@end
