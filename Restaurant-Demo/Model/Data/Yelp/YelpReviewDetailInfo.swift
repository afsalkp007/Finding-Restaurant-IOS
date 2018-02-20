//
//  YelpReviewerInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/1/30.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class YelpReviewDetailInfo:YelpBaseInfo ,Codable {
    var id:String?
    var rating:Int?
    var user:YelpReviewerInfo?
    var text:String?
    var time_created:String?
    var url:String?
}
