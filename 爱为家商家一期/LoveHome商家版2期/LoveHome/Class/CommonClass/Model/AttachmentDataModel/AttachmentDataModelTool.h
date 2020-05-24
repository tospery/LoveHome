//
//  AttachmentDataModelTool.h
//  LoveHome
//
//  Created by Joe Chen on 14/12/18.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AttachmentDataModel;
@interface AttachmentDataModelTool : NSObject


/*!
 *  @brief  封装附件原数据为Attachment对象
 *
 *  @param dataArray 原数据
 *
 *  @return 封装好的数据容器
 */
+ (NSArray *)packageAttachmentDataToObject:(NSArray *)dataArray;


/*!
 *  @brief  转换attachmentObjet为url数组
 *
 *  @param dataArray
 *
 *  @return
 */
+ (NSArray *)tranferAttachmentObjectListToImageUrlList:(NSArray *)dataArray;


/*!
 *  @brief  判断attachment是否是服务器数据
 *
 *  @param attachmentObject
 *
 *  @return BOOL
 */
+ (BOOL)isTheAttachmentObjectFromServer:(AttachmentDataModel *)attachmentObject;


/*!
 *  @brief  判断数据源中是否有新图片数据需要上传
 *
 *  @param dataArray
 *
 *  @return BOOL
 */
+ (BOOL)isNeedUploadImageDataToServer:(NSArray *)dataArray;


/*!
 *  @brief  从数据源筛选添加的附件数据
 *
 *  @param dataArray
 *
 *  @return 添加的数据源
 */
+ (NSArray *)filterAddDataFromAttachmentObjectArray:(NSArray *)dataArray;



/*!
 *  @brief  从数据源筛选来自服务器的附件数据
 *
 *  @param dataArray
 *
 *  @return 添加的数据源
 */
+ (NSArray *)filterOriginDataFromAttachmentObjectArray:(NSArray *)dataArray;









@end
