//
//  AdvertDataModelTool.m
//  LoveHome
//
//  Created by MRH on 14/12/25.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "AdvertDataModelTool.h"
#import "AdvertDataModel.h"

@implementation AdvertDataModelTool

/*!
 *  @brief  封装广告原数据为Advert对象
 *
 *  @param dataArray 原数据
 *
 *  @return 封装好的数据容器
 */
+ (NSArray *)packageAdvertListDataToObject:(NSArray *)dataArray
{
    if (!JudgeContainerCountIsNull(dataArray))
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
        
        for (int i=0; i<[dataArray count]; i++)
        {
            id object = [dataArray objectAtIndex:i];
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary *)object;
                
                AdvertDataModel *dataModel = [[AdvertDataModel alloc] init];
                
                [dataModel setValuesForKeysWithDictionary:dic];
                
                [resultArray addObject:dataModel];
            }
        }
        return resultArray;
    }
    return nil;
}


/*!
 *  @brief  转换advertObjet为url数组
 *
 *  @param dataArray
 *
 *  @return
 */
+ (NSArray *)tranferAdvertObjectListToImageUrlList:(NSArray *)dataArray
{
    if (!JudgeContainerCountIsNull(dataArray))
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
        
        for (int i=0; i<[dataArray count]; i++)
        {
            id object = [dataArray objectAtIndex:i];
            
            if ([object isKindOfClass:[AdvertDataModel class]])
            {
                AdvertDataModel *attchmentObject = (AdvertDataModel *)object;
                
                if (!JudgeContainerCountIsNull(attchmentObject.imgurl))
                {
                    [resultArray addObject:attchmentObject.imgurl];
                }
            }
        }
        return resultArray;
    }
    return nil;
}

@end
