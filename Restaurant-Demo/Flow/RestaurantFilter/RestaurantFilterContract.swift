import Foundation
import UIKit

protocol RestaurantFilterPresenterProtocol{
    
    func onViewDidLoad()
    func onViewDidAppear()
    func attachView(view:RestaurantFilterViewProtocol)
    
    func onApplyPressed(price:Int, openAt:Int, sortingRuleIndex:Int)    
    func onCancelPressed()
    
}

protocol RestaurantFilterViewProtocol{
    
    func refreshFilterConfig(config:FilterConfigs?)
    
    func doPerformSegue(withIdentifier identifier: String, sender: Any?)
}

