//
//  RestaurantDetailViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/27.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UITableViewController {
    
    @IBOutlet weak var mIvMainPhotoImageView: UIImageView!
    @IBOutlet weak var mIvStreetImageView: UIImageView!
    @IBOutlet weak var mLbAddressLabel: UILabel!
    @IBOutlet weak var mLbPhoneLabel: UILabel!
    @IBOutlet weak var mLbTypeLabel: UILabel!
    @IBOutlet weak var mLbRatingLabel: UILabel!
    @IBOutlet weak var mLbPriceLabel: UILabel!
    @IBOutlet weak var mLbReviews: UILabel!
    @IBOutlet weak var mLbIsOpenStatusLabel: UILabel!
    @IBOutlet var mIvSubPhotos: [UIImageView]!
    
    var mRestaurantInfo:YelpRestaruantInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        fetchData()
    }
    
    func initView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = mRestaurantInfo?.name ?? ""
    }
    
    func fetchData() {
        if mRestaurantInfo == nil {
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
