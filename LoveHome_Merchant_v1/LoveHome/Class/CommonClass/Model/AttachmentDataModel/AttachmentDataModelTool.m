//
//  AttachmentDataModelTool.m
//  LoveHome
//
//  Created by Joe Chen on 14/12/18.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import "AttachmentDataModelTool.h"
#import "AttachmentDataModel.h"

@implementation AttachmentDataModelTool


/*!
 *  @brief  封装附件原数据为Attachment对象
 *
 *  @param dataArray 原数据
 *
 *  @return 封装好的数据容器
 */
+ (NSArray *)packageAttachmentDataToObject:(NSArray *)dataArray
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
                
                AttachmentDataModel *dataModel = [[AttachmentDataModel alloc] init];

                [dataModel setValuesForKeysWithDictionary:dic];
                
                [resultArray addObject:dataModel];
            }
        }
        return resultArray;
    }
    return nil;
}


/*!
 *  @brief  转换attachmentObjet为url数组
 *
 *  @param dataArray
 *
 *  @return
 */
+ (NSArray *)tranferAttachmentObjectListToImageUrlList:(NSArray *)dataArray
{
    if (!JudgeContainerCountIsNull(dataArray))
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
        
        for (int i=0; i<[dataArray count]; i++)
        {
            id object = [dataArray objectAtIndex:i];
            
            if ([object isKindOfClass:[AttachmentDataModel class]])
            {
                AttachmentDataModel *attchmentObject = (AttachmentDataModel *)object;
                
                if (!JudgeContainerCountIsNull(attchmentObject.attachmenturl))
                {
                    [resultArray addObject:attchmentObject.attachmenturl];
                }
            }
        }
        return resultArray;
    }
    return nil;
}


/*!
 *  @brief  判断attachment是否是服务器数据
 *
 *  @param attachmentObject
 *
 *  @return BOOL
 */
+ (BOOL)isTheAttachmentObjectFromServer:(AttachmentDataModel *)attachmentObject
{
    BOOL isFrom = NO;
    
    if (attachmentObject && attachmentObject != nil)
    {
        if (!JudgeContainerCountIsNull(attachmentObject.attachmenturl))
        {
            isFrom = YES;
        }
    }
    
    return isFrom;
}


/*!
 *  @brief  判断数据源中是否有新图片数据需要上传
 *
 *  @param dataArray
 *
 *  @return BOOL
 */
+ (BOOL)isNeedUploadImageDataToServer:(NSArray *)dataArray
{
    BOOL isNeedUpload = NO;
    
    if (!JudgeContainerCountIsNull(dataArray))
    {
        for (int i = 0; i<[dataArray count]; i++)
        {
            AttachmentDataModel *attachmentObject = [dataArray objectAtIndex:i];
            
            if (attachmentObject && attachmentObject.image)
            {
                isNeedUpload = YES;
                
                return isNeedUpload;
            }
        }
    }
    return isNeedUpload;
}


/*!
 *  @brief  从数据源筛选添加的附件数据
 *
 *  @param dataArray
 *
 *  @return 添加的数据源
 */
+ (NSArray *)filterAddDataFromAttachmentObjectArray:(NSArray *)dataArray
{
    if (!JudgeContainerCountIsNull(dataArray))
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i<[dataArray count]; i++)
        {
            AttachmentDataModel *attachmentObject = [dataArray objectAtIndex:i];
            
            if (attachmentObject && attachmentObject.image)
            {
                [resultArray addObject:attachmentObject];
            }
        }
        
        return resultArray;
    }
    return nil;
}


/*!
 *  @brief  从数据源筛选来自服务器的附件数据
 *
 *  @param dataArray
 *
 *  @return 添加的数据源
 */
+ (NSArray *)filterOriginDataFromAttachmentObjectArray:(NSArray *)dataArray
{
    if (!JudgeContainerCountIsNull(dataArray))
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i<[dataArray count]; i++)
        {
            AttachmentDataModel *attachmentObject = [dataArray objectAtIndex:i];
            
            if (attachmentObject && !JudgeContainerCountIsNull(attachmentObject.attachmenturl))
            {
                [resultArray addObject:attachmentObject];
            }
        }
        
        return resultArray;
    }
    return nil;
}




@end
