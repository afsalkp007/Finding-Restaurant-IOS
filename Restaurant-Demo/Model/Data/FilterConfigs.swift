//
//  FilterConfigs.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/10.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

class FilterConfigs {
    var mPrice:Int?
    var mPriceStr:String? {
        if let price = mPrice {
            switch price {
            case 1:
                return "$"
            case 2:
                return "$$"
            case 3:
                return "$$$"
            case 4:
                return "$$$$"
            default:
                return nil
            }
        }
        return nil
    }
    var mOpenAt:Int?
    var mSortingRule:String?
}
