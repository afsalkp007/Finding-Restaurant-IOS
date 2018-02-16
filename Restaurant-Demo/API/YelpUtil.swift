//
//  YelpUtil.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/1/3.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class YelpUtil {
    static func getPreferedLanguage() -> String {
        let firstPreferedLang = Bundle.main.preferredLocalizations.first ?? ""
        
        switch firstPreferedLang {
        case "zh-Hant-TW", "zh-Hant", "zh-Hant-US":
            return "zh_TW"
        default:
            return "en_US"
        }
    }
    
    static func getWeekDayStrByIndex(index:Int) -> String {
        switch index {
        case 0:
            return NSLocalizedString("Ｍonday", comment: "")
        case 1:
            return NSLocalizedString("Tuesday", comment: "")
        case 2:
            return NSLocalizedString("Wednesday", comment: "")
        case 3:
            return NSLocalizedString("Thursday", comment: "")
        case 4:
            return NSLocalizedString("Friday", comment: "")
        case 5:
            return NSLocalizedString("Saturday", comment: "")
        case 6:
            return NSLocalizedString("Sunday", comment: "")
        default:
            return ""
        }
    }
    
    static func isNowWeekDayFromYelpIndex(index:Int, yelpIndex:Int) -> Bool {
        if index == 1, yelpIndex == 6 {
            return true
        }
        return (index - 2) == yelpIndex
    }
}
