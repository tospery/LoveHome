//
//  LHSearchBackView.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/23.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHSearchBackView.h"

@implementation LHSearchBackView

- (IBAction)buttonPressed:(id)sender {
    if (_pressBlock) {
        _pressBlock();
    }
}

@end
