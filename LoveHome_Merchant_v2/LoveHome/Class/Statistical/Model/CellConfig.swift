//
//  CellConfig.swift
//  LoveHome
//
//  Created by MRH-MAC on 15/11/16.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit



class CellConfig: NSObject {

    var titleName :String?
    var imageUrl :String?
    var className :String?
 
    

    
    
    func setTitle(title:String,imgUrl:String) {
        titleName = title
        imageUrl = imgUrl
        

        
    }
    

}
