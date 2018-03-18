//
//  RestaurantDetailPresenter.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/17.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import SafariServices


class RestaurantDetailPresenter: RestaurantDetailPresenterProtocol, ApiCallback {
    
    private static let API_TAG_BUSINESS = "API_TAG_BUSINESS"
    private static let API_TAG_REVIEWS = "API_TAG_REVIEWS"
    
    private var mModel:RestaurantDetailModel? = RestaurantDetailModel()
    private var mView:RestaurantDetailViewProtocol?
    
    private var mJsonDecoder:JSONDecoder?
    private var mSearchKeyword:String?
    private var mIsFirst = true
    private var mIsNeedReFetch = false
    
    func fetchData() {
        guard let summaryInfo = self.mModel?.getRestaurantSummaryInfo() else {
            return
        }
        
        // Coz id has chinese words, so I need to do Url-Encoding before calling API
        self.mView?.showLoading(loadingContent: NSLocalizedString("Loading Data...", comment: ""))
        YelpApiUtil.business(apiTag: RestaurantDetailPresenter.API_TAG_BUSINESS
            , id: (summaryInfo.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            , locale: YelpUtil.getPreferedLanguage()
            , callback: self)
    }
    
    // MARK:- ApiCallback
    func onError(apiTag: String, errorMsg: String) {
        self.mView?.closeLoading()
    }
    
    func onSuccess(apiTag: String, jsonData: Data?) {
        if apiTag == RestaurantDetailPresenter.API_TAG_BUSINESS {
            if let detailInfo = try?self.mJsonDecoder?.decode(YelpRestaruantDetailInfo.self, from: jsonData!) {
                self.mModel?.setRestaurantDetailInfo(detailInfo: detailInfo)                
                self.mView?.refreshBasicInfo(summaryInfo: self.mModel?.getRestaurantSummaryInfo(), detailInfo: self.mModel?.getRestaurantDetailInfo())
            }
            
            YelpApiUtil.reviews(apiTag: RestaurantDetailPresenter.API_TAG_REVIEWS
                , id: (self.mModel?.getRestaurantSummaryInfo()?.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                , locale: YelpUtil.getPreferedLanguage()
                , callback: self)
        } else if apiTag == RestaurantDetailPresenter.API_TAG_REVIEWS, let reviewInfo = try?self.mJsonDecoder?.decode(YelpReviewInfo.self, from: jsonData!) {
            self.mModel?.setRestaurantReviewInfo(reviewInfo: reviewInfo)
            self.mView?.refreshReviewInfo(reviews: self.mModel?.getRestaurantReviewDetailInfos())
            self.mView?.closeLoading()
        }
    }
    
    // MARK:- RestaurantDetailPresenterProtocol
    
    func attachView(view: RestaurantDetailViewProtocol) {
        self.mView = view
    }
    
    func onInitParameters(summaryInfo: YelpRestaruantSummaryInfo?) {
        self.mModel?.setRestaurantSummaryInfo(summaryInfo: summaryInfo)
    }
    
    func onViewDidLoad() {}
    
    func onViewDidAppear() {
        // Only the first time need to fetch data from API
        if self.mIsFirst {
            self.mIsFirst = false
            initConfig()
        } else if self.mIsNeedReFetch {
            self.mIsNeedReFetch = false
            fetchData()
        }
    }
    
    func initConfig() {
        self.mJsonDecoder = Util.getJsonDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        self.fetchData()
    }
    
    func onReviewItemSelect(reviewDetail: YelpReviewDetailInfo) {
        let safariController = SFSafariViewController(url: URL(string: (reviewDetail.url ?? ""))!)
        self.mView?.doPresent(safariController, animated: true, completion: nil)
    }
}
