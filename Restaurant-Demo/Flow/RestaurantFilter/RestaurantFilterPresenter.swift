//
//  RestaurantFilterPresenter.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class RestaurantFilterPresenter: RestaurantFilterPresenterProtocol {
    
    private var mModel:RestaurantFilterModel? = RestaurantFilterModel()
    private var mView:RestaurantFilterViewProtocol?
    
    // MARK:- RestaurantFilterPresenterProtocol
    func onViewDidLoad() {}
    
    func onViewDidAppear() {}
    
    func attachView(view: RestaurantFilterViewProtocol) {
        self.mView = view
    }
    
    func onApplyPressed(price:Int, openAt:Int, sortingRuleIndex:Int) {
        self.mModel?.setFilterConfig(price: price, openAt: openAt, sortingRuleIndex: sortingRuleIndex)
        self.mView?.doPerformSegue(withIdentifier: "press_apply_unwind_segue", sender: self.mModel?.getFilterConfig())
    }
    
    func onCancelPressed() {
        self.mView?.doPerformSegue(withIdentifier: "press_cancel_unwind_segue", sender: nil)
    }
    
}
