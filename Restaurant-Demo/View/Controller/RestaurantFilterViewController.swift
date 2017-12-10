//
//  RestaurantFilterViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/10.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit

class RestaurantFilterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(#function)")
    }
    
    
    // MARK: - onCancelItemPressed
    @IBAction func onCancelItemPressed(_ sender: Any) {
        performSegue(withIdentifier: "press_cancel_unwind_segue", sender: nil)
    }
    
    // MARK: - onApplyItemPressed
    @IBAction func onApplyItemPressed(_ sender: Any) {
        performSegue(withIdentifier: "press_apply_unwind_segue", sender: nil)
    }
}
