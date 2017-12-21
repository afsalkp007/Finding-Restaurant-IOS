//
//  YelpApi.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import Alamofire

class YelpApiUtil {
    
    private static let sJsonDecoder:JSONDecoder = Util.getJsonDecoder()
    private static var sHeaders: HTTPHeaders?
    
    // MARK: - requestToken
    static func requestToken(apiTag:String, callback:ApiCallback?) {
        
        let parameters: Parameters = ["grant_type": YelpApiConfigs.OAUTH_GRANT_TYPYE
            , "client_id":YelpApiConfigs.CLIENT_ID
            , "client_secret":YelpApiConfigs.CLIENT_SECRET]
        let completionHandler = {
            (response:DataResponse<Any>) in
            if response.error == nil, let authenticationInfo = try? sJsonDecoder.decode(YelpAuthenticationInfo.self, from: response.data!) {
                sHeaders = [
                    "Authorization": "Bearer \(authenticationInfo.access_token ?? "")",
                    "Accept": "application/json"
                ]
                if callback != nil {
                    callback?.onSuccess(apiTag: apiTag, jsonData: response.data)
                }
                
            } else if callback != nil, response.error != nil {
                callback?.onError(apiTag: apiTag, errorMsg: (response.error?.localizedDescription)!)
            }
        }
        
        apiRequest(apiTag: apiTag, url: YelpApiConfigs.TOKEN_API_URL, method: .post, parameters:parameters, completionHandler:completionHandler)
    }
    
    // MARK: - businessSearch
    static func businessSearch(apiTag:String, term:String, lat:Double, lng:Double, locale:String, openAt:Int? = nil, sortBy:String? = nil, price:Int? = nil, callback:ApiCallback) {
        
        var parameters: Parameters = ["term":term, "latitude":lat, "longitude":lng, "locale":locale, "limit":50]
        
        if let openAt = openAt {
            parameters.updateValue(openAt, forKey: "open_at")
        }
        if let sortBy = sortBy {
            parameters.updateValue(sortBy, forKey: "sort_by")
        }
        if let price = price {
            parameters.updateValue(price, forKey: "price")
        }
        
        apiRequest(apiTag: apiTag, url: YelpApiConfigs.BUSINESS_SEARCH_API_URL, callback: callback, headers: sHeaders, method: .get, parameters:parameters)
    }
    
    // MARK: - business
    static func business(apiTag:String, id:String, locale:String, callback:ApiCallback) {
        let parameters: Parameters = ["locale":locale]
        
        apiRequest(apiTag: apiTag, url: YelpApiConfigs.BUSINESS + id, callback: callback, headers: sHeaders, method: .get, parameters:parameters)
    }
    
    // MARK: - Common
    private static func apiRequest(apiTag:String, url:String, callback:ApiCallback? = nil, headers: HTTPHeaders? = nil, method: HTTPMethod, parameters:Parameters? = nil, completionHandler:((DataResponse<Any>) -> Void)? = nil) {
        
        if completionHandler == nil {
            Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON {
                (response) in
                if response.error == nil, callback != nil {
                    callback?.onSuccess(apiTag: apiTag, jsonData: response.data)
                } else if callback != nil  {
                    callback?.onError(apiTag: apiTag, errorMsg: response.error.debugDescription)
                }
            }
        } else {
            Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON(completionHandler: completionHandler!)
        }
    }
}
