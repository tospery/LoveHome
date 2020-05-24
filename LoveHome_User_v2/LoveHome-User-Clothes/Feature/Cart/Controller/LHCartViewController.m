//
//  LHCartViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/9/11.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHCartViewController.h"
#import "LHShopHeader.h"
#import "LHMoneyFooter.h"
#import "LHSpecifyCell.h"
#import "PaperButton.h"
#import "LHOrderConfirmViewController.h"
#import "LHVerifyShopCartPro.h"
#import "LHCartDueCell.h"
#import "LHCartInfo.h"
#import "LHReceiptViewController.h"
#import "LHShopDetailViewController.h"

@interface LHCartViewController ()
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL onceToken;

@property (nonatomic, strong) PaperButton *menuButton;
@property (nonatomic, strong) NSMutableArray *cartShops;
@property (nonatomic, strong) NSMutableArray *cartShopsDue;
@property (nonatomic, weak) IBOutlet UILabel *pricesLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UIButton *piecesButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableConstraint;

// 收货地址
@property (nonatomic, weak) IBOutlet UILabel *receiptNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptAddressLabel;
@end

@implementation LHCartViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.cartShops = gLH.cartShops;
    //    [self.tableView reloadData];
    //    [self configTotalInfo];
    //    [self checkCartIsEmptyOrNot];
    //
    //    [self requestInvalidProductsWithMode:JXWebLaunchModeSilent];
    
    
    [self configRecipt];
    
    if (kIsLocalCart || kIsInvalidCart) {
        self.cartShops = gLH.cartShops;
        [self.tableView reloadData];
        [self configTotalInfo];
        [self checkCartIsEmptyOrNot];
        return;
    }
    
    if (gLH.logined) {
        [self requestCartInfoWithMode:JXWebLaunchModeSilent];
    }
    
    //    [self showLoginIfNotLoginedWithFinish:^{
    //       [self requestCartInfoWithMode:JXWebLaunchModeSilent];
    //    }];
}

- (void)configRecipt {
    LHReceipt *receipt = gLH.receipt;
    
    if (kIsLocalCart) {
        self.receiptNameLabel.text = @"送货到：";
        self.receiptPhoneLabel.text = nil;
        self.receiptAddressLabel.text = receipt.address;
        return;
    }
    
    if (!receipt) {
        self.receiptNameLabel.text = nil;
        self.receiptPhoneLabel.text = nil;
        self.receiptAddressLabel.text = nil;
        return;
    }
    
    self.receiptNameLabel.text = [NSString stringWithFormat:@"收货人：%@", receipt.name];
    self.receiptPhoneLabel.text = receipt.mobile;
    self.receiptAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receipt.provinceName, receipt.cityName, receipt.areaName, receipt.address];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    _cartShops = [NSMutableArray array];
    _cartShopsDue = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptSelected:) name:kNotifyReceiptSelected object:nil];
}

- (void)setupView {
    self.navigationItem.title = @"购物车";
    
    if (LHEntryFromNone == _from) {
        _bottomConstraint.constant = 49;
        _tableConstraint.constant = 49.0f;
    }else {
        _bottomConstraint.constant = 0;
        _tableConstraint.constant = 0.0f;
    }
    
    //    self.menuButton = [PaperButton button];
    //    [self.menuButton addTarget:self action:@selector(alleditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    self.menuButton.tintColor = [UIColor lightGrayColor];
    //    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    //    self.navigationItem.rightBarButtonItem = barButton;
    
    UINib *nib = [UINib nibWithNibName:@"LHSpecifyCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[LHSpecifyCell identifier]];
    nib = [UINib nibWithNibName:@"LHShopHeader" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHShopHeader identifier]];
    nib = [UINib nibWithNibName:@"LHMoneyFooter" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHMoneyFooter identifier]];
    nib = [UINib nibWithNibName:@"LHCartDueCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[LHCartDueCell identifier]];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
- (void)requestCartInfoWithMode:(JXWebLaunchMode)mode {
    [LHHTTPClient getUserShopCartRecordWithAddressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, LHCartInfo *response) {
        // 有效商品
        [self.cartShops removeAllObjects];
        for (LHCartInfoShop *shop in response.normalPro) {
            LHCartShop *myShop = [[LHCartShop alloc] init];
            myShop.shopID = shop.shopId;
            myShop.shopName = shop.shopName;
            for (LHCartInfoProduct *product in shop.products) {
                //                if (product.specifies.count == 1) {
                //                    LHCartInfoSpecify *s1 = product.specifies[0];
                //
                //                    LHSpecify *s2 = [LHSpecify new];
                //                    s2.productId = product.uid;
                //                    s2.pieces = s1.buyCount;
                //                    s2.uid = s1.uid;
                //                    s2.name = product.name;
                //                    s2.price = s1.price;
                //                    s2.url = product.url;
                //                    s2.activityId = s1.activityId;
                //
                //                    [myShop.specifies addObject:s2];
                //                }else {
                for (LHCartInfoSpecify *s1 in product.specifies) {
                    LHSpecify *s2 = [LHSpecify new];
                    s2.productId = product.uid;
                    s2.pieces = s1.buyCount;
                    s2.uid = s1.uid;
                    s2.price = s1.price;
                    s2.url = product.url;
                    
                    if ([s1.name isEqualToString:kProductNotSpecify]) {
                        s2.name = product.name;
                    }else {
                        s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
                    }
                    
                    [myShop.specifies addObject:s2];
                }
                //}
            }
            for (LHCartInfoActivity *activity in shop.activictInfos) {
                //                @property (nonatomic, assign) LHSecondActivityType actPriceType;
                //                @property (nonatomic, assign) CGFloat actPrice;
                //                @property (nonatomic, strong) NSString *activityId;
                //                @property (nonatomic, strong) NSString *activityTitle;
                //                @property (nonatomic, strong) NSString *actProductImgUrl;
                
                //                LHSpecify *s = [LHSpecify new];
                ////                s2.productId = product.uid;
                ////                s2.pieces = s1.buyCount;
                ////                s2.uid = s1.uid;
                ////                s2.name = s1.name;
                ////                s2.price = s1.price;
                ////                s2.url = s1.url;
                ////                s2.activityId = s1.activityId;
                //                s.productId
                
                // [myShop.specifies addObject:s];
                
                for (LHCartInfoProduct *product in activity.products) {
//                    if (product.specifies.count == 1) {
//                        LHCartInfoSpecify *s1 = product.specifies[0];
//                        
//                        LHSpecify *s2 = [LHSpecify new];
//                        s2.productId = product.uid;
//                        s2.pieces = s1.buyCount;
//                        s2.uid = s1.uid;
//                        s2.name = product.name;
//                        s2.price = s1.price;
//                        s2.url = product.url;
//                        s2.activityId = s1.activityId;
//                        s2.actPriceType = activity.actPriceType;
//                        s2.activityTitle = activity.activityName;
//                        s2.actPrice = activity.actPrice;
//                        s2.actProductImgUrl = activity.actProductImgUrl;
//                        
//                        [myShop.specifies addObject:s2];
//                    }else {
                        for (LHCartInfoSpecify *s1 in product.specifies) {
                            LHSpecify *s2 = [LHSpecify new];
                            s2.productId = product.uid;
                            s2.pieces = s1.buyCount;
                            s2.uid = s1.uid;
                            s2.price = s1.price;
                            s2.activityId = activity.activityId;
                            s2.actPriceType = activity.actPriceType;
                            s2.activityTitle = activity.activityName;
                            s2.actPrice = activity.actPrice;
                            s2.actProductImgUrl = activity.actProductImgUrl;
                            s2.url = product.url;
                            
                            if (s1.discountPrice.length != 0) {
                                s2.price = s1.discountPrice;
                            }
                            
                            if ([s1.name isEqualToString:kProductNotSpecify]) {
                                s2.name = product.name;
                            }else {
                                s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
                            }
                            
                            [myShop.specifies addObject:s2];
                        }
                    // }
                }
            }
            [self.cartShops addObject:myShop];
        }
        
        // 无效商品
        //        [self.cartShopsDue removeAllObjects];
        //        for (LHCartInfoShop *shop in response.passDueProducts) {
        //            LHCartShop *myShop = [[LHCartShop alloc] init];
        //            myShop.shopID = shop.shopId;
        //            myShop.shopName = shop.shopName;
        //            for (LHCartInfoProduct *product in shop.products) {
        //                if (product.specifies.count == 1) {
        //                    LHCartInfoSpecify *s1 = product.specifies[0];
        //
        //                    LHSpecify *s2 = [LHSpecify new];
        //                    s2.productId = product.uid;
        //                    s2.pieces = s1.buyCount;
        //                    s2.uid = s1.uid;
        //                    s2.name = s1.name;
        //                    s2.price = s1.price;
        //                    s2.url = s1.url;
        //
        //                    [myShop.specifies addObject:s2];
        //                }else {
        //                    for (LHCartInfoSpecify *s1 in product.specifies) {
        //                        LHSpecify *s2 = [LHSpecify new];
        //                        s2.productId = product.uid;
        //                        s2.pieces = s1.buyCount;
        //                        s2.uid = s1.uid;
        //                        s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
        //                        s2.price = s1.price;
        //                        s2.url = s1.url;
        //
        //                        [myShop.specifies addObject:s2];
        //                    }
        //                }
        //            }
        //            // [self.cartShopsDue addObject:myShop]; // 避免错误， 过期
        //        }
        
        //JXHUDHide();
        [JXLoadView hideForView:self.view];
        
        [self configTotalInfo];
        [self checkCartIsEmptyOrNot];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
            [self requestCartInfoWithMode:mode];
        }];
    }];
}

- (void)requestUpdateCountWithMode:(JXWebLaunchMode)mode indexPath:(NSIndexPath *)indexPath specify:(LHSpecify *)s plus:(BOOL)plus {
    JXHUDProcessing(nil);
    [LHHTTPClient updateProdcutBuyCount:gLH.receipt.receiptID.integerValue specifieId:s.uid.integerValue buyCount:(plus ? (s.pieces + 1) : (s.pieces - 1)) activityId:s.activityId.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
        s.pieces = (plus ? (s.pieces + 1) : (s.pieces - 1));
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self configTotalInfo];
        JXHUDHide();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

- (void)requestDelProductWithMode:(JXWebLaunchMode)mode param:(NSDictionary *)param indexPath:(NSIndexPath *)indexPath specify:(LHSpecify *)s {
    JXHUDProcessing(nil);
    [LHHTTPClient batchClearProduct:param success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        
        if (indexPath) {    // 单个删除
            LHCartShop *cartShop = self.cartShops[indexPath.section];
            [cartShop.specifies removeObject:s];
            if (cartShop.specifies.count == 0) {
                [self.cartShops removeObject:cartShop];
                [self.tableView reloadData];
                [self checkCartIsEmptyOrNot];
            }else {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self configTotalInfo];
            
            if (!kIsLocalCart) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOnlineGoodsDeleted object:s.uid];
            }
        }else {         // 批量删除
            [self refrshUIForDelete];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

- (void)requestInvalidProductsWithMode:(JXWebLaunchMode)mode {
    if (_cartShops.count == 0) {
        return;
    }
    
    NSMutableArray *shops = [NSMutableArray array];
    for (LHCartShop *c in _cartShops) {
        LHVerifyShopCartProShop *shop = [LHVerifyShopCartProShop new];
        shop.shopId = c.shopID;
        NSMutableArray *products = [NSMutableArray array];
        for (LHSpecify *s in c.specifies) {
            LHVerifyShopCartProProduct *product = [LHVerifyShopCartProProduct new];
            product.productId = s.productId;
            product.specId = s.uid;
            [products addObject:[product JSONObject]];
        }
        shop.products = products;
        [shops addObject:[shop JSONObject]];
    }
    
    [LHHTTPClient getInvalidProductsWithParams:shops success:^(AFHTTPRequestOperation *operation, LHVerifyShopCartResult *response) {
        [_cartShopsDue removeAllObjects];
        if (response.passDueProducts.count != 0) {
            for (NSInteger i = 0; i < response.passDueProducts.count; ++i) {
                LHVerifyShopCartResultShop *shop = response.passDueProducts[i];
                for (NSInteger j = 0; j < shop.products.count; ++j) {
                    LHVerifyShopCartResultProduct *product = shop.products[j];
                    for (NSInteger m = 0; m < product.specifies.count; ++m) {
                        LHVerifyShopCartResultSpecify *specify = product.specifies[m];
                        if (specify.url.length == 0) {
                            specify.url = product.url;
                        }
                        if (product.specifies.count == 1) {
                            specify.name = [NSString stringWithFormat:@"%@(%@)", product.name, specify.name];
                        }
                        [_cartShopsDue addObject:specify];
                    }
                }
            }
            
            for (LHVerifyShopCartResultShop *s in response.passDueProducts) {
                for (LHVerifyShopCartResultProduct *p in s.products) {
                    for (LHVerifyShopCartResultSpecify *s2 in p.specifies) {
                        [self removeProductId:p.id specifyId:s2.id];
                    }
                }
            }
            
            [_tableView reloadData];
            [self checkCartIsEmptyOrNot];
            [self configTotalInfo];
        }
    } failure:NULL];
}

- (void)removeProductId:(NSString *)productId specifyId:(NSString *)specifyId {
    LHCartShop *c1 = nil;
    LHSpecify *s1;
    for (LHCartShop *c in _cartShops) {
        for (LHSpecify *s in c.specifies) {
            if ([s.uid isEqualToString:specifyId] &&
                [s.productId isEqualToString:productId]) {
                s1 = s;
                c1 = c;
                break;
            }
        }
        
        if (c1) {
            break;
        }
    }
}


#pragma mark assist
- (void)configTotalInfo {
    BOOL isAllChecked = YES;
    
    NSInteger totalPieces = 0;
    CGFloat totalPrices = 0.00f;
    for (LHCartShop *cs in self.cartShops) {
        for (LHSpecify *s in cs.specifies) {
            if (s.selected) {
                totalPieces += s.pieces;
                totalPrices += (s.price.floatValue * s.pieces);
            }else {
                isAllChecked = NO;
            }
        }
    }
    
    self.pricesLabel.text = [NSString stringWithFormat:@"￥%.2f", totalPrices];
    [self.piecesButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)totalPieces] forState:UIControlStateNormal];
    
    self.checkButton.selected = isAllChecked;
    
    if (self.cartShops.count == 0) {
        self.checkButton.selected = NO;
        [self.menuButton animateToMenu];
    }
}

- (void)checkCartIsEmptyOrNot {
    // YJX_TODO 有问题的代码
    for (int i = 0; i < self.cartShops.count; ++i) {
        LHCartShop *cs = self.cartShops[i];
        if (cs.specifies.count == 0) {
            [self.cartShops removeObject:cs];
            --i;
        }
    }
    
    if (_cartShops.count == 0) {
        [JXLoadView showResultAddedTo:self.view rect:CGRectZero image:[UIImage imageNamed:@"ic_cart_empty"] message:@"主人，我饿了！" functitle:@"去逛逛" callback:^{
            if (LHEntryFromNone == _from) {
                self.tabBarController.selectedIndex = 0;
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else {
        [JXLoadView hideForView:self.view];
    }
}

#pragma mark - Accessor methods

#pragma mark - Action methods
- (void)alleditButtonPressed:(PaperButton *)item {
    if (item.tag) {
        for (LHCartShop *cs in self.cartShops) {
            cs.isEditing = NO;
            for (LHSpecify *s in cs.specifies) {
                s.isEditing = NO;
            }
        }
        item.tag = 0;
        [self configTotalInfo];
    }else {
        for (LHCartShop *cs in self.cartShops) {
            cs.isEditing = YES;
            for (LHSpecify *s in cs.specifies) {
                s.isEditing = YES;
            }
        }
        item.tag = 1;
        [_piecesButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    _isEditing = item.tag;
    [self.tableView reloadData];
}

- (IBAction)allcheckButtonPressed:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    NSInteger totalPieces = 0;
    CGFloat totalPrices = 0.00f;
    for (LHCartShop *cs in self.cartShops) {
        for (LHSpecify *s in cs.specifies) {
            s.selected = btn.selected;
            
            if (s.selected) {
                totalPieces += s.pieces;
                totalPrices += (s.price.floatValue * s.pieces);
            }
        }
    }
    [self.tableView reloadData];
    
    self.pricesLabel.text = [NSString stringWithFormat:@"￥%.2f", totalPrices];
    
    if (!_isEditing) {
        [self.piecesButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)totalPieces] forState:UIControlStateNormal];
    }
}

- (IBAction)submitButtonPressed:(id)sender {
    if (_isEditing) {
        if (kIsLocalCart) {
            [self refrshUIForDelete];
        }else {
            NSMutableArray *specifieIds = [NSMutableArray array];
            for (LHCartShop *c in self.cartShops) {
                for (LHSpecify *s in c.specifies) {
                    if (s.selected) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(s.uid.integerValue) forKey:@"specifieId"];
                        if (s.activityId.length != 0) {
                            [dict setObject:@(s.activityId.integerValue) forKey:@"activityId"];
                        }
                        [specifieIds addObject:dict];
                    }
                }
            }
            
            NSDictionary *params = @{@"addressId": gLH.receipt.receiptID,
                                     @"specifieIds": specifieIds};
            [self requestDelProductWithMode:JXWebLaunchModeHUD param:params indexPath:nil specify:nil];
        }
        
        return;
    }
    
    
    NSMutableArray *selected = [NSMutableArray array];
    for (LHCartShop *c in self.cartShops) {
        LHCartShop *cs = [[LHCartShop alloc] init];
        cs.shopID = c.shopID;
        cs.shopName = c.shopName;
        
        for (LHSpecify *s in c.specifies) {
            if (s.selected) {
                [cs.specifies addObject:s];
            }
        }
        
        if (cs.specifies.count != 0) {
            [selected addObject:cs];
        }
    }
    
    if (selected.count == 0) {
        JXToast(@"主人，您还没有勾选需要购买的商品呢");
        return;
    }
    
    if (selected.count != 1) {
        JXToast(@"主人，不支持多店下单呢");
        return;
    }
    
    BOOL hasNormalProduct = NO;
    BOOL hasActiviyProduct = NO;
    for (LHSpecify *s in [selected[0] specifies]) {
        if (s.activityId.length != 0) {
            hasActiviyProduct = YES;
        }else {
            hasNormalProduct = YES;
        }
    }
    if (hasNormalProduct && hasActiviyProduct) {
        JXToast(@"主人，普通商品和活动商品不能同单呢");
        return;
    }
    
    [self showLoginIfNotLoginedWithFinish:^{
        NSLog(@"%@", selected);
        LHOrderConfirmViewController *confirmVC = [[LHOrderConfirmViewController alloc] initWithCartShops:selected];
        confirmVC.hidesBottomBarWhenPushed = YES;
        confirmVC.from = _from;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }];
}

- (IBAction)addressButtonPressed:(id)sender {
    LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
    vc.from = LHReceiptFromChoose;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refrshUIForDelete {
    for (LHCartShop *c in self.cartShops) {
        LHCartShop *cs = [[LHCartShop alloc] init];
        cs.shopID = c.shopID;
        cs.shopName = c.shopName;
        
        for (LHSpecify *s in c.specifies) {
            if (s.selected) {
                [cs.specifies addObject:s];
            }
        }
        
        if (cs.specifies.count != 0) {
            [c.specifies removeObjectsInArray:cs.specifies];
        }
    }
    
    for (int i = 0; i < self.cartShops.count; ++i) {
        LHCartShop *c = self.cartShops[i];
        if (c.specifies.count == 0) {
            [self.cartShops removeObject:c];
            --i;
        }
    }
    
    [self checkCartIsEmptyOrNot];
    [_tableView reloadData];
    
    if (self.cartShops.count == 0) {
        [self alleditButtonPressed:self.navigationItem.rightBarButtonItem.customView];
    }
}

#pragma mark - Notification methods
- (void)notifyReceiptSelected:(NSNotification *)notification {
    //    [self configReceipt:notification.object];
    //    //    [self.tipsView setHidden:YES];
    //    //    [self.receiptView setHidden:NO];
    //    //
    //    //    self.receiptNameLabel.text = [NSString stringWithFormat:@"收货人：%@", receipt.name];
    //    //    self.receiptPhoneLabel.text = receipt.mobile;
    //    //    self.receiptAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", receipt.provinceName, receipt.cityName, receipt.areaName, receipt.address];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    if (_cartShopsDue.count == 0) {
    //        return _cartShops.count;
    //    }else {
    //        return _cartShops.count + 1;
    //    }
    
    return _cartShops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section < _cartShops.count) {
    //        LHCartShop *cs = [_cartShops objectAtIndex:section];
    //        return cs.specifies.count;
    //    }else {
    //        return _cartShopsDue.count;
    //    }
    
    LHCartShop *cs = [_cartShops objectAtIndex:section];
    return cs.specifies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHSpecifyCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHSpecifyCell identifier]];
    LHCartShop *cs = [_cartShops objectAtIndex:indexPath.section];
    LHSpecify *sp = cs.specifies[indexPath.row];
    [(LHSpecifyCell *)cell configSpecify:sp inCart:YES];
    [(LHSpecifyCell *)cell setCheckCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        if (!_isEditing) {
            [self configTotalInfo];
        }
    }];
    [(LHSpecifyCell *)cell setCountCallback:^(BOOL plus) {
        if (kIsLocalCart) {
            if (plus) {
                sp.pieces += 1;
            }else {
                sp.pieces -= 1;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self configTotalInfo];
        }else {
            [self requestUpdateCountWithMode:JXWebLaunchModeHUD indexPath:indexPath specify:sp plus:plus];
        }
    }];
    [(LHSpecifyCell *)cell setDeleteCallback:^(LHSpecify *s) {
        if (kIsLocalCart) {
            LHCartShop *cartShop = self.cartShops[indexPath.section];
            [cartShop.specifies removeObject:s];
            if (cartShop.specifies.count == 0) {
                [self.cartShops removeObject:cartShop];
                [tableView reloadData];
                [self checkCartIsEmptyOrNot];
            }else {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self configTotalInfo];
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(s.uid.integerValue) forKey:@"specifieId"];
            if (s.activityId.length != 0) {
                [dict setObject:@(s.activityId.integerValue) forKey:@"activityId"];
            }
            
            NSDictionary *params = @{@"addressId": gLH.receipt.receiptID,
                                     @"specifieIds": @[dict]};
            [self requestDelProductWithMode:JXWebLaunchModeHUD param:params indexPath:indexPath specify:s];
        }
    }];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //    if (section < _cartShops.count) {
    //        return [LHShopHeader height];
    //    }else {
    //        return 0.0f;
    //    }
    
    return [LHShopHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if (section < _cartShops.count) {
    //        return [LHMoneyFooter height];
    //    }else {
    //        return 0.0f;
    //    }
    
    return [LHMoneyFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHShopHeader identifier]];
    
    [(LHShopHeader *)header setCartShop:_cartShops[section]];
    [(LHShopHeader *)header setCheckCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        if (!_isEditing) {
            [self configTotalInfo];
        }
    }];
    [(LHShopHeader *)header setEditCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [(LHShopHeader *)header setPressCallback:^(NSInteger shopId) {
        LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shopId];
        detailVC.from = LHEntryFromNone;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //    if (section < _cartShops.count) {
    //        UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHMoneyFooter identifier]];
    //        [(LHMoneyFooter *)footer setCartShop:_cartShops[section]];
    //        return footer;
    //    }else {
    //        return nil;
    //    }
    
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHMoneyFooter identifier]];
    [(LHMoneyFooter *)footer setCartShop:_cartShops[section]];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
