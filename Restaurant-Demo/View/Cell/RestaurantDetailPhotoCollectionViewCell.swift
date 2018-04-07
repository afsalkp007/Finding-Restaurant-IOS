//
//  RestaurantDetailPhotoCollectionViewCell.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/4/2.
//  Copyright © 2018年 yomi. All rights reserved.
//

import UIKit

class RestaurantDetailPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mRestaurantDetailPhotoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setPhotoUrl(url:String?) {
        self.mRestaurantDetailPhotoImageView.kf.setImage(with: URL(string: url ?? ""), placeholder:  #imageLiteral(resourceName: "no_image"))
    }

}
