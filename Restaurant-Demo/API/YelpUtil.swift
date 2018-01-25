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
}
