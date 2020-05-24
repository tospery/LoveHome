//
//  OrderDetailViewController.m
//  LoveHome
//
//  Created by MRH-MAC on 15/9/1.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "DetailNormlHearCell.h"
#import "OrdeAReadyCell.h"
#import "OrderRejectViewCell.h"
#import "OrderTitleCell.h"
#import "OrderProductCell.h"
#import "OrderPayWayCell.h"
#import "RecctAndRejectToolBar.h"
#import "OrderTools.h"
#import "ErrorHandleTool.h"
#import "RemarkFooterView.h"
#define kOrderTitleCell @"OrderTitleCell"
#define kOrderProductCell @"OrderProductCell"
#define kOrderPayWalCell @"OrderPayWayCell"
#define kBotmHeight 60
@interface OrderDetailViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) RecctAndRejectToolBar *tooBr;

@end

@implementation OrderDetailViewController

- (id)initWithOrder:(OrderModel *)order withOrderType:(OrderType)orderTyep
{
    self = [super init];
    if (self) {
        self.type = orderTyep;
        self.orderDetail = order;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"订单详情";
    [self setUpSubViews];
    [self.view addSubview:self.myTableView];
    
    [OrderTools getDetailWithOrderid:_orderDetail.orderid success:^(AFHTTPRequestOperation *operation, id responsObject) {
        
        [_orderDetail setKeyValues:responsObject];
        [_myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    if (_type == OrderTypeAdded ||  _type == OrderTypeUnhandled) {
        _tooBr = [[NSBundle mainBundle] loadNibNamed:@"RecctAndRejectToolBar" owner:nil options:nil].lastObject;
        __weak __typeof(self)weakSelf = self;
        
        if (self.orderDetail.status == 12) {
            
            if (self.orderDetail.collectedByMerchant) {
                [_tooBr.rightButton setTitle:@"等待确认" forState:UIControlStateNormal];
                [_tooBr.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_tooBr.rightButton setBackgroundColor:[UIColor darkGrayColor]];
                _tooBr.leftButton.hidden = YES;
            }
            else
            {
                [_tooBr.rightButton setTitle:@"确认收衣" forState:UIControlStateNormal];
                _tooBr.rightClick = ^()
                {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    ShowProgressHUD(YES, nil);
                    [OrderTools confirmOrderClothesWithWating:strongSelf.orderDetail.orderid success:^(AFHTTPRequestOperation *operation, id responsObject) {
                        ShowProgressHUD(NO, nil);
                        strongSelf.tooBr.hidden = YES;
                        JXToast(@"收衣成功");
                        if (strongSelf.rightActionBlcok) {
                            
                            strongSelf.rightActionBlcok(strongSelf.orderDetail,strongSelf.type);
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        ShowProgressHUD(NO, nil);
                        [ErrorHandleTool handleErrorWithCode:error toShowView:strongSelf.view didFinshi:nil cancel:nil];
                    }];
                    
                };
                
                _tooBr.leftClick = ^()
                {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加拒绝理由" message:nil delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [alert show];
                    
                    if (strongSelf.leftActionBlcok) {
                        strongSelf.leftActionBlcok(strongSelf.orderDetail,strongSelf.type);
                    }
                };

            }
            
        }
        
        // 接单
        else
        {
            _tooBr.rightClick = ^()
            {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                ShowProgressHUD(YES, nil);
                [OrderTools acceptWithOrderid:strongSelf.orderDetail.orderid success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
                    ShowProgressHUD(NO, nil);
                    strongSelf.tooBr.hidden = YES;
                    ShowWaringAlertHUD(@"订单接受成功", nil);
                    if (strongSelf.rightActionBlcok) {
                        strongSelf.rightActionBlcok(strongSelf.orderDetail,strongSelf.type);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    ShowProgressHUD(NO, nil);
                }];
                
                
                
            };
            
            _tooBr.leftClick = ^()
            {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请添加拒绝理由" message:nil delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                
                if (strongSelf.leftActionBlcok) {
                    strongSelf.leftActionBlcok(strongSelf.orderDetail,strongSelf.type);
                }
            };
            
           
        }
        [self.view addSubview:_tooBr];
        _tooBr.backgroundColor = [UIColor clearColor];
        [_tooBr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(kBotmHeight);
        }];

        
       
    }
    else
    {
        _myTableView.height += kBotmHeight;
    }
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _orderDetail.orderDetailList.count + 1;
    }
    else
    {
        return 1;     
    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self getCurrentCell:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_type == OrderTypeFinished) {
            return [OrdeAReadyCell heightForOrder:_orderDetail];
        }else if (_type == OrderTypeRejected) {
            return [OrderRejectViewCell heightWithOrder:_orderDetail];
        }else {
            return 170;
        }
  
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            return 40;
        }
        else
        {
            return 60;
        }

    }
    else
    {
       return [OrderPayWayCell getCellHeight:_orderDetail];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
         return  [RemarkFooterView getCellHeight:_orderDetail];

    }
    else
    {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        RemarkFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[RemarkFooterView cellIndentiferStr]];
        view.remarkContent.text = _orderDetail.remark;
        view.backgroundColor = [UIColor redColor];
        return view;
        
    }
    return nil;

}

- (UITableViewCell *)getCurrentCell:(NSIndexPath *)indextPath
{
    if (indextPath.section == 0) {
     
        if (_type == OrderTypeFinished) {
            
            OrdeAReadyCell *cell = [_myTableView dequeueReusableCellWithIdentifier:[OrdeAReadyCell identifier]];
            cell.orderDetail = _orderDetail;
            return cell;
        }
        else if (_type == OrderTypeRejected)
        {
            OrderRejectViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:[OrderRejectViewCell identifier]];
            cell.orderDetail = _orderDetail;
            return cell;
 
        }
        else
        {
            DetailNormlHearCell *cell = [_myTableView dequeueReusableCellWithIdentifier:[DetailNormlHearCell identifier]];
            cell.order = _orderDetail;
            return cell;
            
        }

        
    }
    else if (indextPath.section == 1)
    {
        
        if (indextPath.row == 0) {
            OrderTitleCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kOrderTitleCell];
            cell.ordeEntity = _orderDetail;
            return cell;
        }
        else
        {
            OrderProductCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kOrderProductCell];
            cell.detailMolde = _orderDetail.orderDetailList[indextPath.row - 1];
            return cell;
        }
    }
    else
    {
        OrderPayWayCell *cell = [_myTableView dequeueReusableCellWithIdentifier:kOrderPayWalCell];
        cell.order = _orderDetail;
        return cell;
    }
    
    
}


#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex || !_orderDetail) {
        return;
    }
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (textField.text.length == 0) {
        JXToast(@"必须填写拒绝理由");
        return;
    }
    
  
    if (_type == OrderTypeRectClothes || _orderDetail.status == 12) {
        
        ShowProgressHUD(YES, nil);
        [OrderTools rejectClothesWithOrderid:_orderDetail.orderid reason:textField.text success:^(AFHTTPRequestOperation *operation, id responsObject) {
            
            ShowProgressHUD(NO, nil);
            ShowWaringAlertHUD(@"订单拒绝成功", nil);
            _tooBr.hidden = YES;
            if (_leftActionBlcok) {
                _leftActionBlcok(_orderDetail,_type);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            ShowProgressHUD(NO, nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [ErrorHandleTool handleErrorWithCode:error toShowView:nil didFinshi:^{
                    
                } cancel:NULL];
            });
            
        }];
        
        return;
        

    }
    
    
    
    ShowProgressHUD(YES, nil);
    [OrderTools rejectWithOrderid:_orderDetail.orderid reason:textField.text success:^(AFHTTPRequestOperation *operation, NSNumber *result) {
        
        ShowProgressHUD(NO, nil);
        ShowWaringAlertHUD(@"订单拒绝成功", nil);
        _tooBr.hidden = YES;
        if (_leftActionBlcok) {
            _leftActionBlcok(_orderDetail,_type);
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            ShowProgressHUD(NO, nil);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            });


        
    }];

    


}

- (void)setUpSubViews
{
    [self initNavBar];
    
}

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, self.view.height - 30 - 64 - kBotmHeight) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = self.view.backgroundColor;
        [_myTableView registerNib:[UINib nibWithNibName:[DetailNormlHearCell identifier] bundle:nil] forCellReuseIdentifier:[DetailNormlHearCell identifier]];
        [_myTableView registerNib:[UINib nibWithNibName:[OrdeAReadyCell identifier] bundle:nil] forCellReuseIdentifier:[OrdeAReadyCell identifier]];
         [_myTableView registerNib:[UINib nibWithNibName:[OrderRejectViewCell identifier] bundle:nil] forCellReuseIdentifier:[OrderRejectViewCell identifier]];
        [_myTableView registerNib:[UINib nibWithNibName:kOrderTitleCell bundle:nil] forCellReuseIdentifier:kOrderTitleCell];
        [_myTableView registerNib:[UINib nibWithNibName:kOrderProductCell bundle:nil] forCellReuseIdentifier:kOrderProductCell];
        [_myTableView registerNib:[UINib nibWithNibName:kOrderPayWalCell bundle:nil] forCellReuseIdentifier:kOrderPayWalCell];
        [_myTableView registerNib:[UINib nibWithNibName:[RemarkFooterView cellIndentiferStr] bundle:nil] forHeaderFooterViewReuseIdentifier:[RemarkFooterView cellIndentiferStr]];
    }
        return _myTableView;
}

- (void)initNavBar
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleLable.text = [[OrderTools sharedOrderTools] orderNameWithType:_type];
    titleLable.backgroundColor = COLOR_CUSTOM(123, 215, 214, 1);
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
