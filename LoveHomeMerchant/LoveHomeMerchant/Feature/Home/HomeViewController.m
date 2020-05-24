//
//  HomeViewController.m
//  LoveHomeMerchant
//
//  Created by 杨建祥 on 16/3/19.
//  Copyright © 2016年 iOSTeam. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "HomeHeaderView.h"
#import "OrderCell.h"
#import "LoginViewModel.h"

@interface HomeViewController ()
@property (nonatomic, strong, readonly) HomeViewModel *viewModel;
@property (nonatomic, strong) HomeHeaderView *tableHeaderView;

@end

@implementation HomeViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil].firstObject;
    [self.tableHeaderView bindViewModel:self.viewModel.headerViewModel];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    if (viewModel.shouldRequestRemoteDataOnViewDidLoad) {
//        [[self rac_signalForSelector:@selector(awakeFromNib)] subscribeNext:^(id x) {
//            @strongify(self)
//            [self.viewModel.requestRemoteDataCommand execute:nil];
//        }];
//    }
    
    // YJX_TODO 对于进入需要更新的View，shouldRequestRemoteData
    @weakify(self)
    if(self.viewModel.headerViewModel.shouldRequestRemoteDataOnViewDidLoad) {
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
           @strongify(self)
            //[self.tableHeaderView.viewModel.requestRemoteDataCommand execute:nil];
            [self.viewModel.headerViewModel.requestOrderCountCommand execute:nil];
            [self.viewModel.headerViewModel.requestUnreadCountCommand execute:nil];
            [self.viewModel.headerViewModel.requestVisitTotalCommand execute:nil];
        }];
    }
}

@end



//@interface MRCProfileViewController ()
//
//@property (nonatomic, strong, readonly) MRCProfileViewModel *viewModel;
//@property (nonatomic, strong) MRCAvatarHeaderView *tableHeaderView;
//
//@end
//
//@implementation MRCProfileViewController
//
//@dynamic viewModel;
//
//- (instancetype)initWithViewModel:(MRCViewModel *)viewModel {
//    self = [super initWithViewModel:viewModel];
//    if (self) {
//        if (self.viewModel.avatarHeaderViewModel.user.avatarURL) {
//            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[ self.viewModel.avatarHeaderViewModel.user.avatarURL ]];
//        }
//    }
//    return self;
//}
//
//
//- (UIEdgeInsets)contentInset {
//    return UIEdgeInsetsMake(0, 0, 49, 0);
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
//    self.viewModel.avatarHeaderViewModel.contentOffset = contentOffset;
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return section == 0 ? 4 : 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"MRCTableViewCellStyleValue1" forIndexPath:indexPath];
//    
//    cell.accessoryType  = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Organization"
//                                                  backgroundColor:UIColor.clearColor
//                                                        iconColor:HexRGB(0x24AFFC)
//                                                        iconScale:1
//                                                          andSize:MRC_LEFT_IMAGE_SIZE];
//            cell.textLabel.text = self.viewModel.company;
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        } else if (indexPath.row == 1) {
//            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Location"
//                                                  backgroundColor:UIColor.clearColor
//                                                        iconColor:HexRGB(0x30C931)
//                                                        iconScale:1
//                                                          andSize:MRC_LEFT_IMAGE_SIZE];
//            cell.textLabel.text = self.viewModel.location;
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        } else if (indexPath.row == 2) {
//            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Mail"
//                                                  backgroundColor:UIColor.clearColor
//                                                        iconColor:HexRGB(0x5586ED)
//                                                        iconScale:1
//                                                          andSize:MRC_LEFT_IMAGE_SIZE];
//            cell.textLabel.text = self.viewModel.email;
//            
//            if ([self.viewModel.email isEqualToString:MRC_EMPTY_PLACEHOLDER]) {
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            } else {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//        } else if (indexPath.row == 3) {
//            cell.imageView.image = [UIImage octicon_imageWithIcon:@"Link"
//                                                  backgroundColor:UIColor.clearColor
//                                                        iconColor:HexRGB(0x90DD2F)
//                                                        iconScale:1
//                                                          andSize:MRC_LEFT_IMAGE_SIZE];
//            cell.textLabel.text = self.viewModel.blog;
//            
//            if ([self.viewModel.blog isEqualToString:MRC_EMPTY_PLACEHOLDER]) {
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            } else {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            }
//        }
//    } else if (indexPath.section == 1) {
//        cell.imageView.image = [UIImage octicon_imageWithIcon:@"Gear"
//                                              backgroundColor:UIColor.clearColor
//                                                    iconColor:HexRGB(0x24AFFC)
//                                                    iconScale:1
//                                                      andSize:MRC_LEFT_IMAGE_SIZE];
//        cell.textLabel.text = @"Settings";
//        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section == 0 ? 20 : 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return (section == tableView.numberOfSections - 1) ? 20 : 10;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 2) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.viewModel.email]]];
//        } else if (indexPath.row == 3) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.viewModel.blog]];
//        }
//    } else {
//        [self.viewModel.didSelectCommand execute:indexPath];
//    }
//}
//
//@end
//
