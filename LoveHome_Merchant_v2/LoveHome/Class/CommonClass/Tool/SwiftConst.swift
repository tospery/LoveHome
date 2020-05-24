//
//  SwiftConst.swift
//  LoveHome
//
//  Created by MRH-MAC on 15/11/16.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit


let kScreenW = UIScreen.mainScreen().bounds.size.width
let kScrennH = UIScreen.mainScreen().bounds.size.height
let kBackgroudColor = colorWithRex(0xF4F4F4,alphe: 1.0)


let kShareSwiftConst = SwiftConst.sharedSwiftConst

class SwiftConst: NSObject {
    class var sharedSwiftConst : SwiftConst {
        struct Static {
            static let sharedInstance : SwiftConst = SwiftConst()
        }
        
        return Static.sharedInstance
    }
    
}

// 设置颜色16进制
func colorWithRex(hexValue:NSInteger,alphe:CGFloat) ->UIColor
{

    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hexValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hexValue & 0xFF))/255.0, alpha: alphe)

    
}



func ASD() {
    
}


class TestDanli : NSObject {
    static let sharedTestDanli = TestDanli()
    private override init() {
        
    }
    

}