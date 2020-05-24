//
//  HttpServiceManagerTool.h
//  LoveHome
//
//  Created by MRH-MAC on 14/12/3.
//  Copyright (c) 2014年 卡莱博尔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreatShops.h"
#import "HttpServiceManageObject.h"

typedef void (^CreatShopToolBlock)(AFHTTPRequestOperation *operation,id responsObject);

@interface HttpServiceManagerTool : NSObject

{
    CreatShopToolBlock requestSucceedCallback;
    CreatShopToolBlock requestFailedCallback;
}
//@property (nonatomic ,strong) HttpServiceManageObject *serViceManager;




@end
