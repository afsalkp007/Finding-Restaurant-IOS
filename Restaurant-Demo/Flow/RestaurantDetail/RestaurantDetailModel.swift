//
//  RestaurantDetailModel.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/17.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class RestaurantDetailModel {
    var mRestaurantSummaryInfo:YelpRestaruantSummaryInfo?
    var mRestaurantDetailInfo:YelpRestaruantDetailInfo?
    var mRestaurantReviewInfo:YelpReviewInfo?
    
    func setRestaurantSummaryInfo(summaryInfo:YelpRestaruantSummaryInfo?) {
        self.mRestaurantSummaryInfo = summaryInfo
    }
    
    func getRestaurantSummaryInfo() -> YelpRestaruantSummaryInfo? {
        return self.mRestaurantSummaryInfo
    }
    
    func setRestaurantDetailInfo(detailInfo:YelpRestaruantDetailInfo?) {
        self.mRestaurantDetailInfo = detailInfo
    }
    
    func getRestaurantDetailInfo() -> YelpRestaruantDetailInfo? {
        return self.mRestaurantDetailInfo
    }
    
    func setRestaurantReviewInfo(reviewInfo:YelpReviewInfo?) {
        self.mRestaurantReviewInfo = reviewInfo
    }
    
//    func getRestaurantReviewInfo() -> YelpReviewInfo? {
//        return self.mRestaurantReviewInfo
//    }
    
    func getRestaurantReviewDetailInfos() -> [YelpReviewDetailInfo]? {
        return self.mRestaurantReviewInfo?.reviews
    }
}
