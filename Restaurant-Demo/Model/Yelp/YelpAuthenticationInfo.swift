//
//  AuthenticationInfo.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/26.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

struct YelpAuthenticationInfo: Codable {
    var access_token:String?
    var expires_in:UInt64?
    var token_type:String?
}
