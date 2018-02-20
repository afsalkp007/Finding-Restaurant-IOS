//
//  YelpReviewInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/1/30.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class YelpReviewInfo: YelpBaseInfo, Codable {
    var total:Int?
    var possible_languages:[String]?
    var reviews:[YelpReviewDetailInfo]?
    
}
