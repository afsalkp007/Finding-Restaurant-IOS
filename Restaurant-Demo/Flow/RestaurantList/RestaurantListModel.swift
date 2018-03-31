//
//  RestaurantListModel.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/1.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class RestaurantListModel: NSObject {
    
    private var mRestaurantSummaryInfos:[YelpRestaruantSummaryInfo]?
    private var mFilterConfig:FilterConfigs?
    
    override init() {
        self.mFilterConfig = FilterConfigs()
        self.mFilterConfig?.mSortingRule = FilterConfigs.SortingRuleAPIConstants.distance.rawValue
    }
    
    func setRestaurantSummaryInfos(summaryInfos:[YelpRestaruantSummaryInfo]?) {
        guard let infos = summaryInfos else {
            return
        }
        
        self.mRestaurantSummaryInfos = infos
    }
    
    func getRestaurantSummaryInfos(keyword:String?) -> [YelpRestaruantSummaryInfo]? {
        let newKeyword = keyword?.trimmingCharacters(in: .whitespaces)
        
        if newKeyword == nil || newKeyword?.count == 0 {
            return self.mRestaurantSummaryInfos
        } else {
            var filteredRestaurantSummaryInfos:[YelpRestaruantSummaryInfo]? = [YelpRestaruantSummaryInfo]()
            
            for info in self.mRestaurantSummaryInfos! {
                if (info.name?.contains(newKeyword!))! || (info.location?.display_address?.contains(newKeyword!))! ||
                    (info.categoriesStr?.contains(newKeyword!))! {
                    filteredRestaurantSummaryInfos?.append(info)
                }
            }
            return filteredRestaurantSummaryInfos
        }
    }
    
    func resetFilterConfigToDefault() {
        self.mFilterConfig?.mSortingRule = FilterConfigs.SortingRuleAPIConstants.distance.rawValue
        self.mFilterConfig?.mOpenAt = nil
        self.mFilterConfig?.mPrice = nil
    }
    
    func setFilterConfig(filterConfig:FilterConfigs?) {
        self.mFilterConfig = filterConfig
    }
    
    func getFilterConfig() -> FilterConfigs? {
        return self.mFilterConfig
    }
    
    func clearFilterConfig(filterType:TagType) {
        switch filterType {
        case .price:
            self.mFilterConfig?.mPrice = nil
        case .sorting_rule:
            self.mFilterConfig?.mSortingRule = nil
        case .open_at:
            self.mFilterConfig?.mOpenAt = nil
        }
    }
    
}
