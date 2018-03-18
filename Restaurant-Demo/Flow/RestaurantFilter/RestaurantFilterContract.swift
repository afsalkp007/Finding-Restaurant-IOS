import Foundation
import UIKit

protocol RestaurantFilterPresenterProtocol{
    
    
    func onViewDidLoad()
    func onViewDidAppear()
    func attachView(view:RestaurantFilterViewProtocol)
    
    func onApplyPressed(price:Int, openAt:Int, sortingRuleIndex:Int)    
    func onCancelPressed()
    
//    func onInitParameters(summaryInfo:YelpRestaruantSummaryInfo?)
    
//    func onReviewItemSelect(reviewDetail:YelpReviewDetailInfo)
    
}

protocol RestaurantFilterViewProtocol{
//    func refreshBasicInfo(summaryInfo:YelpRestaruantSummaryInfo?, detailInfo:YelpRestaruantDetailInfo?)
//    func refreshReviewInfo(reviews:[YelpReviewDetailInfo]?)
//
//    func doPresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
//    func doDismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
//
    func refreshFilterConfig(config:FilterConfigs?)
    
    func doPerformSegue(withIdentifier identifier: String, sender: Any?)
//
//    func showLoading(loadingContent:String)
//    func closeLoading()
}

