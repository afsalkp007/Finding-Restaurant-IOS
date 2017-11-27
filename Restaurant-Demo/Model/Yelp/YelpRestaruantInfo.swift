//
//  YelpRestaruantInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/26.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

struct YelpRestaruantInfo: Codable {
    var name:String?
    var image_url:String?
    var review_count:Int?
    var rating_img_url_large:String?
    var rating:Double?
    var price:String?
    var phone:String?
    var distance:Double?
    var categories:[YelpRestaurantCategory]?
    var location:YelpRestaurantLocation?
    var coordinates:YelpRestaurantCoordinates?
}
