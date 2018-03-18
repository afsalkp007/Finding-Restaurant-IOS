//
//  RestaurantDetailContract.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/17.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import UIKit

protocol RestaurantDetailPresenterProtocol{
    func onReviewItemSelect(reviewDetail:YelpReviewDetailInfo)
    
    func onViewDidLoad()
    func onViewDidAppear()
    func attachView(view:RestaurantDetailViewProtocol)
    
    func onInitParameters(summaryInfo:YelpRestaruantSummaryInfo?)
}

protocol RestaurantDetailViewProtocol{
    func refreshBasicInfo(summaryInfo:YelpRestaruantSummaryInfo?, detailInfo:YelpRestaruantDetailInfo?)
    func refreshReviewInfo(reviews:[YelpReviewDetailInfo]?)
    
    func doPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func doDismiss(animated flag: Bool, completion: (() -> Swift.Void)?)

    func doPerformSegue(withIdentifier identifier: String, sender: Any?)
    
    func showLoading(loadingContent:String)
    func closeLoading()
}


