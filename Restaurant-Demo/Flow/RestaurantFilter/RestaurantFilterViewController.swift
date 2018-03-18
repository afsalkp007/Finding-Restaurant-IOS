//
//  RestaurantFilterTableViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import UIKit

class RestaurantFilterViewController: UITableViewController, RestaurantFilterViewProtocol {
    
    @IBOutlet weak var mScPriceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mDpBusinessTimeDatePicker: UIDatePicker!
    @IBOutlet weak var mScSortRuleSegmentedControl: UISegmentedControl!
    
    private var mPresenter:RestaurantFilterPresenterProtocol?

    // MARK:- Life cyle & Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mPresenter = RestaurantFilterPresenter()
        self.mPresenter?.attachView(view: self)
        self.mPresenter?.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mPresenter?.onViewDidAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? RestaurantListViewController else {
            return
        }

        target.mFilterConfig = sender as? FilterConfigs
    }
    
    // MARK: - onApplyItemPressed
    @IBAction func onApplyItemPressed(_ sender: Any) {
        self.mPresenter?.onApplyPressed(price: self.mScPriceSegmentedControl.selectedSegmentIndex + 1, openAt: Int(self.mDpBusinessTimeDatePicker.date.timeIntervalSince1970), sortingRuleIndex: self.mScSortRuleSegmentedControl.selectedSegmentIndex)
    }
    
    // MARK: - onCancelItemPressed
    @IBAction func onCancelItemPressed(_ sender: Any) {
        self.mPresenter?.onCancelPressed()
    }
    
    // MARK:- RestaurantFilterViewProtocol
    func doPerformSegue(withIdentifier identifier: String, sender: Any?) {
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    func refreshFilterConfig(config: FilterConfigs?) {}

}
