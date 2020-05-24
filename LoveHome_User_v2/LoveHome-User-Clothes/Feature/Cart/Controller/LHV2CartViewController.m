//
//  LHV2CartViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 16/3/7.
//  Copyright © 2016年 艾维科思. All rights reserved.
//

#import "LHV2CartViewController.h"
#import "LHV2ShopHeader.h"
#import "LHV2SpecifyCell.h"
#import "LHV2ShopFooter.h"
#import "LHV2DueHeader.h"
#import "LHV2DueFooter.h"
#import "LHReceiptViewController.h"
#import "LHOrderConfirmViewController.h"
#import "LHShopDetailViewController.h"

@interface LHV2CartViewController ()
@property (nonatomic, strong) NSMutableArray *cartShops;
//@property (nonatomic, strong) NSMutableArray *cartDues;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

// 收货地址
@property (nonatomic, weak) IBOutlet UILabel *receiptNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiptAddressLabel;

@end

@implementation LHV2CartViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupVar];
    [self setupView];
    [self setupDB];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [self configRecipt];
    //
//        if (kIsLocalCart || kIsInvalidCart) {
//            self.cartShops = gLH.cartShops;
//            [self.tableView reloadData];
//            [self configTotalInfo];
//            [self checkCartIsEmptyOrNot];
//            return;
//        }
    //
    //    if (gLH.logined) {
    //        [self requestCartInfoWithMode:JXWebLaunchModeSilent];
    //    }
    
    [self configRecipt];
    if (kIsLocalCart || kIsInvalidCart) {
        [self requestLocalCartInfoWithMode:JXWebLaunchModeSilent];
    }else {
        if (gLH.logined) {
            [self requestCartInfoWithMode:JXWebLaunchModeSilent];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (kIsLocalCart || kIsInvalidCart) {
        gLH.cartShops = [NSMutableArray arrayWithArray:self.cartShops];
    }
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    self.cartShops = [NSMutableArray array];
    //self.cartDues = [NSMutableArray array];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptSelected:) name:kNotifyReceiptSelected object:nil];
}

- (void)setupView {
    self.navigationItem.title = @"购物车";
    
    UINib *nib = [UINib nibWithNibName:@"LHV2SpecifyCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[LHV2SpecifyCell identifier]];
    nib = [UINib nibWithNibName:@"LHV2ShopHeader" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHV2ShopHeader identifier]];
    nib = [UINib nibWithNibName:@"LHV2ShopFooter" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHV2ShopFooter identifier]];
    nib = [UINib nibWithNibName:@"LHV2DueHeader" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHV2DueHeader identifier]];
    nib = [UINib nibWithNibName:@"LHV2DueFooter" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHV2DueFooter identifier]];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark assit
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

- (void)refrshUIForDelete {
    NSMutableArray *dels = [NSMutableArray array];
    for (LHCartShop *c in self.cartShops) {
        LHCartShop *cs = [[LHCartShop alloc] init];
        cs.shopID = c.shopID;
        cs.shopName = c.shopName;
        
        for (LHSpecify *s in c.specifies) {
            if (s.selected) {
                [cs.specifies addObject:s];
                [dels addObject:[s copy]];
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
    
    //gLH.cartShops = [NSMutableArray arrayWithArray:self.cartShops];
    
    if (self.cartShops.count == 0) {
        // [self alleditButtonPressed:self.navigationItem.rightBarButtonItem.customView];
    }
    
    if (!kIsLocalCart) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOnlineGoodsDeleted object:dels];
    }
}

- (void)delAll {
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
}

- (void)goOrder {
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
        LHOrderConfirmViewController *confirmVC = [[LHOrderConfirmViewController alloc] initWithCartShops:selected];
        confirmVC.hidesBottomBarWhenPushed = YES;
        confirmVC.from = _from;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }];
}

- (void)genCartShopsWithCartInfo:(LHCartInfo *)response {
    [self.cartShops removeAllObjects];
    for (LHCartInfoShop *shop in response.normalPro) {
        LHCartShop *myShop = [[LHCartShop alloc] init];
        myShop.shopID = shop.shopId;
        myShop.shopName = shop.shopName;
        for (LHCartInfoProduct *product in shop.products) {
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
        }
        
        for (LHCartInfoActivity *activity in shop.activictInfos) {
            for (LHCartInfoProduct *product in activity.products) {
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
                    
                    s2.actCategoryFlag = YES;
                    for (LHSpecify *ss in myShop.specifies) {
                        if ([ss.activityId isEqualToString:s2.activityId]) {
                            s2.actCategoryFlag = NO;
                            break;
                        }
                    }
                    
                    [myShop.specifies addObject:s2];
                }
            }
        }
        [self.cartShops addObject:myShop];
    }
    
    // 无效商品
    LHCartShop *myShop = [[LHCartShop alloc] init];
    myShop.dueFlag = YES;
    for (LHCartInfoShop *shop in response.passDueProducts) {
        for (LHCartInfoProduct *product in shop.products) {
            for (LHCartInfoSpecify *s1 in product.specifies) {
                LHSpecify *s2 = [LHSpecify new];
                s2.productId = product.uid;
                s2.pieces = s1.buyCount;
                s2.uid = s1.uid;
                s2.price = s1.price;
                s2.url = product.url;
                s2.dueFlag = YES;
                
                if ([s1.name isEqualToString:kProductNotSpecify]) {
                    s2.name = product.name;
                }else {
                    s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
                }
                
                [myShop.specifies addObject:s2];
            }
        }
        
        for (LHCartInfoActivity *activity in shop.activictInfos) {
            for (LHCartInfoProduct *product in activity.products) {
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
                    s2.dueFlag = YES;
                    
                    if (s1.discountPrice.length != 0) {
                        s2.price = s1.discountPrice;
                    }
                    
                    if ([s1.name isEqualToString:kProductNotSpecify]) {
                        s2.name = product.name;
                    }else {
                        s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
                    }
                    
                    s2.actCategoryFlag = YES;
                    for (LHSpecify *ss in myShop.specifies) {
                        if ([ss.activityId isEqualToString:s2.activityId]) {
                            s2.actCategoryFlag = NO;
                            break;
                        }
                    }
                    
                    [myShop.specifies addObject:s2];
                }
            }
        }
    }
    if (myShop.specifies.count != 0) {
        [self.cartShops addObject:myShop];
    }
    
    [JXLoadView hideForView:self.view];
    [self checkCartIsEmptyOrNot];
    [self.tableView reloadData];
}

#pragma mark request
- (void)requestLocalCartInfoWithMode:(JXWebLaunchMode)mode {
//    [
//     {
//         "shopId": 0,
//         "products": [
//                      {
//                          "productId": 0,
//                          "specId": 0
//                      }
//                      ]
//     }
//     ]
    
    // YJX_TODO
    
    NSMutableArray *params = [NSMutableArray array];
    for (LHCartShop *cs in gLH.cartShops) {
        NSMutableArray *products = [NSMutableArray array];
        for (LHSpecify *sp in cs.specifies) {
            NSMutableDictionary *product = [NSMutableDictionary dictionary];
            if (sp.productId.length != 0) {
                [product setObject:sp.productId forKey:@"productId"];
            }
            if (sp.uid.length != 0) {
                [product setObject:sp.uid forKey:@"specId"];
            }
            if (sp.activityId.length != 0) {
                [product setObject:sp.activityId forKey:@"activityId"];
            }
            if (sp.pieces != 0) {
                [product setObject:@(sp.pieces) forKey:@"buyCount"];
            }
            [products addObject:product];
        }
        [params addObject:@{@"shopId": cs.shopID ? cs.shopID : @"",
                           @"products": products.count == 0 ? @"" : products}];
    }
    
    [LHHTTPClient verifyShopCartProductInfos:params success:^(AFHTTPRequestOperation *operation, id response) {
//        self.cartShops = gLH.cartShops;
//        [self.tableView reloadData];
//        [self checkCartIsEmptyOrNot];
        [self genCartShopsWithCartInfo:response];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayShow error:error callback:^{
            [self requestCartInfoWithMode:mode];
        }];
    }];
}

- (void)requestCartInfoWithMode:(JXWebLaunchMode)mode {
    [LHHTTPClient getUserShopCartRecordWithAddressId:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, LHCartInfo *response) {
        [self genCartShopsWithCartInfo:response];
//        // 有效商品
//        [self.cartShops removeAllObjects];
//        for (LHCartInfoShop *shop in response.normalPro) {
//            LHCartShop *myShop = [[LHCartShop alloc] init];
//            myShop.shopID = shop.shopId;
//            myShop.shopName = shop.shopName;
//            for (LHCartInfoProduct *product in shop.products) {
//                for (LHCartInfoSpecify *s1 in product.specifies) {
//                    LHSpecify *s2 = [LHSpecify new];
//                    s2.productId = product.uid;
//                    s2.pieces = s1.buyCount;
//                    s2.uid = s1.uid;
//                    s2.price = s1.price;
//                    s2.url = product.url;
//                    
//                    if ([s1.name isEqualToString:kProductNotSpecify]) {
//                        s2.name = product.name;
//                    }else {
//                        s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
//                    }
//                    
//                    [myShop.specifies addObject:s2];
//                }
//            }
//            
//            for (LHCartInfoActivity *activity in shop.activictInfos) {
//                for (LHCartInfoProduct *product in activity.products) {
//                    for (LHCartInfoSpecify *s1 in product.specifies) {
//                        LHSpecify *s2 = [LHSpecify new];
//                        s2.productId = product.uid;
//                        s2.pieces = s1.buyCount;
//                        s2.uid = s1.uid;
//                        s2.price = s1.price;
//                        s2.activityId = activity.activityId;
//                        s2.actPriceType = activity.actPriceType;
//                        s2.activityTitle = activity.activityName;
//                        s2.actPrice = activity.actPrice;
//                        s2.actProductImgUrl = activity.actProductImgUrl;
//                        s2.url = product.url;
//                        
//                        if (s1.discountPrice.length != 0) {
//                            s2.price = s1.discountPrice;
//                        }
//                        
//                        if ([s1.name isEqualToString:kProductNotSpecify]) {
//                            s2.name = product.name;
//                        }else {
//                            s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
//                        }
//                        
//                        s2.actCategoryFlag = YES;
//                        for (LHSpecify *ss in myShop.specifies) {
//                            if ([ss.activityId isEqualToString:s2.activityId]) {
//                                s2.actCategoryFlag = NO;
//                                break;
//                            }
//                        }
//                        
//                        [myShop.specifies addObject:s2];
//                    }
//                }
//            }
//            [self.cartShops addObject:myShop];
//        }
//        
//        // 无效商品
//        LHCartShop *myShop = [[LHCartShop alloc] init];
//        myShop.dueFlag = YES;
//        for (LHCartInfoShop *shop in response.passDueProducts) {
//            for (LHCartInfoProduct *product in shop.products) {
//                for (LHCartInfoSpecify *s1 in product.specifies) {
//                    LHSpecify *s2 = [LHSpecify new];
//                    s2.productId = product.uid;
//                    s2.pieces = s1.buyCount;
//                    s2.uid = s1.uid;
//                    s2.price = s1.price;
//                    s2.url = product.url;
//                    s2.dueFlag = YES;
//                    
//                    if ([s1.name isEqualToString:kProductNotSpecify]) {
//                        s2.name = product.name;
//                    }else {
//                        s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
//                    }
//                    
//                    [myShop.specifies addObject:s2];
//                }
//            }
//            
//            for (LHCartInfoActivity *activity in shop.activictInfos) {
//                for (LHCartInfoProduct *product in activity.products) {
//                    for (LHCartInfoSpecify *s1 in product.specifies) {
//                        LHSpecify *s2 = [LHSpecify new];
//                        s2.productId = product.uid;
//                        s2.pieces = s1.buyCount;
//                        s2.uid = s1.uid;
//                        s2.price = s1.price;
//                        s2.activityId = activity.activityId;
//                        s2.actPriceType = activity.actPriceType;
//                        s2.activityTitle = activity.activityName;
//                        s2.actPrice = activity.actPrice;
//                        s2.actProductImgUrl = activity.actProductImgUrl;
//                        s2.url = product.url;
//                        s2.dueFlag = YES;
//                        
//                        if (s1.discountPrice.length != 0) {
//                            s2.price = s1.discountPrice;
//                        }
//                        
//                        if ([s1.name isEqualToString:kProductNotSpecify]) {
//                            s2.name = product.name;
//                        }else {
//                            s2.name = [NSString stringWithFormat:@"%@(%@)", product.name, s1.name];
//                        }
//                        
//                        s2.actCategoryFlag = YES;
//                        for (LHSpecify *ss in myShop.specifies) {
//                            if ([ss.activityId isEqualToString:s2.activityId]) {
//                                s2.actCategoryFlag = NO;
//                                break;
//                            }
//                        }
//                        
//                        [myShop.specifies addObject:s2];
//                    }
//                }
//            }
//        }
//        if (myShop.specifies.count != 0) {
//            [self.cartShops addObject:myShop];
//        }
//        
//        [JXLoadView hideForView:self.view];
//        
//        //        [self configTotalInfo];
//        [self checkCartIsEmptyOrNot];
//        [self.tableView reloadData];
        
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOnlineGoodsDeleted object:@[[s copy]]];
        }else {         // 批量删除
            [self refrshUIForDelete];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
}

- (void)requestEmptyFailureProductWithMode:(JXWebLaunchMode)mode {
    JXHUDProcessing(nil);
    [LHHTTPClient emptyFailureProduct:gLH.receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, id response) {
        JXHUDHide();
        [self.cartShops removeObjectAtIndex:(self.cartShops.count - 1)];
        [self checkCartIsEmptyOrNot];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:NULL];
    }];
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

#pragma mark - Action methods
- (IBAction)addressButtonPressed:(id)sender {
    LHReceiptViewController *vc = [[LHReceiptViewController alloc] init];
    vc.from = LHReceiptFromChoose;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartShops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LHCartShop *cs = [self.cartShops objectAtIndex:section];
    return cs.specifies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHCartShop *cs = [self.cartShops objectAtIndex:indexPath.section];
    LHSpecify *sp = cs.specifies[indexPath.row];
    return [LHV2SpecifyCell heightWithSpecify:sp];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHV2SpecifyCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHV2SpecifyCell identifier]];
    
    LHCartShop *cs = [self.cartShops objectAtIndex:indexPath.section];
    LHSpecify *sp = cs.specifies[indexPath.row];
    [cell configSpecify:sp inCart:YES];
    
    cell.checkCallback = ^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.countCallback = ^(BOOL plus) {
        if (kIsLocalCart) {
            if (plus) {
                sp.pieces += 1;
            }else {
                sp.pieces -= 1;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [self requestUpdateCountWithMode:JXWebLaunchModeHUD indexPath:indexPath specify:sp plus:plus];
        }
    };
    cell.deleteCallback = ^(LHSpecify *s) {
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
            
            // [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyOnlineGoodsDeleted object:nil];
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
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    LHCartShop *cs = [self.cartShops objectAtIndex:section];
    if (cs.dueFlag) {
        return [LHV2DueHeader height];
    }else {
        return [LHV2ShopHeader height];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    LHCartShop *cs = [self.cartShops objectAtIndex:section];
    if (cs.dueFlag) {
        return [LHV2DueFooter height];
    }else {
        return [LHV2ShopFooter height];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LHCartShop *cs = [self.cartShops objectAtIndex:section];
    if (cs.dueFlag) {
        LHV2DueHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHV2DueHeader identifier]];
        return header;
    }else {
        LHV2ShopHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHV2ShopHeader identifier]];
        header.cartShop = cs;
        header.checkCallback = ^() {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        header.editCallback = ^() {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        header.pressCallback = ^(NSInteger shopId) {
            LHShopDetailViewController *detailVC = [[LHShopDetailViewController alloc] initWithShopid:shopId];
            detailVC.from = LHEntryFromNone;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        };
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    LHCartShop *cs = [self.cartShops objectAtIndex:section];
    if (cs.dueFlag) {
        LHV2DueFooter *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHV2DueFooter identifier]];
        header.clearCallback = ^() {
            if (kIsLocalCart) {
                [self.cartShops removeObjectAtIndex:(self.cartShops.count - 1)];
                [self checkCartIsEmptyOrNot];
                [self.tableView reloadData];
            }else {
                [self requestEmptyFailureProductWithMode:JXWebLaunchModeHUD];
            }
        };
        return header;
    }else {
        LHV2ShopFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHV2ShopFooter identifier]];
        footer.cartShop = cs;
        footer.funcCallback = ^(LHCartShop *cartShop, BOOL goOrder) {
            if (goOrder) {
                [self goOrder];
            }else {
                [self delAll];
            }
        };
        return footer;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
