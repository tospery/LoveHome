//
//  LHProfileViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHProfileViewController.h"
#import "LHProfileAvatarCell.h"
#import "LHProfileCommonCell.h"
#import "LHProfileNicknameViewController.h"
#import "LHReceiptViewController.h"
#import "LHPhoneVerifyViewController.h"

@interface LHProfileViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHProfileViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark - Private methods
- (void)initView {
    self.navigationItem.title = @"个人信息";
    
    UINib *cellNib = [UINib nibWithNibName:@"LHProfileAvatarCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHProfileAvatarCell identifier]];
    cellNib = [UINib nibWithNibName:@"LHProfileCommonCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHProfileCommonCell identifier]];
}

- (void)requestUploadWithMode:(JXWebLaunchMode)mode image:(UIImage *)image {
    HUDProcessing(@"正在上传");
    [LHHTTPClient uploadWithImage:image success:^(NSURLResponse *urlResponse, NSString *imageURLString) {
        JXHUDHide();
//        if (guid.length != 0) {
//            gLH.user.info.icon = ImageURLString(guid, 3);
//        }
        gLH.user.info.icon = imageURLString;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSURLResponse *urlResponse, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestUploadWithMode:mode image:image];
        }];
    } progress:NULL];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return [LHProfileAvatarCell height];
    }else {
        return [LHProfileCommonCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHProfileAvatarCell identifier]];
        [[(LHProfileAvatarCell *)cell avatarImageView] sd_setImageWithURL:[NSURL URLWithString:gLH.user.info.icon] placeholderImage:kImagePHUserAvatar];
        return cell;
    }else if (1 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHProfileCommonCell identifier]];
        [(LHProfileCommonCell *)cell myTitleLabel].text = @"昵称";
        [(LHProfileCommonCell *)cell myContentLabel].font = [UIFont systemFontOfSize:16.0f];
        [(LHProfileCommonCell *)cell myContentLabel].text = gLH.user.info.nickName;
        return cell;
    }else if (2 == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHProfileCommonCell identifier]];
        [(LHProfileCommonCell *)cell myTitleLabel].text = @"修改绑定手机";
        [(LHProfileCommonCell *)cell myContentLabel].font = [UIFont systemFontOfSize:16.0f];
        [(LHProfileCommonCell *)cell myContentLabel].text = gLH.user.info.phoneNumber;
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHProfileCommonCell identifier]];
        [(LHProfileCommonCell *)cell myTitleLabel].text = @"我的收货地址";
        if (gLH.user.info.receiptAddr.length > 7) {
            [(LHProfileCommonCell *)cell myContentLabel].font = [UIFont systemFontOfSize:14.0f];
        } else {
            [(LHProfileCommonCell *)cell myContentLabel].font = [UIFont systemFontOfSize:16.0f];
        }
        [(LHProfileCommonCell *)cell myContentLabel].text = (gLH.user.info.receiptAddr.length == 0 ? @"请添加收货地址" : gLH.user.info.receiptAddr);
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        [self displayPhotoSheetWithWillSuccess:^(UIImage *image) {
            [self requestUploadWithMode:JXWebLaunchModeHUD image:image];
        } didSuccess:NULL failure:^(NSError *error) {
            [self.view makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
        }];
    }else if (1 == indexPath.row) {
        [self.navigationController pushViewController:[LHProfileNicknameViewController new] animated:YES];
    }else if (2 == indexPath.row) {
        static LHPhoneVerifyViewController *paywordVC;
        if (!paywordVC) {
            paywordVC = [[LHPhoneVerifyViewController alloc] initWithMode:LHAccountModeVerifyChangePhone];
        }
        [self.navigationController pushViewController:paywordVC animated:YES];
    }else {
        LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
        vc.from = LHReceiptFromManage;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}
@end
