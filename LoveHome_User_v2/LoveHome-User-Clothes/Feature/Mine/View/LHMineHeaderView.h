//
//  SYHeadInfoView3.h
//  Seeyou
//
//  Created by upin on 13-12-20.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LHMineHeaderViewSettingPressedBlock)(void);
typedef void(^LHMineHeaderViewProfilePressedBlock)(void);
typedef void(^LHMineHeaderViewFavoritePressedBlock)(void);

@interface LHMineHeaderView : UIView
{
    BOOL touch1,touch2,hasStop;
    BOOL isrefreshed;
}
@property (weak, nonatomic) IBOutlet UIImageView *img_banner;

@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *mobileLabel;
@property (nonatomic, weak) IBOutlet UILabel *areaLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *favoriteLabel;
@property (nonatomic, weak) IBOutlet UIButton *avatarButton;

//注意看 scrollView 的回调
@property(nonatomic) BOOL touching;
@property(nonatomic) float offsetY;

@property(copy,nonatomic)void(^handleRefreshEvent)(void) ;
-(void)stopRefresh;

- (void)setupSettingPressed:(LHMineHeaderViewSettingPressedBlock)settingPressed
             profilePressed:(LHMineHeaderViewProfilePressedBlock)profilePressed
            favoritePressed:(LHMineHeaderViewFavoritePressedBlock)favoritePressed;
@end
