//
//  LHShopDetailViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/3.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHShopDetailViewController.h"
#import "LHStarView.h"
#import "LHShopDetailTitleView.h"
#import "LHProductListCell.h"
#import "AppDelegate.h"
#import "LHShopDetailMoreView.h"
#import "LHProductListView.h"
#import "LHShopMapViewController.h"
#import "LHCommentListViewController.h"
#import "LHCartViewController.h"

@interface LHShopDetailViewController ()
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, strong) NSString *favoriteID;

@property (nonatomic, assign) CGFloat productScrollViewHeight;
@property (nonatomic, strong) NSString *curBusiness;
@property (nonatomic, strong) NSArray *business;

@property (nonatomic, strong) NSString *curCategory;
@property (nonatomic, strong) NSMutableArray *categoryNames;
@property (nonatomic, strong) NSArray *categories;

//@property (nonatomic, strong) NSArray *products;

@property (nonatomic, assign) NSInteger shopid;
@property (nonatomic, strong) LHShop *shop;
@property (nonatomic, strong) LHShopDetailTitleView *titleView;
@property (nonatomic, strong) NSArray *businessMenuItems;

@property (nonatomic, strong) LHShopDetailMoreView *moreView;
@property (nonatomic, strong) LHProductListCell *productCell;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *servicesLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentLabel;
@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet LHStarView *starView;

@property (nonatomic, weak) IBOutlet UIButton *cartButton;
@property (nonatomic, weak) IBOutlet UIView *cartView;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *categoryControl;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIScrollView *productScrollView;
@end

@implementation LHShopDetailViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initVar];
    [self initView];
    [self initDB];
    [self initNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KxMenu configHightlightColor:ColorHex(0x656667)];
    [self.moreView setHidden:NO];
    
    [self syncAndReload];
    [self configCart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KxMenu setupWillDismissBlock:NULL];
    [self.moreView setHidden:YES];
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    self.productScrollViewHeight = kScreenHeight - 64 - 118 - 12 - 44 - 8 + 1;
}

- (void)initView {
    self.titleView = [[[NSBundle mainBundle] loadNibNamed:@"LHShopDetailTitleView" owner:self options:nil] lastObject];
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"ic_more"] size:CGSizeMake(24, 24) target:self action:@selector(rightItemPressed:)];
    
    [self.cartButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateNormal];
    [self.cartButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x26c8c6)] forState:UIControlStateHighlighted];
    
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"LHShopDetailMoreView" owner:self options:nil] lastObject];
    self.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 48);
    [[UIApplication sharedApplication].keyWindow addSubview:self.moreView];
    [self.moreView setupSelectBlock:^(LHProduct *product, LHSpecify *specify, BOOL select) {
        if (!specify) {
            [kJXWindow makeToast:(kStringOutOfService) duration:2.0f position:CSToastPositionCenter];
        }else {
            if (select) {
                LHSpecify *sToAdd = [specify copy];
                sToAdd.productId = product.uid;
                sToAdd.name = [NSString stringWithFormat:@"%@(%@)", product.name, specify.name];
                [self addSpecifyToCart:sToAdd];
            }else {
                [self removeSpecifyFromCart:specify];
            }
            [self configCart];
        }
    } closeBlock:^{
        [self showMoreView:NO];
    }];
    
    self.cartView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.cartView.layer.shadowOpacity = 0.8;
    self.cartView.layer.shadowRadius = 2.0;
    self.cartView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cartView.clipsToBounds = NO;
    
    self.categoryControl.sectionTitles = nil;
    self.categoryControl.titleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x666666), NSFontAttributeName: [UIFont systemFontOfSize:16]};
    self.categoryControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorHex(0x25BAB9), NSFontAttributeName: [UIFont systemFontOfSize:16]};
    self.categoryControl.selectionIndicatorColor = ColorHex(0x25BAB9);
    self.categoryControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.categoryControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.categoryControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.categoryControl.selectionIndicatorHeight = 2.0f;
    __weak typeof(self) weakSelf = self;
    [self.categoryControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.productScrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, self.productScrollViewHeight) animated:YES];
    }];
}

- (void)initDB {
}

- (void)initNet {
    NSString *shopid;
    if (self.shop) {
        shopid = self.shop.shopId;
        [self requestByShop];
    }else {
        shopid = [NSString stringWithFormat:@"%ld", (long)_shopid];
        [self requestByID];
    }
    
    if (gLH.logined) {
        [self requestFavoriteCheckWithMode:JXWebLaunchModeSilent shopid:shopid];
    }
}

#pragma mark request
- (void)requestByID {
    [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
    [LHHTTPClient getShopWithShopid:self.shopid success:^(AFHTTPRequestOperation *operation, LHShop *shop) {
        self.shop = shop;
        [LHHTTPClient getProductsWithShopid:[self.shop.shopId integerValue] success:^(AFHTTPRequestOperation *operation, id response) {
            [JXLoadView hideForView:self.view];
            self.business = response;
            
            [self.titleView.arrowImageView setHidden:NO];
            
            [self configInfo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
                [self requestByID];
            }];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
            [self requestByID];
        }];
    }];
}

- (void)requestByShop {
    [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
    [self.operaters exAddObject:
     [LHHTTPClient getProductsWithShopid:self.shop.shopId.integerValue success:^(AFHTTPRequestOperation *operation, NSArray *response) {
        self.business = response;
        [self.titleView.arrowImageView setHidden:NO];
        [self configInfo];
        
        [JXLoadView hideForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
            [self requestByShop];
        }];
    }]];
}

- (void)requestFavoriteShopWithUid:(NSInteger)uid {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteShopWithUid:uid success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        if (response.boolValue) {
            _isFavorited = YES;
            JXToast(@"收藏成功啦");
        }else {
            JXToast(@"咦~收藏失败呃");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestFavoriteShopWithUid:uid];
        }];
    }]];
}

- (void)requestFavoriteCheckWithMode:(JXWebLaunchMode)mode shopid:(NSString *)shopid {
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteCheckWithShopid:shopid success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        _isFavorited = !response.boolValue;
    } failure:NULL]];
}

- (void)requestFavoriteDeleteWithMode:(JXWebLaunchMode)mode favoriteID:(NSString *)favoriteid {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteDeleteWithShopid:self.shop.shopId success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"取消收藏成功，再逛逛");
        _isFavorited = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestFavoriteDeleteWithMode:mode favoriteID:favoriteid];
        }];
    }]];
}

- (BOOL)isOutOfService {
    // YJX_TODO 兼容一期的“靓百惠”
    if ([_shop.shopId isEqualToString:@"354"]) {
        return NO;
    }
    
    if (_shop.distance >= 3000) {
        return YES;
    }else {
        if (LHEntryFromFavorite == _from &&
            _distanceForFavorite >= 3000) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark config
- (void)configInfo {
    [self configShop];
    [self configBusiness];
    [self configCategory];
    
    if ([self isOutOfService]) {
        JXToast(kStringOutOfService);
    }
}

- (void)configShop {
        [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shop.url] forState:UIControlStateNormal placeholderImage:kImagePHShopLogo];
    
    self.nameLabel.text = self.shop.shopName;
    self.servicesLabel.text = self.shop.services;
    self.commentLabel.text = [NSString stringWithFormat:@"%@", @(self.shop.totalComment)];
    
    self.starView.enabled = NO;
    self.starView.level = self.shop.level;
    [self.starView loadData];
}

- (void)configBusiness {
    if (self.business.count == 0) {
        return;
    }
    
    for (LHShopBusiness *business in self.business) {
        if (business.uid.integerValue == self.from) {
            self.curBusiness = business.name;
            break;
        }
    }
    if (self.curBusiness.length == 0) {
        self.curBusiness = [(LHShopBusiness *)self.business[0] name];
    }
    self.titleView.titleLabel.text = self.curBusiness;
    
    [self.titleView setupPressedBlock:^(UIButton *btn) {
        [KxMenu setupWillDismissBlock:^{
            [self.titleView recoverArrow];
        }];
        [KxMenu showMenuInView:kJXWindow
                      fromRect:CGRectMake(kScreenWidth / 2.0, 64 - 12, 0, 0)
                     menuItems:self.businessMenuItems];
    }];
}

- (void)syncAndReload {
    for (int i = 0; i < self.categories.count; ++i) {
        LHProductCategory *category = self.categories[i];
        [self syncCartWithProducts:category.products];
    }
    //[self.productScrollView setNeedsDisplay];
    
    for (UIView *view in self.productScrollView.subviews) {
        if ([view isKindOfClass:[LHProductListView class]]) {
            [(LHProductListView *)view reloadData];
        }
    }
}

- (void)configCategory {
    if (self.curBusiness.length == 0) {
        return;
    }
    
    [self genCategories];
    
    
    [self.categoryNames removeAllObjects];
    NSInteger count = self.categories.count == 0 ? 1 : self.categories.count;
    self.productScrollView.contentSize = CGSizeMake(kScreenWidth * count, self.productScrollViewHeight);
    for (UIView *view in self.productScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.categories.count; ++i) {
        LHProductCategory *category = self.categories[i];
        [self.categoryNames addObject:category.name];
        
        [self syncCartWithProducts:category.products];
        
        LHProductListView *view = [[LHProductListView alloc] initWithProducts:category.products];
        view.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, self.productScrollViewHeight);
        [self.productScrollView addSubview:view];
        view.isOutOfService = [self isOutOfService];
        [view setupPressedBlock:^(LHProductListCell *cell, LHProduct *product, BOOL selected) {
            if (!product) {
                JXToast(kStringOutOfService);
            }else {
                if (selected) {
                    if (product.specifies.count == 1) {
                        LHSpecify *s = product.specifies[0];
                        if (s) {
                            LHSpecify *sToAdd = [s copy];
                            sToAdd.productId = product.uid;
                            sToAdd.name = product.name;
                            [self addSpecifyToCart:sToAdd];
                        }
                    }else {
                        self.moreView.product = product;
                        self.moreView.isOutOfService = [self isOutOfService];
                        self.productCell = cell;
                        [self showMoreView:YES];
                    }
                }else {
                    if (product.specifies.count == 1) {
                        [self removeSpecifyFromCart:product.specifies[0]];
                    }else {
                        self.moreView.product = product;
                        self.moreView.isOutOfService = [self isOutOfService];
                        self.productCell = cell;
                        [self showMoreView:YES];
                    }
                }
                [self configCart];
            }
        }];
    }
    [self.productScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.productScrollViewHeight) animated:YES];
    
    if (self.categoryNames.count == 0) {
        self.categoryControl.sectionTitles = nil;
        self.curCategory = nil;
    }else {
        self.categoryControl.sectionTitles = self.categoryNames;
        self.categoryControl.selectedSegmentIndex = 0;
        self.curCategory = self.categoryNames[0];
    }
    [self.categoryControl setNeedsDisplay];
}

- (void)configCart {
    NSString *cartStr = @"购物车";
    NSInteger count = [LHCartShop getProdunctCount];
    if (count != 0) {
        cartStr = [NSString stringWithFormat:@"购物车(%@)", @(count)];
    }
    [self.cartButton setTitle:cartStr forState:UIControlStateNormal];
}

#pragma mark assist
- (void)syncCartWithProducts:(NSArray *)products {
    NSMutableArray *specifiesInCart = nil;
    for (LHCartShop *cs in gLH.cartShops) {
        if ([cs.shopID isEqualToString:self.shop.shopId]) {
            specifiesInCart = [NSMutableArray array];
            for (LHSpecify *s in cs.specifies) {
                [specifiesInCart addObject:[s copy]];
            }
            break;
        }
    }
    
    for (LHProduct *p in products) {
        for (LHSpecify *s in p.specifies) {
            s.pieces = 0;
        }
    }
    
    if (specifiesInCart.count == 0) {
        return;
    }
    
    for (LHProduct *p in products) {
        if (p.specifies.count == 0) {
            continue;
        }else if (p.specifies.count == 1) {
            LHSpecify *s1 = p.specifies[0];
            for (LHSpecify *s2 in specifiesInCart) {
                if ([s1.uid isEqualToString:s2.uid]) {
                    s1.pieces = s2.pieces;
                }else {
                    //s1.pieces = 0;
                }
            }
        }else {
            for (LHSpecify *s1 in p.specifies) {
                for (LHSpecify *s2 in specifiesInCart) {
                    if ([s1.uid isEqualToString:s2.uid]) {
                        s1.pieces = s2.pieces;
                    }else {
                        //s1.pieces = 0;
                    }
                }
            }
        }
    }
}

- (void)genCategories {
    if (self.curBusiness.length == 0) {
        return;
    }
    
    for (LHShopBusiness *business in self.business) {
        if ([business.name isEqualToString:self.curBusiness]) {
            self.categories = business.categories;
            break;
        }
    }
}

//- (void)genSpecifies {
//    if (self.curBusiness.length == 0 ||
//        self.curCategory.length == 0) {
//        return;
//    }
//
//    for (LHProductCategory *category in self.categories) {
//        if ([category.name isEqualToString:self.curCategory]) {
//            // self.products = category.products;
//            // [self syncCart];
//        }
//    }
//}

- (void)categoryChangedWithMenu:(KxMenuItem *)menu {
    self.curBusiness = [[(KxMenuItem *)menu title] substringFromIndex:1];
    self.titleView.titleLabel.text = self.curBusiness;
    [self configCategory];
}

- (void)showMoreView:(BOOL)show{
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            self.moreView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 48);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.moreView.topView.alpha = 0.4;
                self.moreView.topView.backgroundColor = [UIColor blackColor];
            } completion:NULL];
        }];
    }else {
        [self.productCell reloadState];
        self.moreView.topView.alpha = 1.0;
        self.moreView.topView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            self.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 48);
        } completion:^(BOOL finished) {
            self.productCell = nil;
        }];
    }
}

- (void)addSpecifyToCart:(LHSpecify *)s {
    LHCartShop *cartShop = nil;
    for (LHCartShop *cs in gLH.cartShops) {
        if ([cs.shopID isEqualToString:self.shop.shopId]) {
            cartShop = cs;
            break;
        }
    }
    
    if (cartShop) {
        [cartShop.specifies addObject:s];
    }else {
        cartShop = [[LHCartShop alloc] init];
        cartShop.shopID = self.shop.shopId;
        cartShop.shopName = self.shop.shopName;
        [cartShop.specifies addObject:s];
        [gLH.cartShops addObject:cartShop];
    }
}

- (void)removeSpecifyFromCart:(LHSpecify *)s {
    LHCartShop *cartShop = nil;
    for (LHCartShop *cs in gLH.cartShops) {
        if ([cs.shopID isEqualToString:self.shop.shopId]) {
            cartShop = cs;
            break;
        }
    }
    
    if (!cartShop) {
        return;
    }
    
    LHSpecify *sToRemove;
    for (LHSpecify *obj in cartShop.specifies) {
        if ([obj.uid isEqualToString:s.uid]) {
            sToRemove = obj;
            break;
        }
    }
    
    if (sToRemove) {
        [cartShop.specifies removeObject:sToRemove];
    }
    
    if (cartShop.specifies.count == 0) {
        [gLH.cartShops removeObject:cartShop];
    }
}

#pragma mark - Public methods
- (instancetype)initWithShop:(LHShop *)shop{
    if (self = [self init]) {
        _shop = shop;
    }
    return self;
}

- (instancetype)initWithShopid:(NSInteger)shopid {
    if (self = [self init]) {
        _shopid = shopid;
    }
    return self;
}

#pragma mark - Accessor methods
- (NSArray *)businessMenuItems {
    if (!_businessMenuItems) {
        NSMutableArray *items = [NSMutableArray array];
        for (LHShopBusiness *business in self.business) {
            KxMenuItem *item;
            if (business.uid.integerValue == LHEntryFromHomeClothes) {
                item = [KxMenuItem menuItem:[NSString stringWithFormat:@" %@", business.name] image:[UIImage imageNamed:@"ic_business_clothes"] target:self action:@selector(clothesMenuPressed:)];
            }else if (business.uid.integerValue == LHEntryFromHomeShoe) {
                item = [KxMenuItem menuItem:[NSString stringWithFormat:@" %@", business.name] image:[UIImage imageNamed:@"ic_business_shoe"] target:self action:@selector(shoeMenuPressed:)];
            }else if (business.uid.integerValue == LHEntryFromHomeLeather) {
                item = [KxMenuItem menuItem:[NSString stringWithFormat:@" %@", business.name] image:[UIImage imageNamed:@"ic_business_leather"] target:self action:@selector(leatherMenuPressed:)];
            }else if (business.uid.integerValue == LHEntryFromHomeLuxury) {
                item = [KxMenuItem menuItem:[NSString stringWithFormat:@" %@", business.name] image:[UIImage imageNamed:@"ic_business_luxury"] target:self action:@selector(luxuryMenuPressed:)];
            }else if (business.uid.integerValue == LHEntryFromHomeOther) {
                item = [KxMenuItem menuItem:[NSString stringWithFormat:@" %@", business.name] image:[UIImage imageNamed:@"ic_business_other"] target:self action:@selector(otherMenuPressed:)];
            }else {
                LogError(@"未知的营业类型！");
            }
            
            if (item) {
                [items addObject:item];
            }
        }
        _businessMenuItems = items;
    }
    return _businessMenuItems;
}

- (NSMutableArray *)categoryNames {
    if (!_categoryNames) {
        _categoryNames = [NSMutableArray array];
    }
    return _categoryNames;
}

#pragma mark - Action methods
- (void)rightItemPressed:(id)sender {
    [KxMenu setupWillDismissBlock:NULL];
    
    NSString *favoriteString = _isFavorited ? @" 取消" : @" 收藏";
    UIImage *favoriteImage = _isFavorited ? [UIImage imageNamed:@"ic_favorite_selected"] : [UIImage imageNamed:@"ic_favorite"];
    SEL favoriteAction = _isFavorited ? @selector(favoriteCheckMenuPressed:) : @selector(favoriteUncheckMenuPressed:);
    NSArray *menuItems = @[[KxMenuItem menuItem:@" 首页"
                                          image:[UIImage imageNamed:@"ic_home"]
                                         target:self
                                         action:@selector(homeMenuPressed:)],
                           [KxMenuItem menuItem:favoriteString
                                          image:favoriteImage
                                         target:self
                                         action:favoriteAction],
                           [KxMenuItem menuItem:@" 分享"
                                          image:[UIImage imageNamed:@"ic_share"]
                                         target:self
                                         action:@selector(shareMenuPressed:)]];
    CGRect rect = [(UIButton *)sender frame];
    [KxMenu showMenuInView:kJXWindow
                  fromRect:CGRectMake(rect.origin.x, rect.origin.y + 16, rect.size.width, rect.size.height)
                 menuItems:menuItems];
}

- (void)homeMenuPressed:(id)sender {
    if (LHEntryFromFavorite == _from) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else {
        if (_from >= LHEntryFromActivity && _from <= LHEntryFromMap) {
            [self dismissViewControllerAnimated:YES completion:^{
                // YJX_TODO 回到首页
//                [(UINavigationController *)self.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
                //[(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
                //self.tabBarController.selectedIndex = 0;
            }];
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)favoriteCheckMenuPressed:(id)sender {
    [self requestFavoriteDeleteWithMode:JXWebLaunchModeHUD favoriteID:_favoriteID];
}

- (void)favoriteUncheckMenuPressed:(id)sender {
    [self requestFavoriteShopWithUid:self.shop.shopId.integerValue];
}

// YJX_TODO 缺少店铺描述与跳转URL
- (void)shareMenuPressed:(id)sender {
    if (self.shop.url.length > 0) {
        JXHUDProcessing(nil);
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.shop.url] options:SDWebImageDownloaderHighPriority | SDWebImageDownloaderUseNSURLCache progress:NULL completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            JXHUDHide();
            [self presentSnsWithImage:image ? image : kImageAppIcon];
        }];
    }else {
        [self presentSnsWithImage:kImageAppIcon];
    }
}

- (void)presentSnsWithImage:(UIImage *)image {
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"【%@】%@", [JXApp name], self.shop.shopName];
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"【%@】%@", [JXApp name], self.shop.shopName];;
    
     NSString *str = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9f0d2574e4dfa412&redirect_uri=http%%3A%%2F%%2Fwechat.appvworks.com%%2FoAuthServlet%%3FrealURL%%3Dwashclothes/shopdetail.html?id=%@&tag=1&response_type=code&scope=snsapi_userinfo&state=100#wechat_redirect", _shop.shopId];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"全城优质洗衣店8折，商家特惠价";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"全城优质洗衣店8折，商家特惠价";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppkey
                                      shareText:@"【爱为家】一键下单，周边洗衣店免费上门收送"
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
}

- (void)clothesMenuPressed:(id)sender {
    [self categoryChangedWithMenu:sender];
}

- (void)shoeMenuPressed:(id)sender {
    [self categoryChangedWithMenu:sender];
}

- (void)leatherMenuPressed:(id)sender {
    [self categoryChangedWithMenu:sender];
}

- (void)luxuryMenuPressed:(id)sender {
    [self categoryChangedWithMenu:sender];
}

- (void)otherMenuPressed:(id)sender {
    [self categoryChangedWithMenu:sender];
}

- (IBAction)commentFgButtonTouched:(id)sender {
    self.commentButton.highlighted = YES;
}

- (IBAction)commentFgButtonPressedInside:(id)sender {
    self.commentButton.highlighted = NO;
    
    LHCommentListViewController *commentVC = [[LHCommentListViewController alloc] initWithShopid:self.shop.shopId.integerValue];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (IBAction)commentFgButtonPressedOutside:(id)sender {
    self.commentButton.highlighted = NO;
}

- (IBAction)cartButtonPressed:(id)sender {
    //self.tabBarController.selectedIndex = 1;
    //    LHCart2ViewController *cartVC = [[LHCart2ViewController alloc] init];
    //    LHNavigationController *cartNav = [[LHNavigationController alloc] initWithRootViewController:cartVC];
    //    [self presentViewController:cartNav animated:YES completion:NULL];
    
    LHCartViewController *cartVC = [[LHCartViewController alloc] init];
    cartVC.from = _from;
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (IBAction)callButtonPressed:(id)sender {
    if (!_shop.mobile) {
        JXToast(@"商家没有留联系电话");
        return;
    }
    [JXDevice callNumber:self.shop.mobile];
}

- (IBAction)mapButtonPressed:(id)sender {
    LHShopMapViewController *mapVC = [[LHShopMapViewController alloc] initWithShops:@[self.shop]];
    mapVC.isSingle = YES;
    LHNavigationController *mapNav = [[LHNavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:mapNav animated:YES completion:^{
        
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.categoryControl setSelectedSegmentIndex:page animated:YES];
}

#pragma mark UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (gLH.logined) {
            [self.operaters exAddObject:
             [LHHTTPClient requestGetLovebeanWhenSharedWithTaskid:LHShareTaskShop success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
                gLH.user.info.loveBean += response.integerValue;
            } failure:NULL]];
        }
    }
}
@end




