//
//  YelpResaruantHours.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

class YelpRestaurantHoursInfo:Codable {
    var is_open_now:Bool?
    var hours_type:String?
    var open:[YelpResaruantBusinessTime]?
}
