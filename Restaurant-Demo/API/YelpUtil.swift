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
        let firstPreferedLang = Locale.preferredLanguages.first ?? ""
        
        switch firstPreferedLang {
        case "zh-Hant-TW":
            return "zh_TW"
        default:
            return "en_US"
        }
    }
}
