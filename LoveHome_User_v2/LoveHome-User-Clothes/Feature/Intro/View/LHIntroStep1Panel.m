//
//  LHIntroStep1Panel.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/2/24.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHIntroStep1Panel.h"

@implementation LHIntroStep1Panel
- (IBAction)entryButtonPressed:(id)sender {
    [self.parentIntroductionView skipIntroductionWithAnimated:NO];
}
@end
