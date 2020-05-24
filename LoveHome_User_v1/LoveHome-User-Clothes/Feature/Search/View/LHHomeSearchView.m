//
//  LHHomeSearch.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/13.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHHomeSearchView.h"

@interface LHHomeSearchView ()
@property (nonatomic, weak) IBOutlet UIView *bgView;
@end

@implementation LHHomeSearchView
- (void)awakeFromNib {
    [self.bgView exSetBorder:JXColorHex(0xE1E1E1) width:1.0 radius:6.0];
}

- (IBAction)buttonPressed:(id)sender {
    if (_pressBlock) {
        _pressBlock();
    }
}
@end
