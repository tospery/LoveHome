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

@interface LHCartViewController ()
@property (nonatomic, assign) BOOL onceToken;

@property (nonatomic, strong) PaperButton *menuButton;
@property (nonatomic, strong) NSMutableArray *cartShops;
@property (nonatomic, weak) IBOutlet UILabel *pricesLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UIButton *piecesButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableConstraint;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cartShops = gLH.cartShops;
    [self.tableView reloadData];
    
    //if (!_onceToken) {
        //_onceToken = YES;
        [self configTotalInfo];
    //}
    
    [self checkCartIsEmptyOrNot];
}

#pragma mark - Private methods
#pragma mark setup
- (void)setupVar {
    
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
    
    self.menuButton = [PaperButton button];
    [self.menuButton addTarget:self action:@selector(alleditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton.tintColor = [UIColor lightGrayColor];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    self.navigationItem.rightBarButtonItem = barButton;
    
    UINib *nib = [UINib nibWithNibName:@"LHSpecifyCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:[LHSpecifyCell identifier]];
    nib = [UINib nibWithNibName:@"LHShopHeader" bundle:nil];
    
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHShopHeader identifier]];
    nib = [UINib nibWithNibName:@"LHMoneyFooter" bundle:nil];
    [_tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[LHMoneyFooter identifier]];
}

- (void)setupDB {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
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
    for (LHCartShop *cs in _cartShops) {
        if (cs.specifies.count == 0) {
            [_cartShops removeObject:cs];
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
- (NSMutableArray *)cartShops {
    if (!_cartShops) {
        _cartShops = [NSMutableArray array];
    }
    return _cartShops;
}

#pragma mark - Action methods
- (void)alleditButtonPressed:(UIBarButtonItem *)item {
    if (item.tag) {
        for (LHCartShop *cs in self.cartShops) {
            cs.isEditing = NO;
            for (LHSpecify *s in cs.specifies) {
                s.isEditing = NO;
            }
        }
        item.tag = 0;
    }else {
        for (LHCartShop *cs in self.cartShops) {
            cs.isEditing = YES;
            for (LHSpecify *s in cs.specifies) {
                s.isEditing = YES;
            }
        }
        item.tag = 1;
    }
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
    [self.piecesButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)totalPieces] forState:UIControlStateNormal];
}

- (IBAction)submitButtonPressed:(id)sender {
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
    
    [self showLoginIfNotLoginedWithFinish:^{
        NSLog(@"%@", selected);
        LHOrderConfirmViewController *confirmVC = [[LHOrderConfirmViewController alloc] initWithCartShops:selected];
        confirmVC.hidesBottomBarWhenPushed = YES;
        confirmVC.from = _from;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }];
}

#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"%ld", (long)_cartShops.count);
    return _cartShops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LHCartShop *cs = [_cartShops objectAtIndex:section];
    return cs.specifies.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHSpecifyCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHSpecifyCell identifier]];
    LHCartShop *cs = [_cartShops objectAtIndex:indexPath.section];
    [(LHSpecifyCell *)cell configSpecify:cs.specifies[indexPath.row] inCart:YES];
    [(LHSpecifyCell *)cell setCheckCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self configTotalInfo];
    }];
    [(LHSpecifyCell *)cell setCountCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self configTotalInfo];
    }];
    [(LHSpecifyCell *)cell setDeleteCallback:^(LHSpecify *s) {
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
    }];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LHShopHeader height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [LHMoneyFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHShopHeader identifier]];
    
    [(LHShopHeader *)header setCartShop:_cartShops[section]];
    [(LHShopHeader *)header setCheckCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self configTotalInfo];
    }];
    [(LHShopHeader *)header setEditCallback:^() {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LHMoneyFooter identifier]];
    [(LHMoneyFooter *)footer setCartShop:_cartShops[section]];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Public methods
#pragma mark - Class methods

@end
