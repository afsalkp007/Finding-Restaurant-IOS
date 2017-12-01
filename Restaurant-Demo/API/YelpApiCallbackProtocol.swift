//
//  YelpApiCallbackProtocol.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

protocol ApiCallback {
    func onError(apiTag:String, errorMsg:String)
    func onSuccess(apiTag:String, jsonData:Data?)
}
