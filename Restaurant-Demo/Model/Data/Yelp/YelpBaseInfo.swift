//
//  YelpBaseRestaurantInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/29.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import UIKit

class YelpBaseInfo {
    
    private static var sRatingImgMap:NSMutableDictionary?;
    
    init() {
        if YelpBaseInfo.sRatingImgMap == nil {
            YelpBaseInfo.sRatingImgMap = NSMutableDictionary()
                    
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_0_of_5"), forKey:"0.0")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_0.5_of_5"), forKey:"0.5")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_1_of_5"), forKey:"1.0")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_1.5_of_5"), forKey:"1.5")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_2_of_5"), forKey:"2.0")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_1.5_of_5"), forKey:"2.5")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_3_of_5"), forKey:"3.0")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_3.5_of_5"), forKey:"3.5")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_4_of_5_"), forKey:"4.0")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_4.5_of_5"), forKey:"4.5")
            YelpBaseInfo.sRatingImgMap?.setValue(#imageLiteral(resourceName: "Star_rating_5_of_5"), forKey:"5.0")
        }
       
    }
    
    
    static func getRatingImage(rating:Double) -> UIImage? {
        return YelpBaseInfo.sRatingImgMap?.value(forKey: String(rating)) as? UIImage
    }
}
