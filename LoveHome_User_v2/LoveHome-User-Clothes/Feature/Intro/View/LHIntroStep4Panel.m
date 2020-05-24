//
//  LHIntroStep3Panel.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/21.
//  Copyright © 2015年 艾维科思. All rights reserved.
//

#import "LHIntroStep4Panel.h"

@interface LHIntroStep4Panel ()
@property (nonatomic, weak) IBOutlet UIButton *entryButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation LHIntroStep4Panel
-(void)awakeFromNib {
    [_entryButton exSetBorder:JXColorHex(0x27B1AC) width:1.0f radius:4.0f];
    
    JXDeviceResolution resolution = [JXDevice sharedInstance].resolution;
    if (JXDeviceResolution640x960 == resolution) {
        _bottomConstraint.constant = 40.0f;
    }
}

- (IBAction)entryButtonPressed:(id)sender {
    [self.parentIntroductionView skipIntroductionWithAnimated:NO];
}
@end
