//
//  AdvertDataModelTool.h
//  LoveHome
//
//  Created by Joe Chen on 14/12/25.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvertDataModel;
@interface AdvertDataModelTool : NSObject


/*!
 *  @brief  封装广告原数据为Advert对象
 *
 *  @param dataArray 原数据
 *
 *  @return 封装好的数据容器
 */
+ (NSArray *)packageAdvertListDataToObject:(NSArray *)dataArray;


/*!
 *  @brief  转换advertObjet为url数组
 *
 *  @param dataArray
 *
 *  @return
 */
+ (NSArray *)tranferAdvertObjectListToImageUrlList:(NSArray *)dataArray;


@end
