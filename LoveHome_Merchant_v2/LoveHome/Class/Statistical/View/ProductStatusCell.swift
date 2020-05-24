//
//  ProductStatusCell.swift
//  LoveHome
//
//  Created by MRH on 15/11/30.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit

let cellIdentifer : String = "ProductStatusCellIndentifer"

class ProductStatusCell: UITableViewCell {

    @IBOutlet weak var numberCount: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var proImageView: UIImageView!
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var productIdLable: UILabel!
    @IBOutlet weak var shaowView: UIView!


    

    var product : ShopStatisModel!{
        didSet
        {
          configInterfaceWithProdcut()

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.shaowView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.shaowView.layer.shadowOpacity = 0.7
        self.shaowView.layer.shadowRadius = 2.0
        self.shaowView.layer.shadowOffset = CGSizeMake(0, 8)
    //MARK - 修复-统计-访客数量-商品统计 里面阴影显示不全的情况
//        self.shaowView.layer.shadowPath = UIBezierPath(rect:self.contentView.bounds).CGPath

    }
    
    private func configInterfaceWithProdcut ()
    {
        ImageTool.downloadImage(String(product.url), placeholder: nil, imageView: proImageView)
        let url = String(format: "statistical_ranking_%ld", arguments: [product.rankNu])
        rankImageView.image = UIImage(named:url)
        priceLable.text = String(format: "￥%@", arguments: [product.price!])
        productName.text = product.productName! as String
        productIdLable.text = String(format: "%@件", arguments: [product.sales])
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
