//
//  LHAddressViewController.m
//  LoveHome-User-Clothes
//
//  Created by 杨建祥 on 15/8/24.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import "LHReceiptViewController.h"
#import "LHReceiptCell.h"
#import "LHReceiptFooterView.h"
#import "LHReceiptModify2ViewController.h"

@interface LHReceiptViewController ()
@property (nonatomic, strong) NSMutableArray *receipts;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation LHReceiptViewController
#pragma mark - Override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initDB];
    [self initNet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
#pragma mark init
- (void)initView {
    if (LHReceiptFromChoose == _from) {
        self.navigationItem.title = @"选择收货地址";
    }else {
        self.navigationItem.title = @"收货地址管理";
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"LHReceiptCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[LHReceiptCell identifier]];
    
//    LHReceiptFooterView *footerView = [[LHReceiptFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 76)];
//    [footerView setupAddPressedBlock:^(UIButton *button) {
//        LHReceiptModify2ViewController *vc = [[LHReceiptModify2ViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    self.tableView.tableFooterView = footerView;
//    self.tableView.sectionFooterHeight = 76.0f;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.frame = CGRectMake(0, 0, kJXScreenWidth, 20.0f);
    self.tableView.tableFooterView = footerView;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    [addButton setTitleColor:ColorHex(0x666666) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestReceiptsWithMode:JXWebLaunchModeRefresh];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyReceiptChanged:) name:kNotifyReceiptChanged object:nil];
}

- (void)addButtonPressed:(id)sender {
    LHReceiptModify2ViewController *vc = [[LHReceiptModify2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initDB {
}

- (void)initNet {
    [self requestReceiptsWithMode:JXWebLaunchModeLoad];
}

#pragma mark web
- (void)requestReceiptsWithMode:(JXWebLaunchMode)mode {
    switch (mode) {
        case JXWebLaunchModeLoad: {
//            [JXLoadView showProcessingAddedTo:self.view rect:CGRectZero];
//            [self.operaters exAddObject:
//             [LHHTTPClient getReceiptsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *receipts) {
//                [self.receipts addObjectsFromArray:receipts];
//                [self.tableView reloadData];
//                [JXLoadView hideForView:self.view];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [self handleFailureForView:self.view rect:CGRectZero mode:mode way:JXWebHandleWayToast error:error callback:^{
//                    [self requestReceiptsWithMode:mode];
//                }];
//            }]];
            
            [JXLoadView showProcessingAddedTo:self.tableView rect:self.tableRect];
            [self.operaters exAddObject:
             [LHHTTPClient getReceiptsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *receipts) {
                [self.receipts addObjectsFromArray:receipts];
                [self.tableView reloadData];
                
                if (self.receipts.count == 0) {
                    [JXLoadView showResultAddedTo:self.tableView rect:self.tableRect image:[UIImage imageNamed:@"ic_position_empty_bg"] message:@"还没有收获地址，快去新建吧" functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.tableView];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestReceiptsWithMode:mode];
                }];
            }]];
            
            break;
        }
        case JXWebLaunchModeRefresh: {
            [self.operaters exAddObject:
             [LHHTTPClient getReceiptsWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *receipts) {
                [self.tableView.header endRefreshing];
                [self.receipts removeAllObjects];
                [self.receipts addObjectsFromArray:receipts];
                [self.tableView reloadData];
                
                if (self.receipts.count == 0) {
                    [JXLoadView showResultAddedTo:self.tableView rect:self.tableRect image:[UIImage imageNamed:@"ic_position_empty_bg"] message:nil functitle:nil callback:NULL];
                }else {
                    [JXLoadView hideForView:self.tableView];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self handleFailureForView:self.tableView rect:self.tableRect mode:mode way:JXWebHandleWayToast error:error callback:^{
                    [self requestReceiptsWithMode:mode];
                }];
            }]];
            break;
        }
        default:
            break;
    }
}

- (void)requestDelete:(LHReceipt *)receipt {
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient delReceiptWithUid:receipt.receiptID.integerValue success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        JXHUDHide();
        if (!result.boolValue) {
            JXToast(@"咦，册除失败了~");
        }else {
            [self.receipts removeObject:receipt];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestDelete:receipt];
        }];
    }]];
}

- (void)requestSetDefault:(LHReceipt *)receipt {
    if (receipt.isDefault) {
        gLH.receipt = receipt;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptSelected object:receipt];
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    JXHUDProcessing(nil);
    [self.operaters exAddObject:
     [LHHTTPClient setDefaultReceiptWithUid:@(receipt.receiptID.integerValue) success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        JXHUDHide();
        if (!result.boolValue) {
            JXToast(@"咦~请重新设置收货地址");
        }else {
//            if (LHReceiptFromChoose == _from) {
//                receipt.isDefault = YES;
//                gLH.receipt = receipt;
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptSelected object:receipt];
//                [self.navigationController popViewControllerAnimated:YES];
//            }else if (LHReceiptFromManage == _from) {
//                for (LHReceipt *obj in self.receipts) {
//                    if ([obj.receiptID isEqualToString:receipt.receiptID]) {
//                        obj.isDefault = YES;
//                    }else {
//                        obj.isDefault = NO;
//                    }
//                }
//                [self.tableView reloadData];
//            }
            
            for (LHReceipt *obj in self.receipts) {
                if ([obj.receiptID isEqualToString:receipt.receiptID]) {
                    obj.isDefault = YES;
                }else {
                    obj.isDefault = NO;
                }
            }
            [self.tableView reloadData];
            
            receipt.isDefault = YES;
            gLH.receipt = receipt;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptSelected object:receipt];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailureForView:nil rect:CGRectZero mode:JXWebLaunchModeHUD way:JXWebHandleWayToast error:error callback:^{
            [self requestSetDefault:receipt];
        }];
    }]];
}

#pragma mark - Accessor methods
- (NSMutableArray *)receipts {
    if (!_receipts) {
        _receipts = [NSMutableArray array];
    }
    return _receipts;
}

- (CGRect)tableRect {
    if (CGRectEqualToRect(_tableRect, CGRectZero)) {
        _tableRect = CGRectMake(0, 0, kJXScreenWidth, kJXScreenHeight - 64);
    }
    return _tableRect;
}

#pragma mark - Notify methods
- (void)notifyReceiptChanged:(NSNotification *)notification {
    LHReceipt *receipt = notification.object;
    
    NSInteger index = 0;
    for (index = 0; index < self.receipts.count; ++index) {
        LHReceipt *obj = self.receipts[index];
        if ([obj.receiptID isEqualToString:receipt.receiptID]) {
            break;
        }
    }
    
    if (index == self.receipts.count) {
        if (receipt) {
            [self.receipts addObject:receipt];
        }
    }else {
        if (receipt) {
            [self.receipts replaceObjectAtIndex:index withObject:receipt];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receipts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LHReceiptCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LHReceiptCell identifier]];
    [(LHReceiptCell *)cell setReceipt:self.receipts[indexPath.row]];
    [(LHReceiptCell *)cell setupEditPressedBlock:^(UIButton *button) {
        LHReceiptModify2ViewController *vc = [[LHReceiptModify2ViewController alloc] init];
        vc.receipt = self.receipts[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } deletePressedBlock:^(UIButton *button) {
        [self requestDelete:self.receipts[indexPath.row]];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (LHReceiptFromChoose == _from) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyReceiptSelected object:self.receipts[indexPath.row]];
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else if (LHReceiptFromManage == _from) {
    //        [self requestSetDefault:self.receipts[indexPath.row]];
    //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    }
    
    [self requestSetDefault:self.receipts[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

@end



