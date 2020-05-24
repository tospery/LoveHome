//
//  LHSwiftHttp.swift
//  LoveHome
//
//  Created by MRH on 15/11/30.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit
//(AFHTTPRequestOperation *operation,id responsObject);

typealias SuccessBlock = (operation:AFHTTPRequestOperation,responsObject:AnyObject) -> Void
typealias FailBlock = (operation:AFHTTPRequestOperation,error:NSError) -> Void
class LHSwiftHttp: NSObject {

    static func requestOrderPriceStatistl(starDay : String ,endDay : String , sucess:SuccessBlock ,fail:FailBlock )
    {
        let parameter : NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(starDay, forKey: "startDate")
        parameter.setValue(endDay, forKey: "endDate")
        
        HttpServiceManageObject .sendPostRequestWithPathUrl("wallet/getShopWalletMonth", andToken: true, andParameterDic:parameter, andParameterType: kHttpRequestParameterType_KeyValue, andSucceedCallback: { (operation:AFHTTPRequestOperation!, responsObject:AnyObject!) -> Void in
            
            var arry :[IncomModel] = []
            print(responsObject)
             if let response = responsObject as? Array<AnyObject>
            {
                
                for value in response
                {
                    let mode = IncomModel(keyValues: value)
                    arry.append(mode)
                }
                
                if arry.count > 1
                {
                    arry  =  arry.sort({ (part1, part2) -> Bool in
                        let Da1 = float_t(part1.startDate)
                        let Da2 = float_t(part2.startDate)
                        return Da1 > Da2 ? true : false
                    })

                }
                
                sucess(operation: operation,responsObject: arry)
            }
            
            
            }) { (opreation:AFHTTPRequestOperation!, error:NSError!) -> Void in
         
                fail(operation: opreation, error: error)
        }
    }
    
}
