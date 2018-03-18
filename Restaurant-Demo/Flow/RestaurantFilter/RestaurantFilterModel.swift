//
//  RestaurantFilterModel.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class RestaurantFilterModel {
    private var mFilterConfigs:FilterConfigs? = FilterConfigs()
    
    func setFilterConfig(config:FilterConfigs?) {
        self.mFilterConfigs = config
    }
    
    func setFilterConfig(price:Int, openAt:Int, sortingRuleIndex:Int) {
        self.mFilterConfigs?.mPrice = price
        self.mFilterConfigs?.mOpenAt = openAt
        self.mFilterConfigs?.mSortingRule = mapSortingRuleToStr(index:sortingRuleIndex)
    }
    
    func getFilterConfig() -> FilterConfigs? {
        return self.mFilterConfigs
    }
    
    private func mapSortingRuleToStr(index:Int) -> String {
        switch index {
        case 0:
            return FilterConfigs.SortingRuleAPIConstants.best_match.rawValue
        case 1:
            return FilterConfigs.SortingRuleAPIConstants.distance.rawValue
        case 2:
            return FilterConfigs.SortingRuleAPIConstants.rating.rawValue
        case 3:
            return FilterConfigs.SortingRuleAPIConstants.review_count.rawValue
        default:
            return FilterConfigs.SortingRuleAPIConstants.distance.rawValue
        }
    }
}
