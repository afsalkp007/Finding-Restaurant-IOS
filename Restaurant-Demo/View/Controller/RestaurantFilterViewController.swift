//
//  RestaurantFilterViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/10.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit

class RestaurantFilterViewController: UITableViewController {
    
    @IBOutlet weak var mScPriceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mDpBusinessTimeDatePicker: UIDatePicker!
    @IBOutlet weak var mScSortRuleSegmentedControl: UISegmentedControl!
    
    var mFilterConfigs:FilterConfigs?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfig()
    }
    
    func initConfig() {
        self.mFilterConfigs = FilterConfigs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? RestaurantListViewController else {
            return
        }
        
        let segueIdentifier = segue.identifier
        target.mFilterConfig = (segueIdentifier == "press_apply_unwind_segue") ? self.mFilterConfigs : nil
    }
    
    // MARK: - onApplyItemPressed
    @IBAction func onApplyItemPressed(_ sender: Any) {
        self.mFilterConfigs?.mPrice = self.mScPriceSegmentedControl.selectedSegmentIndex + 1
        self.mFilterConfigs?.mOpenAt = Int(self.mDpBusinessTimeDatePicker.date.timeIntervalSince1970)
        self.mFilterConfigs?.mSortingRule = mapSortingRuleToStr(index: self.mScSortRuleSegmentedControl.selectedSegmentIndex)
        performSegue(withIdentifier: "press_apply_unwind_segue", sender: nil)
    }
    
    func mapSortingRuleToStr(index:Int) -> String {
        switch index {
        case 0:
            return FilterConfigs.SortingRuleAPIConstants.best_match.rawValue
        case 1:
            return FilterConfigs.SortingRuleAPIConstants.distance.rawValue
        case 2:
            return FilterConfigs.SortingRuleAPIConstants.rating.rawValue
        case 3:
            return FilterConfigs.SortingRuleAPIConstants.review_count.rawValue
        default:
            return FilterConfigs.SortingRuleAPIConstants.distance.rawValue
        }
    }
    
    // MARK: - onCancelItemPressed
    @IBAction func onCancelItemPressed(_ sender: Any) {
        performSegue(withIdentifier: "press_cancel_unwind_segue", sender: nil)
    }
}
