//
//  AttachmentDataModel.h
//  LoveHome
//
//  Created by Joe Chen on 14/12/18.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "BaseDataModel.h"

@interface AttachmentDataModel : BaseDataModel

@property (strong, nonatomic) NSNumber *attachmentid;
@property (copy,   nonatomic) NSString *attachmenturl;
@property (strong, nonatomic) UIImage  *image;

@end
