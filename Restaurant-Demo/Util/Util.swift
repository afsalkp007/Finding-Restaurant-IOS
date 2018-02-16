//
//  Util.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import UIKit

class Util {
    private static let sJsonDecoder:JSONDecoder = JSONDecoder()
    
    static func getJsonDecoder() -> JSONDecoder {
        return sJsonDecoder
    }
    
    static func openUrl(url:URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func getNowWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: Date())
    }
}
