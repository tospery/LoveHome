//
//  CategoryModel.h
//  LoveHome
//
//  Created by MRH-MAC on 15/8/25.
//  Copyright (c) 2015年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"

@interface CategoryModel : BaseDataModel
@property (nonatomic,strong) NSString *categName;
@property (nonatomic,assign) BOOL  isSelect;
@property (nonatomic,assign) NSInteger cid;

@end
