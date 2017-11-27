//
//  YelpRestaurantDetailInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/27.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

struct YelpRestaruantDetailInfo: Codable {
    var name:String?
    var image_url:String?
    var is_closed:Bool?
    var review_count:Int?
    var rating:Double?
    var price:String?
    var phone:String?
    var categories:[YelpRestaurantCategory]?
    var location:YelpRestaurantLocation?
    var coordinates:YelpRestaurantCoordinates?
    var photos:[String]?
}
