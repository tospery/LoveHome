//
//  LHIntroStep3Panel.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/2/24.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHIntroStep3Panel.h"

@implementation LHIntroStep3Panel
- (IBAction)entryButtonPressed:(id)sender {
    [self.parentIntroductionView skipIntroductionWithAnimated:NO];
}
@end
