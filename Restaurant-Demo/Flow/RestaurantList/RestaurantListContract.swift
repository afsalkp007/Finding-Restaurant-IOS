//
//  RestaurantListContract.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/1.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import UIKit

protocol RestaurantListPresenterProtocol {
    func onLocationFloatItemClick()
    func onFilterFloatItemClick()
    
    func onFilterTagTap(tagType:TagType)
    
    func onRestaurantListItemSelect(summaryInfo:YelpRestaruantSummaryInfo?)
    
    func onSearchKeyworkChange(keyword:String?)
    
    func onEndRefreshToDefaultConfigs()
    
    func onNewFilterConfigsApply(filterConfigs:FilterConfigs?)
    
    func onViewDidLoad()
    func onViewDidAppear()
    func attachView(view:RestaurantListViewProtocol)

}

protocol RestaurantListViewProtocol {
    func refreshList(restaurantSummaryInfos:[YelpRestaruantSummaryInfo]?)
    func refreshFilterTagList(filterConfigs:FilterConfigs?)
    
    func doPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func doDismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
    
    func doPerformSegue(withIdentifier identifier: String, sender: Any?)
    
    func showAlertDialog(title:String, content:String, handler:((UIAlertAction) -> Swift.Void)?)
    
    func showLoading(loadingContent:String)
    func closeLoading()
    
}


enum TagType {
    case sorting_rule
    case open_at
    case price
}
