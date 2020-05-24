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
#import "LHSecondBusiness.h"
#import "LHReceiptConfirmView.h"
#import "LHReceiptViewController.h"

@interface LHShopDetailViewController ()
@property (nonatomic, assign) CGRect animRect;
@property (nonatomic, strong) CALayer *animLayer;
@property (nonatomic, strong) UIBezierPath *animPath;
@property (nonatomic, strong) UIImageView *animImageView;

@property (nonatomic, assign) BOOL entryCartFlag;

@property (nonatomic, strong) NSMutableArray *photos;

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
//@property (nonatomic, weak) IBOutlet UILabel *commentLabel;
@property (nonatomic, weak) IBOutlet UIButton *logoButton;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet LHStarView *starView;

@property (nonatomic, weak) IBOutlet UIButton *cartButton;
@property (nonatomic, weak) IBOutlet UIView *cartView;
@property (nonatomic, weak) IBOutlet HMSegmentedControl *categoryControl;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIScrollView *productScrollView;

@property (nonatomic, weak) IBOutlet UIView *activityBgView1;
@property (nonatomic, weak) IBOutlet UIView *activityBgView2;

@property (nonatomic, weak) IBOutlet UIImageView *activityImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *nameLeadingCst; // 12 or 40
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topShopDesConstraint; // 22, 0
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topProductCategoryConstraint; // 128

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *desLabels;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *dotImageViews;

@property (nonatomic, strong) LHNavigationController *secondNavVC;

@property (nonatomic, weak) IBOutlet UILabel *modeLabel;

@property (nonatomic, strong) LHReceiptConfirmView *confirmView;

@property (nonatomic, strong) LHProductListCell *confirmForCell;
@property (nonatomic, strong) UIButton *confirmForButton;
@property (nonatomic, strong) LHProduct *confirmForProduct;
@property (nonatomic, strong) UITableView *confirmForTableView;
@property (nonatomic, strong) LHSpecify *confirmForSpecify;
@property (nonatomic, strong) LHSpecify *confirmForOriginalSpecify;

@property (nonatomic, assign) BOOL confirmForMore;

@property (nonatomic, weak) IBOutlet UILabel *v2CommentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *v2FavoriteCountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *v2FavoriteImageView;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KxMenu configHightlightColor:ColorHex(0x656667)];
    [self.moreView setHidden:NO];
    
    [self syncAndReload];
    [self configCart];
    
    if (gLH.logined) {
        if (!kIsLocalCart) {
            [self requestCountInCurrentCartWithMode:JXWebLaunchModeSilent];
            
//            if (self.entryCartFlag) {
//                [self initNet];
//            }
        }
    }
    
    gLH.sharedFlag = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KxMenu setupWillDismissBlock:NULL];
    [self.moreView setHidden:YES];
    
    gLH.sharedFlag = NO;
    
    if (_animLayer) {
        [_animLayer removeFromSuperlayer];
    }
}

#pragma mark - Private methods
#pragma mark init
- (void)initVar {
    //self.productScrollViewHeight = kScreenHeight - 64 - 100 - 118 - 48 - 8 + 1;
    self.productScrollViewHeight = kScreenHeight - 64 - 100 - 118 - 52 + 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOnlineGoodsDeleted:) name:kNotifyOnlineGoodsDeleted object:nil];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyOnlineGoodsOrdered:) name:kNotifyOnlineGoodsOrdered object:nil];
}

- (void)initView {
    [self.v2CommentCountLabel exCircleWithColor:[UIColor clearColor] border:0.0];
    [self.logoButton exSetBorder:[UIColor clearColor] width:0.0 radius:4];
    
    self.titleView = [[[NSBundle mainBundle] loadNibNamed:@"LHShopDetailTitleView" owner:self options:nil] lastObject];
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem exBarItemWithImage:[UIImage imageNamed:@"ic_more"] size:CGSizeMake(24, 24) target:self action:@selector(rightItemPressed:)];
    
    [self.cartButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x29d8d6)] forState:UIControlStateNormal];
    [self.cartButton setBackgroundImage:[UIImage exImageWithColor:ColorHex(0x26c8c6)] forState:UIControlStateHighlighted];
    
    self.moreView = [[[NSBundle mainBundle] loadNibNamed:@"LHShopDetailMoreView" owner:self options:nil] lastObject];
    self.moreView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 48);
    [[UIApplication sharedApplication].keyWindow addSubview:self.moreView];
    [self.moreView setupSelectBlock:^(LHProduct *product, LHSpecify *specify, UIButton *btn, BOOL select, UIImageView *imageView) {
        if (!specify) {
            [kJXWindow makeToast:(kStringOutOfService) duration:2.0f position:CSToastPositionCenter];
            //[self showConfirmView];
        }else {
            if (select) {
//                NSIndexPath *indexPath = [view.tableView indexPathForCell:cell];
//                CGRect cellRect = [view.tableView rectForRowAtIndexPath:indexPath];
//                cellRect = [view.tableView convertRect:cellRect toView:self.view];
//                // NSLog(@"cellRect = %@", NSStringFromCGRect(cellRect));
//                
//                CGRect imageRect = imageView.frame;
//                imageRect = [imageView.superview convertRect:imageRect toView:cell];
//                // NSLog(@"imageRect = %@", NSStringFromCGRect(imageRect));
//                
//                self.animRect = CGRectMake(imageRect.origin.x,
//                                           cellRect.origin.y + imageRect.origin.y,
//                                           imageRect.size.width,
//                                           imageRect.size.height);
//                self.animImageView = imageView;
                
                CGRect imageRect = imageView.frame;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                self.animRect = [imageView.superview convertRect:imageRect toView:window];
                self.animRect = CGRectMake(self.animRect.origin.x,
                                           self.animRect.origin.y - 64,
                                           self.animRect.size.width,
                                           self.animRect.size.height);
                self.animImageView = imageView;
                
                
                LHSpecify *sToAdd = [specify copy];
                sToAdd.productId = product.uid;
                sToAdd.name = [NSString stringWithFormat:@"%@(%@)", product.name, specify.name];
                
                self.confirmForButton = btn;
                //[self addSpecifyToCart:sToAdd];
               // [self addOrShowConfirmForMore:sToAdd product:product originalSpecify:specify];
                [self addOrShowConfirm:sToAdd product:product cell:nil btn:btn originalSpecify:specify];
            }else {
                [self removeSpecifyFromCart:[specify copy] product:product cell:nil btn:btn originalSpecify:specify];
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
    
    if (self.fristVC) {
        self.navigationItem.leftBarButtonItem = CreateBackBarItem(self);
    }
}

- (void)initDB {
}

- (void)initNet {
    //    NSString *shopid;
    //    if (self.shop) {
    //        shopid = self.shop.shopId;
    //        [self requestByShop];
    //    }else if(self.shopid != 0 && self.activityId != 0) {
    //        shopid = [NSString stringWithFormat:@"%ld", (long)_shopid];
    //        [self requestByActivity];
    //    }else {
    //        shopid = [NSString stringWithFormat:@"%ld", (long)_shopid];
    //        [self requestByID];
    //    }
    
    NSString *shopid = [NSString stringWithFormat:@"%ld", (long)_shopid];
    
    if (self.activityFlag) {
        self.modeLabel.text = @"点击进入没有活动的模式~" ;
        [self requestByActivity];
    }else {
        self.modeLabel.text = @"点击进入活动的模式~";
        [self requestByID];
    }
    
    if (gLH.logined/* && !self.entryCartFlag*/) {
        [self requestFavoriteCheckWithMode:JXWebLaunchModeSilent shopid:shopid];
    }
    
    [LHHTTPClient insertUserReportWithShopid:self.shopid success:NULL failure:NULL];
}

- (void)configPhotos {
    self.photos = [NSMutableArray arrayWithCapacity:self.shop.shopPictures.count + 1];
    [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.shop.url]]];
    for (NSString *urlString in self.shop.shopPictures) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:urlString]]];
    }
}

#pragma mark request
- (void)requestCountInCurrentCartWithMode:(JXWebLaunchMode)mode {
    [LHHTTPClient getShopCartBuyCounts:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        [self configCartForOnlineCartWithCount:response.integerValue];
    } failure:NULL];
}

- (void)requestByID {
//    if (self.entryCartFlag) {
//        [LHHTTPClient getShopWithShopid:self.shopid success:^(AFHTTPRequestOperation *operation, LHShop *shop) {
//            self.shop = shop;
//            [self configPhotos];
//            [LHHTTPClient getProductsWithShopid:[self.shop.shopId integerValue] addressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
//                self.business = response;
//                
//                [self.titleView.arrowImageView setHidden:NO];
//                
//                [self configInfo];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeSilent way:JXWebHandleWayToast error:error callback:NULL];
//            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeSilent way:JXWebHandleWayToast error:error callback:NULL];
//        }];
//    }else {
        [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
        [LHHTTPClient getShopWithShopid:self.shopid success:^(AFHTTPRequestOperation *operation, LHShop *shop) {
            self.shop = shop;
            [self configPhotos];
            [LHHTTPClient getProductsWithShopid:[self.shop.shopId integerValue] addressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
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
    //}
}

//- (void)requestByShop {
//    [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
//    [self.operaters exAddObject:
//     [LHHTTPClient getProductsWithShopid:self.shop.shopId.integerValue addressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, NSArray *response) {
//        self.business = response;
//        [self.titleView.arrowImageView setHidden:NO];
//        [self configInfo];
//        
//        [JXLoadView hideForView:self.view];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
//            [self requestByShop];
//        }];
//    }]];
//}

- (void)requestByActivity {
//    if (self.entryCartFlag) {
//        [LHHTTPClient getShopWithShopid:self.shopid success:^(AFHTTPRequestOperation *operation, LHShop *shop) {
//            self.shop = shop;
//            [self configPhotos];
//            [LHHTTPClient getProductsWithShopid:self.shop.shopId.integerValue activityId:-1 addressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
//                self.business = response;
//                
//                [self.titleView.arrowImageView setHidden:NO];
//                
//                [self configInfo];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeSilent way:JXWebHandleWayToast error:error callback:NULL];
//            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeSilent way:JXWebHandleWayToast error:error callback:NULL];
//        }];
//    }else {
        [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
        [LHHTTPClient getShopWithShopid:self.shopid success:^(AFHTTPRequestOperation *operation, LHShop *shop) {
            self.shop = shop;
            [self configPhotos];
            [LHHTTPClient getProductsWithShopid:self.shop.shopId.integerValue activityId:-1 addressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
                [JXLoadView hideForView:self.view];
                self.business = response;
                
                [self.titleView.arrowImageView setHidden:NO];
                
                [self configInfo];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
                    [self requestByActivity];
                }];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleFailureForView:self.view rect:CGRectZero mode:JXWebLaunchModeLoad way:JXWebHandleWayShow error:error callback:^{
                [self requestByActivity];
            }];
        }];
    //}
}

- (void)requestFavoriteShopWithUid:(NSInteger)uid {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteShopWithUid:uid success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        if (response.boolValue) {
            _isFavorited = YES;
            self.v2FavoriteCountLabel.text = _isFavorited ? @"取消收藏" : @"收藏";
            self.v2FavoriteImageView.highlighted = _isFavorited;
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
        self.v2FavoriteCountLabel.text = _isFavorited ? @"取消收藏" : @"收藏";
        self.v2FavoriteImageView.highlighted = _isFavorited;
    } failure:NULL]];
}

- (void)requestFavoriteDeleteWithMode:(JXWebLaunchMode)mode favoriteID:(NSString *)favoriteid {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient requestFavoriteDeleteWithShopid:self.shop.shopId success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        JXToast(@"取消收藏成功，再逛逛");
        _isFavorited = NO;
        self.v2FavoriteCountLabel.text = _isFavorited ? @"取消收藏" : @"收藏";
        self.v2FavoriteImageView.highlighted = _isFavorited;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
            [self requestFavoriteDeleteWithMode:mode favoriteID:favoriteid];
        }];
    }]];
}

- (BOOL)isOutOfService {
//    // YJX_TODO 兼容一期的“靓百惠”
//    if ([_shop.shopId isEqualToString:@"354"]) {
//        return NO;
//    }
//
//    if (_shop.distance >= 3000) {
//        return YES;
//    }else {
//        if (LHEntryFromFavorite == _from &&
//            _distanceForFavorite >= 3000) {
//            return YES;
//        }
//    }
//
//    return NO;
    
    return self.outOfService;
}

#pragma mark config
- (void)configInfo {
    //    // YJX_TODO 测试
    //    //self.shop.activityIconUrl = nil;
    //    self.shop.shopDescription = @"123###456"; // @"123###456###789";
    
    [self configActivity];
    [self configShop];
    [self configBusiness];
    [self configCategory];
    
        if ([self isOutOfService]) {
            JXToast(kStringOutOfService);
        }
}

- (void)configActivity {
    // self.productScrollViewHeight = kScreenHeight - 64 - 118 - 120 - 8 - 44 - 8 + 1;
    
    if (self.shop.activityIconUrl.length != 0) {
        self.nameLeadingCst.constant = 36.0f;
        [_activityImageView setHidden:NO];
        [_activityImageView sd_setImageWithURL:[NSURL URLWithString:self.shop.activityIconUrl] placeholderImage:[UIImage imageNamed:@"ic_activity_ph"]];
        
        [self.activityBgView1 setHidden:NO];
        [self.activityBgView2 setHidden:YES];
    }else {
        self.nameLeadingCst.constant = 12.0f;
        [_activityImageView setHidden:YES];
        
        [self.activityBgView1 setHidden:YES];
        [self.activityBgView2 setHidden:NO];
    }
    
    NSArray *des1 = [self.shop.shopDescription componentsSeparatedByString:@"###"];
    NSMutableArray *des = [NSMutableArray array];
    for (NSString *str in des1) {
        if (str.length != 0) {
            [des addObject:str];
        }
    }
    if (des.count == 3) {
        for (int i = 0; i < des.count; ++i) {
            [(UILabel *)self.desLabels[i] setText:des[i]];
        }
    }else if (des.count == 2) {
        for (int i = 0; i < des.count; ++i) {
            [(UILabel *)self.desLabels[i] setText:des[i]];
        }
        self.topProductCategoryConstraint.constant -= 20;
        self.productScrollViewHeight += 20;
        [self.dotImageViews[2] setHidden:YES];
    }else if (des.count == 1) {
        for (int i = 0; i < des.count; ++i) {
            [(UILabel *)self.desLabels[i] setText:des[i]];
        }
        self.topProductCategoryConstraint.constant -= 40;
        self.productScrollViewHeight += 40;
        [self.dotImageViews[1] setHidden:YES];
        [self.dotImageViews[2] setHidden:YES];
    }else {
        // 118 - 20 = 98
        self.topProductCategoryConstraint.constant -= 98;
        self.productScrollViewHeight += 98;
    }
}

- (void)configShop {
    [self.logoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shop.url] forState:UIControlStateNormal placeholderImage:kImagePHShopLogo];
    
    self.nameLabel.text = self.shop.shopName;
    self.servicesLabel.text = self.shop.services;
    // self.commentLabel.text = [NSString stringWithFormat:@"%@", @(self.shop.totalComment)];
    self.v2CommentCountLabel.text = [NSString stringWithFormat:@"%@", @(self.shop.totalComment)];
    
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
    
    if (self.moreView.showed) {
        [self.moreView setNeedsDisplay];
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
        //view.activityFlag = self.activityFlag;
        view.isOutOfService = [self isOutOfService];
        [view setupPressedBlock:^(LHProductListCell *cell, LHProduct *product, UIButton *btn, BOOL selected, UIImageView *imageView) {
           // CGRect rect = cell.frame;
            
//            NSIndexPath *indexPath = [view.tableView indexPathForCell:cell];
//            CGRect cellRect = [view.tableView rectForRowAtIndexPath:indexPath];
//            cellRect = [view.tableView convertRect:cellRect toView:self.view];
//            // NSLog(@"cellRect = %@", NSStringFromCGRect(cellRect));
//            
//            CGRect imageRect = imageView.frame;
//            imageRect = [imageView.superview convertRect:imageRect toView:cell];
//            // NSLog(@"imageRect = %@", NSStringFromCGRect(imageRect));
//            
//            CGRect animRect = CGRectMake(imageRect.origin.x,
//                                         cellRect.origin.y + imageRect.origin.y,
//                                         imageRect.size.width,
//                                         imageRect.size.height);
            //NSLog(@"animRect = %@", NSStringFromCGRect(animRect));
            
//            CGRect rect = imageView.frame;
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            CGRect rt = [imageView.superview convertRect:rect toView:window];
            // [self startAnimationWithRect:animRect ImageView:imageView];
            
            if (!product) {
                JXToast(kStringOutOfService);
                //[self showConfirmView];
            }else {
                if (selected) {
                    if (product.specifies.count == 1) {
                        LHSpecify *s = product.specifies[0];
                        if (s) {
                            // 动画属性
                            NSIndexPath *indexPath = [view.tableView indexPathForCell:cell];
                            CGRect cellRect = [view.tableView rectForRowAtIndexPath:indexPath];
                            cellRect = [view.tableView convertRect:cellRect toView:self.view];
                            // NSLog(@"cellRect = %@", NSStringFromCGRect(cellRect));
                            
                            CGRect imageRect = imageView.frame;
                            imageRect = [imageView.superview convertRect:imageRect toView:cell];
                            // NSLog(@"imageRect = %@", NSStringFromCGRect(imageRect));
                            
                            self.animRect = CGRectMake(imageRect.origin.x,
                                                         cellRect.origin.y + imageRect.origin.y,
                                                         imageRect.size.width,
                                                         imageRect.size.height);
                            self.animImageView = imageView;
                            
                            
                            LHSpecify *sToAdd = [s copy];
                            sToAdd.productId = product.uid;
                            sToAdd.name = product.name;
                            
                            //[self addSpecifyToCart:sToAdd];
                            
                            self.confirmForTableView = view.tableView;
                            //[self addOrShowConfirm:s product:product cell:cell btn:btn];
                            [self addOrShowConfirm:sToAdd product:product cell:cell btn:btn originalSpecify:s];
                        }
                    }else {
                        self.moreView.product = product;
                        self.moreView.isOutOfService = [self isOutOfService];
                        self.productCell = cell;
                        [self showMoreView:YES];
                    }
                }else {
                    if (product.specifies.count == 1) {
                        [self removeSpecifyFromCart:product.specifies[0] product:product cell:cell btn:btn originalSpecify:nil];
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
    [self.productScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.productScrollViewHeight) animated:NO];
    // [self.view setNeedsDisplay];
    
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
    if (kIsLocalCart) {
        NSString *cartStr = @"购物车";
        NSInteger count = [LHCartShop getProdunctCount];
        if (count != 0) {
            cartStr = [NSString stringWithFormat:@"购物车(%@)", @(count)];
        }
        [self.cartButton setTitle:cartStr forState:UIControlStateNormal];
        return;
    }
}

- (void)configCartForOnlineCartWithCount:(NSInteger)count {
    if (kIsLocalCart) {
        return;
    }

    NSString *cartStr = @"购物车";
    if (count != 0) {
        cartStr = [NSString stringWithFormat:@"购物车(%@)", @(count)];
    }
    [self.cartButton setTitle:cartStr forState:UIControlStateNormal];
}

#pragma mark assist
- (void)leftBarItemPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.fristVC.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)syncCartWithProducts:(NSArray *)products {
    if (!kIsLocalCart) {
        return;
    }
    
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
                    // s1.pieces = s2.pieces;
                    
                    if (s2.activityId.length != 0 && self.activityFlag) {
                        s1.pieces = s2.pieces;
                    }else if (s2.activityId.length == 0 && !self.activityFlag) {
                        s1.pieces = s2.pieces;
                    }
                }else {
                    //s1.pieces = 0;
                }
            }
        }else {
            for (LHSpecify *s1 in p.specifies) {
                for (LHSpecify *s2 in specifiesInCart) {
                    if ([s1.uid isEqualToString:s2.uid]) {
                        // s1.pieces = s2.pieces;
                        
                        if (s2.activityId.length != 0 && self.activityFlag) {
                            s1.pieces = s2.pieces;
                        }else if (s2.activityId.length == 0 && !self.activityFlag) {
                            s1.pieces = s2.pieces;
                        }
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
    self.moreView.showed = show;
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

- (void)requestAddProductWithMode:(JXWebLaunchMode)mode param:(NSDictionary *)param {
    //JXHUDProcessing(nil);
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES hideAnimated:YES hideDelay:0 mode:MBProgressHUDModeIndeterminate type:0 customView:nil labelText:(nil) detailsLabelText:nil square:NO dimBackground:NO color:nil removeFromSuperViewOnHide:NO labelFont:16.0f detailsLabelFont:12.0f];
    
    [LHHTTPClient addShopCartProduct:param success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        // JXHUDHide();
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (self.confirmForMore) {
            NSString *str = [NSString stringWithFormat:@"%@，￥%@", self.confirmForSpecify.name, self.confirmForSpecify.price];
            Toast(str);
        }
        [self startAnimationToCart];
        [self configCartForOnlineCartWithCount:response.integerValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (self.confirmForMore) {
            self.confirmForButton.selected = NO;
            self.confirmForOriginalSpecify.pieces = 0;
        }else {
            LHSpecify *s = self.confirmForProduct.specifies[0];
            s.pieces = 0;
            self.confirmForButton.selected = NO;
            [self.confirmForTableView reloadData];
        }
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

- (void)requestDelProductWithMode:(JXWebLaunchMode)mode param:(NSDictionary *)param {
    JXHUDProcessing(nil);
    [LHHTTPClient batchClearProduct:param success:^(AFHTTPRequestOperation *operation, NSNumber *response) {
        JXHUDHide();
        [self configCartForOnlineCartWithCount:response.integerValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.confirmForMore) {
            self.confirmForButton.selected = NO;
            self.confirmForOriginalSpecify.pieces = 0;
        }else {
            LHSpecify *s = self.confirmForProduct.specifies[0];
            s.pieces = 0;
            self.confirmForButton.selected = NO;
            [self.confirmForTableView reloadData];
        }
        
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

//- (void)addOrShowConfirm:(LHSpecify *)s
//                 product:(LHProduct *)product
//                    cell:(LHProductListCell *)cell
//                     btn:(UIButton *)btn {
//    self.confirmForMore = NO;
//    self.confirmForCell = cell;
//    self.confirmForButton = btn;
//    self.confirmForProduct = product;
//    self.confirmForSpecify = s;
//
//    if (kIsLocalCart) {
//        if (gLH.isReceiptPromptClosed) {
//            [self addSpecifyToCart:s];
//        }else {
//            [self showConfirmView];
//        }
//    }else {
//        // 添加商品到在线购物车
//        LHAddProductRequestProduct *pdt = [LHAddProductRequestProduct new];
//        pdt.shopId = self.shop.shopId.integerValue;
//        pdt.productId = product.uid.integerValue;
//        pdt.specifieId = s.uid.integerValue;
//        pdt.buyCount = 1;
//
//        LHAddProductRequest *request = [LHAddProductRequest new];
//        request.addressId = gLH.receipt.receiptID.integerValue;
//        request.productIds = @[pdt];
//
//        [self showLoginIfNotLoginedWithFinish:^{
//           [self requestAddProductWithMode:JXWebLaunchModeHUD param:[request JSONObject]];
//        }];
//    }
//}

- (void)addOrShowConfirm:(LHSpecify *)s
                 product:(LHProduct *)product
                    cell:(LHProductListCell *)cell
                     btn:(UIButton *)btn
         originalSpecify:(LHSpecify *)originalSpecify {
    self.confirmForMore = (cell == nil);
    
    self.confirmForCell = cell;
    self.confirmForButton = btn;
    self.confirmForProduct = product;
    self.confirmForSpecify = s;
    self.confirmForOriginalSpecify = originalSpecify;
    
    if (kIsLocalCart) {
        if (gLH.isReceiptPromptClosed) {
            [self addSpecifyToCart:s];
        }else {
            [self showConfirmView];
        }
    }else {
        // 添加商品到在线购物车
        LHAddProductRequestProduct *pdt = [LHAddProductRequestProduct new];
        pdt.shopId = self.shop.shopId.integerValue;
        pdt.productId = product.uid.integerValue;
        pdt.specifieId = s.uid.integerValue;
        pdt.buyCount = 1;
        pdt.activityId = s.activityId;
        
        LHAddProductRequest *request = [LHAddProductRequest new];
        request.addressId = gLH.receipt.receiptID.integerValue;
        request.productIds = @[pdt];
        
        [self showLoginIfNotLoginedWithFinish:^{
            [self requestAddProductWithMode:JXWebLaunchModeHUD param:[request JSONObject]];
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
    
    if (self.confirmForMore) {
        NSString *str = [NSString stringWithFormat:@"%@，￥%@", self.confirmForSpecify.name, self.confirmForSpecify.price];
        Toast(str);
    }
    
    [self startAnimationToCart];
}

- (void)removeSpecifyFromCart:(LHSpecify *)s
                      product:(LHProduct *)product
                         cell:(LHProductListCell *)cell
                          btn:(UIButton *)btn
              originalSpecify:(LHSpecify *)originalSpecify {
    
    self.confirmForMore = (originalSpecify != nil);
    
    self.confirmForCell = cell;
    self.confirmForButton = btn;
    self.confirmForProduct = product;
    self.confirmForSpecify = s;
    self.confirmForOriginalSpecify = originalSpecify;
    
    if (kIsLocalCart) {
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
        
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(s.uid.integerValue) forKey:@"specifieId"];
    if (s.activityId.length != 0) {
        [dict setObject:@(s.activityId.integerValue) forKey:@"activityId"];
    }
    
    NSDictionary *params = @{@"addressId": gLH.receipt.receiptID,
                             @"specifieIds": @[dict]};
    
    [self showLoginIfNotLoginedWithFinish:^{
        [self requestDelProductWithMode:JXWebLaunchModeHUD param:params];
    }];
}

- (void)notifyOnlineGoodsDeleted:(NSNotification *)notification {
//    if (kIsLocalCart) {
//        if (self.moreView.hidden) {
//            [self.moreView setNeedsDisplay];
//        }
//        return;
//    }
    
    NSArray *dels = notification.object;
    if (!dels) {
        return;
    }
    
    for (LHProductCategory *category in self.categories) {
        for (LHProduct *product in category.products) {
            for (LHSpecify *specify in product.specifies) {
//                if ([specify.uid isEqualToString:notification.object]) {
//                    s = specify;
//                    break;
//                }
                
                for (LHSpecify *del in dels) {
                    if ([specify isEqual:del]) {
                        specify.pieces = 0;
                    }
                }
            }
            
//            if (s) {
//                break;
//            }
        }
        
//        if (s) {
//            break;
//        }
    }
    
    // s.pieces = 0;
    for (UIView *view in self.productScrollView.subviews) {
        if ([view isKindOfClass:[LHProductListView class]]) {
            [(LHProductListView *)view reloadData];
        }
    }
    
    if (self.moreView.showed) {
        [self.moreView setNeedsDisplay];
    }
}

- (void)notifyOnlineGoodsOrdered:(NSNotification *)notification {
    LHCartShop *cartShop = notification.object;
    NSArray *ss = cartShop.specifies;
    for (LHProductCategory *pc in self.categories) {
        for (LHProduct *pdt in pc.products) {
            for (LHSpecify *s1 in pdt.specifies) {
                for (LHSpecify *s2 in ss) {
                    if ([s1.uid isEqualToString:s2.uid]) {
                        s1.pieces -= s2.pieces;
                        if (s1.pieces < 0) {
                            s1.pieces = 0;
                        }
                    }
                }
            }
        }
    }
}

- (void)startAnimationToCart {
    if (!self.animImageView) {
        return;
    }
    
    _animLayer = [CALayer layer];
    _animLayer.contents = (id)self.animImageView.layer.contents;
    
    _animLayer.contentsGravity = kCAGravityResizeAspectFill;
    _animLayer.bounds = self.animRect;
    [_animLayer setCornerRadius:CGRectGetHeight([_animLayer bounds]) / 2];
    _animLayer.masksToBounds = YES;

    
    _animLayer.position = CGPointMake(self.animRect.origin.x + self.animRect.size.width / 2.0,
                                      self.animRect.origin.y + self.animRect.size.height / 2.0 + 64);
    // [self.view.layer addSublayer:_animLayer];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:_animLayer];
    
    self.animPath = [UIBezierPath bezierPath];
    [_animPath moveToPoint:_animLayer.position];
    [_animPath addQuadCurveToPoint:CGPointMake(kJXScreenWidth - 40, kJXScreenHeight + 40) controlPoint:CGPointMake(kJXScreenWidth / 2, self.animRect.origin.y - 80)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _animPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 0.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = .8f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_animLayer addAnimation:groups forKey:@"group"];
}

//-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView {
//    //if (!_animLayer) {
//        //        _btn.enabled = NO;
////        _animLayer = [CALayer layer];
////        _animLayer.contents = (id)imageView.layer.contents;
////        
////        _animLayer.contentsGravity = kCAGravityResizeAspectFill;
////        _animLayer.bounds = rect;
////        [_animLayer setCornerRadius:CGRectGetHeight([_animLayer bounds]) / 2];
////        _animLayer.masksToBounds = YES;
////        // 导航64
////        _animLayer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
////        //        [_tableView.layer addSublayer:_layer];
////        [self.view.layer addSublayer:_animLayer];
////        self.animPath = [UIBezierPath bezierPath];
////        [_animPath moveToPoint:_animLayer.position];
////        //        (SCREEN_WIDTH - 60), 0, 50, 50)
////        [_animPath addQuadCurveToPoint:CGPointMake(kJXScreenWidth - 40, kJXScreenHeight-40) controlPoint:CGPointMake(kJXScreenWidth/2,rect.origin.y-80)];
////        //        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH-40, 30)];
//    
////        _animLayer = [CALayer layer];
////        _animLayer.contents = (id)imageView.layer.contents;
////        _animLayer.contentsGravity = kCAGravityResizeAspectFill;
////        _animLayer.bounds = rect;
////        [_animLayer setCornerRadius:CGRectGetHeight([_animLayer bounds]) / 2];
////        _animLayer.masksToBounds = YES;
////        _animLayer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
////        [[UIApplication sharedApplication].keyWindow.layer addSublayer:_animLayer];
////        self.animPath = [UIBezierPath bezierPath];
////        [_animPath moveToPoint:_animLayer.position];
////        [_animPath addQuadCurveToPoint:CGPointMake(kJXScreenWidth - 40, kJXScreenHeight-40) controlPoint:CGPointMake(kJXScreenWidth/2,rect.origin.y-80)];
//    //}
//    // _animLayer.contents = (id)imageView.layer.contents;
//    
//    
//    
//    _animLayer = [CALayer layer];
//    _animLayer.contents = (id)imageView.layer.contents;
//    
//    _animLayer.contentsGravity = kCAGravityResizeAspectFill;
//    _animLayer.bounds = rect;
//    [_animLayer setCornerRadius:CGRectGetHeight([_animLayer bounds]) / 2];
//    _animLayer.masksToBounds = YES;
//    // 导航64
////    CGPoint p11 = imageView.center;
////    CGFloat xx = CGRectGetMidY(rect);
//    // CGPoint p12 = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
////    
////    _animLayer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
//    
//    _animLayer.position = CGPointMake(rect.origin.x,
//                                      rect.origin.y + 64);
//    [self.view.layer addSublayer:_animLayer];
//    
//    self.animPath = [UIBezierPath bezierPath];
//    [_animPath moveToPoint:_animLayer.position];
//    //        (SCREEN_WIDTH - 60), 0, 50, 50)
//    [_animPath addQuadCurveToPoint:CGPointMake(kJXScreenWidth - 40, kJXScreenHeight - 40) controlPoint:CGPointMake(kJXScreenWidth / 2, rect.origin.y - 80)];
//    //        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH-40, 30)];
//    
//    [self groupAnimation];
//}
//
//-(void)groupAnimation {
//    // _tableView.userInteractionEnabled = NO;
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = _animPath.CGPath;
//    animation.rotationMode = kCAAnimationRotateAuto;
//    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    expandAnimation.duration = 0.3f;
//    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
//    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
//    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    narrowAnimation.beginTime = 0.3;
//    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
//    narrowAnimation.duration = 0.5f;
//    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
//    
//    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    
//    CAAnimationGroup *groups = [CAAnimationGroup animation];
//    groups.animations = @[animation,expandAnimation,narrowAnimation];
//    groups.duration = .8f;
//    groups.removedOnCompletion=NO;
//    groups.fillMode=kCAFillModeForwards;
//    groups.delegate = self;
//    [_animLayer addAnimation:groups forKey:@"group"];
//}

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

//- (instancetype)initWithShopid:(NSInteger)shopid activityId:(NSInteger)activityId {
//    if (self = [self init]) {
//        _shopid = shopid;
//        _activityId = activityId;
//    }
//    return self;
//}

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

- (LHReceiptConfirmView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[[NSBundle mainBundle] loadNibNamed:@"LHReceiptConfirmView" owner:self options:nil] lastObject];
        //        //        JXDeviceInch inch = [JXDevice inch];
        //        //        if (JXDeviceInch55 == inch) {
        //        //            _menuView.frame = CGRectMake(0, 0, _menuView.bounds.size.width * 1.3, _menuView.bounds.size.height * 1.3);
        //        //        }else if (JXDeviceInch47 == inch) {
        //        //            _menuView.frame = CGRectMake(0, 0, _menuView.bounds.size.width * 1.2, _menuView.bounds.size.height * 1.2);
        //        //        }
        //        __block __typeof(self) bSelf = self;
        //        [_menuView setClickBlock:^(MBJNoteType type) {
        //            [bSelf.menuView dismissPresentingPopup];
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                MBJNoteEditViewController *vc = [[MBJNoteEditViewController alloc] init];
        //                vc.hidesBottomBarWhenPushed = YES;
        //                [bSelf.navigationController pushViewController:vc animated:YES];
        //            });
        //        }];
        
        //__block __typeof(self) bSelf = self;
        __weak __typeof(self) wSelf = self;
        [_confirmView setClickBlock:^(LHReceiptConfirmType type, UIButton *checkButton) {
            __strong __typeof(wSelf) sSelf = wSelf;
            if (LHReceiptConfirmTypeClose == type) {
                if (sSelf.confirmForMore) {
                    sSelf.confirmForButton.selected = NO;
                    sSelf.confirmForOriginalSpecify.pieces = 0;
                }else {
                    LHSpecify *s = sSelf.confirmForProduct.specifies[0];
                    s.pieces = 0;
                    sSelf.confirmForButton.selected = NO;
                    [sSelf.confirmForTableView reloadData];
                }
            }else if (LHReceiptConfirmTypeOK == type) {
                gLH.isReceiptPromptClosed = checkButton.selected;
                [sSelf addSpecifyToCart:sSelf.confirmForSpecify];
            }else {
                //gLH.isReceiptPromptClosed = checkButton.selected;
                if (sSelf.confirmForMore) {
                    sSelf.confirmForButton.selected = NO;
                    sSelf.confirmForOriginalSpecify.pieces = 0;
                }else {
                    LHSpecify *s = sSelf.confirmForProduct.specifies[0];
                    s.pieces = 0;
                    sSelf.confirmForButton.selected = NO;
                    [sSelf.confirmForTableView reloadData];
                }
                
                [sSelf showLoginIfNotLoginedWithFinish:^{
                    LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
                    vc.from = LHReceiptFromChoose;
                    vc.hidesBottomBarWhenPushed = YES;
                    [sSelf.navigationController pushViewController:vc animated:YES];
                }];
            }
            [sSelf.confirmView dismissPresentingPopup];
        }];
    }
    return _confirmView;
}

- (void)showConfirmView {
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    KLCPopup *popup = [KLCPopup popupWithContentView:self.confirmView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [popup showWithLayout:layout];
}

#pragma mark - Action methods
- (void)rightItemPressed:(id)sender {
    [KxMenu setupWillDismissBlock:NULL];
    
//    NSString *favoriteString = _isFavorited ? @" 取消" : @" 收藏";
//    UIImage *favoriteImage = _isFavorited ? [UIImage imageNamed:@"ic_favorite_selected"] : [UIImage imageNamed:@"ic_favorite"];
//    SEL favoriteAction = _isFavorited ? @selector(favoriteCheckMenuPressed:) : @selector(favoriteUncheckMenuPressed:);
    NSArray *menuItems = @[[KxMenuItem menuItem:@" 首页"
                                          image:[UIImage imageNamed:@"ic_home"]
                                         target:self
                                         action:@selector(homeMenuPressed:)],
//                           [KxMenuItem menuItem:favoriteString
//                                          image:favoriteImage
//                                         target:self
//                                         action:favoriteAction],
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
    //NSLog(@"%@", self.presentingViewController);
    
//    if (LHEntryFromFavorite == _from) {
//        self.tabBarController.selectedIndex = 0;
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }else {
//        if (_from >= LHEntryFromActivity && _from <= LHEntryFromMap) {
//            [self dismissViewControllerAnimated:YES completion:^{
//                // YJX_TODO 回到首页
////                [(UINavigationController *)self.tabBarController.selectedViewController popToRootViewControllerAnimated:YES];
////                [(UINavigationController *)self.presentingViewController popToRootViewControllerAnimated:YES];
////                self.tabBarController.selectedIndex = 0;
//            }];
//        }else {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:^{
            self.tabBarController.selectedIndex = 0;
            if (self.fristVC) {
                [self.fristVC.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }else {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    NSArray *arr = @[@"洗衣", @"洗鞋", @"皮具洗护", @"奢侈品洗护", @"其他"];
    NSInteger index = [arr indexOfObject:self.curBusiness];
    
//    NSString *str = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9f0d2574e4dfa412&redirect_uri=http%%3A%%2F%%2Fwechat.appvworks.com%%2FoAuthServlet%%3FrealURL%%3Dwashclothes/shopdetail.html?id=%@&tag=%ld&response_type=code&scope=snsapi_userinfo&state=100#wechat_redirect", _shop.shopId, (long)(index + 1)];
    NSString *str = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx9f0d2574e4dfa412&redirect_uri=http://wechat.appvworks.com/oAuthServlet?realURL=washclothes/shopdetail.html?param=id|%@,tag|%ld&response_type=code&scope=snsapi_userinfo&state=100&from=singlemessage&isappinstalled=0#wechat_redirect", _shop.shopId, (long)(index + 1)];
    
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
    //self.entryCartFlag = YES;
    LHV2CartViewController *cartVC = [[LHV2CartViewController alloc] init];
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

- (IBAction)changeButtonPressed:(id)sender {
//    if (!self.secondNavVC) {
//        LHShopDetailViewController *vc = [[LHShopDetailViewController alloc] initWithShopid:self.shopid];
//        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        vc.from = self.from;
//        vc.activityFlag = !self.activityFlag;
//        vc.fristVC = self;
//        self.secondNavVC = [[LHNavigationController alloc] initWithRootViewController:vc];
//    }
//    
    if (!self.activityFlag) {       // 普通模式进入活动模式
        if (self.fristVC) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else {
            if (!self.secondNavVC) {
                LHShopDetailViewController *vc = [[LHShopDetailViewController alloc] initWithShopid:self.shopid];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                vc.from = self.from;
                vc.activityFlag = YES;
                vc.fristVC = self;
                self.secondNavVC = [[LHNavigationController alloc] initWithRootViewController:vc];
            }
            [self presentViewController:self.secondNavVC animated:YES completion:NULL];
        }
    }else {
        if (self.fristVC) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }else {
            if (!self.secondNavVC) {
                LHShopDetailViewController *vc = [[LHShopDetailViewController alloc] initWithShopid:self.shopid];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                vc.from = self.from;
                vc.activityFlag = NO;
                vc.fristVC = self;
                self.secondNavVC = [[LHNavigationController alloc] initWithRootViewController:vc];
            }
            [self presentViewController:self.secondNavVC animated:YES completion:NULL];
        }
    }
}

- (IBAction)logoButtonPressed:(id)sender {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    
    LHNavigationController *nc = [[LHNavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

- (IBAction)v2LocateButtonPressed:(id)sender {
    LHShopMapViewController *mapVC = [[LHShopMapViewController alloc] initWithShops:@[self.shop]];
    mapVC.isSingle = YES;
    LHNavigationController *mapNav = [[LHNavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:mapNav animated:YES completion:NULL];
}

- (IBAction)v2CommentButtonPressed:(id)sender {
    LHCommentListViewController *commentVC = [[LHCommentListViewController alloc] initWithShopid:self.shop.shopId.integerValue];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (IBAction)v2contactButtonPressed:(id)sender {
    if (!_shop.mobile) {
        JXToast(@"商家没有留联系电话");
        return;
    }
    [JXDevice callNumber:self.shop.mobile];
}

- (IBAction)v2FavoriteButtonPressed:(id)sender {
    if (![self.v2FavoriteCountLabel.text isEqualToString:@"收藏"]) {
        [self favoriteCheckMenuPressed:nil];
    }else {
        [self favoriteUncheckMenuPressed:nil];
    }
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

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    return nil;
//}
//
////- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
////    MWPhoto *photo = [self.photos objectAtIndex:index];
////    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
////    return [captionView autorelease];
////}
//
////- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
////    NSLog(@"ACTION!");
////}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
//}
//
//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}
//
////- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
////    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
////}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
@end




