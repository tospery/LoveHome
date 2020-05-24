//
//  LHV2DueFooter.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHV2DueFooter.h"

@interface LHV2DueFooter ()
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@end

@implementation LHV2DueFooter
- (void)awakeFromNib {
    // Initialization code
    [self.clearButton exSetBorder:[UIColor darkGrayColor] width:1.0 radius:4.0];
}

- (IBAction)clearButtonPressed:(id)sender {
    if (self.clearCallback) {
        self.clearCallback();
    }
}

+ (NSString *)identifier {
    return @"LHV2DueFooterIdentifier";
}

+ (CGFloat)height {
    return 50.0f;
}

@end
