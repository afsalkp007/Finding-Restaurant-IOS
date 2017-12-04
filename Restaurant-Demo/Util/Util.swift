//
//  Util.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

class Util {
    private static let sJsonDecoder:JSONDecoder = JSONDecoder()
    
    static func getJsonDecoder() -> JSONDecoder {
        return sJsonDecoder
    }
}
