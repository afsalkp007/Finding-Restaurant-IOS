//
//  ApiConfigs.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/26.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation

class YelpApiConfigs {
    static let OAUTH_GRANT_TYPYE = "client_credentials"
    static let CLIENT_ID = "uy1lqpYWe0DVZaTM2wcsCw"
    static let CLIENT_SECRET = "9KsAARABl3Rey3kM7anF9hHfCGzD802Rk7CVqUICQPwNLFrLnOPiRCXWdhKHGZhD"
    static let AUTH_TOKEN = "4htbz9nLozJ_-Xw-13LpeVWrEIRWZt4IrgTOQXstx7M1DCVeUIoxIZkQ0XVLVEtD2Gy2Vp1FjA2WRz5DOpZMSxHfXVBLR3gi0DeMXIV3X1bCHYoMoJ-_TZLfBn0ZWnYx"
    
    static let SERVER_URL = "https://api.yelp.com/"
    static let TOKEN_API_URL = YelpApiConfigs.SERVER_URL + "oauth2/token"
    static let BUSINESS_SEARCH_API_URL =  YelpApiConfigs.SERVER_URL + "v3/businesses/search"
    static let BUSINESS = YelpApiConfigs.SERVER_URL + "v3/businesses/"
    static let REVIEWS = YelpApiConfigs.SERVER_URL + "v3/businesses/%@/reviews"
}
