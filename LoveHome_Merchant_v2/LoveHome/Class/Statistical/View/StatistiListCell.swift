//
//  StatistiListCell.swift
//  LoveHome
//
//  Created by MRH-MAC on 15/11/16.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit

class StatistiListCell: UITableViewCell {

    @IBOutlet weak var backContentView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.contentView.layer.shadowOpacity = 0.7
        self.contentView.layer.shadowRadius = 2.0
        self.contentView.layer.shadowOffset = CGSizeMake(0, 8)
        
        //MARK -- 修复 ---- 阴影效果
//        self.contentView.layer.shadowPath = UIBezierPath(rect:self.contentView.bounds).CGPath
        
        self.selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
