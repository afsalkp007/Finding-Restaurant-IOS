//
//  YelpLocationInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/26.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

class YelpRestaurantLocation:Codable {
    var address1:String?
    var address2:String?
    var address3:String?
    var city:String?
    var country:String?
    var state:String?
    var display_address:[String]?
}
