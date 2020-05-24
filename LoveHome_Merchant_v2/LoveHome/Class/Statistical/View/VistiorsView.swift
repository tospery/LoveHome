//
//  VistiorsView.swift
//  LoveHome
//
//  Created by MRH on 15/11/24.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit
let topSpace :CGFloat = 60.0
let leftSpace :CGFloat = 30.0
let rightSpace :CGFloat = 20.0
let bottomSpace :CGFloat = 20.0

class VistiorsView: UIView {

    
    private lazy var sgementControl:UISegmentedControl =
    {
        let segment =  UISegmentedControl(items: ["30天","60天","90天"])
        segment.center.x = self.centerX
        segment.centerY = 25
        segment.bounds = CGRectMake(0,0,kScreenW - 80,(kScreenW - 80)/8)
        segment.tintColor = colorWithRex(0xFFFFFF,alphe: 0.85)

        return segment
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: privateFuction
    
    func setUpSubViews()
    {
        self.backgroundColor = UIColor(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.bounds, andColors: [colorWithRex(0xf3bb8a, alphe: 1),colorWithRex(0xf37aa7, alphe: 1)])
        self.addSubview(sgementControl)
        
        // drawSystemX.Y
        drawCoordinateLayerSystem()

    }
    
    func drawCoordinateLayerSystem()
    {
        let beizer = UIBezierPath()
        beizer.moveToPoint(CGPointMake(leftSpace, topSpace))
        beizer.addLineToPoint(CGPointMake(leftSpace, self.height - bottomSpace))
        beizer.addLineToPoint(CGPointMake(self.width - rightSpace, self.height - bottomSpace))
        let coordinateLayer = CAShapeLayer()
        coordinateLayer.path = beizer.CGPath
        coordinateLayer.strokeColor = UIColor.whiteColor().CGColor
        coordinateLayer.fillColor = UIColor.clearColor().CGColor
        coordinateLayer.lineWidth = 1
        self.layer.addSublayer(coordinateLayer)

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
