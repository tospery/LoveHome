//
//  LHTextViewCell.h
//  LoveHome-User-Clothes
//
//  Created by MRH-MAC on 15/7/31.
//  Copyright (c) 2015年 艾维科思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextCellModel.h"
@interface LHTextViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moenyTextFiled;
@property (nonatomic,strong) TextCellModel *textModel;
@end
