//
//  RestaurantDetailViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/27.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

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
    
    private var mJsonDecoder:JSONDecoder?
    private var mLoadingAlertController:UIAlertController?
    var mAuthenticationInfo:YelpAuthenticationInfo?
    var mRestaurantSummaryInfo:YelpRestaruantSummaryInfo?
    var mRestaurantDetailInfo:YelpRestaruantDetailInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mJsonDecoder = JSONDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    func initView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = mRestaurantSummaryInfo?.name ?? ""
    }
    
    func fetchData() {
        if mRestaurantSummaryInfo == nil {
            return
        }
        
        // Coz id has chinese words, so I need to do Url-Encoding before calling API
        let id = ((self.mRestaurantSummaryInfo?.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        let parameters:Parameters = ["locale":"zh_TW"]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.mAuthenticationInfo?.access_token ?? "")",
            "Accept": "application/json"
        ]
        showLoadingDialog(loadingContent: "Loading Data...")
        Alamofire.request("https://api.yelp.com/v3/businesses/\(id)", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            if response.error == nil, let detailInfo = try?self.mJsonDecoder?.decode(YelpRestaruantDetailInfo.self, from: response.data!) {
                self.mRestaurantDetailInfo = detailInfo
                self.updateView()
            } else {
                print("Error = \(response.error.debugDescription), or mRestaurantDetailInfo = nil")
            }
            self.closeLoadingDialog()
        }
    }
    
    func updateView() {
        if self.mRestaurantDetailInfo == nil {
            return;
        }
        
        self.mIvMainPhotoImageView.kf.setImage(with: URL(string: (self.mRestaurantDetailInfo?.image_url)!))
        //mIvStreetImageView: UIImageView!
        self.mLbAddressLabel.text = self.mRestaurantDetailInfo?.location?.display_address?.joined()
        self.mLbPhoneLabel.text = self.mRestaurantDetailInfo?.phone
        
        var categoriyTitles:[String] = [String]()
        for categoryInfo in (self.mRestaurantSummaryInfo?.categories)! {
            categoriyTitles.append(categoryInfo.title ?? "")
        }
        self.mLbTypeLabel.text = categoriyTitles.joined(separator: ",")
        self.mLbRatingLabel.text = "\(self.mRestaurantDetailInfo?.rating ?? 0) starts"
        self.mLbPriceLabel.text = self.mRestaurantDetailInfo?.price ?? ""
        self.mLbReviews.text = "\(self.mRestaurantDetailInfo?.review_count ?? 0) reviews"
        self.mLbIsOpenStatusLabel.text = (self.mRestaurantDetailInfo?.is_closed)! ? "CLOSE" : "OPEN"
        
        for i in stride(from: 0, to: (self.mRestaurantDetailInfo?.photos?.count)!, by: 1) where i < self.mIvSubPhotos.count {
            self.mIvSubPhotos[i].kf.setImage(with: URL(string: (self.mRestaurantDetailInfo?.photos![i])!))
        }
    }
    
    func showLoadingDialog(loadingContent:String) {
        self.mLoadingAlertController = UIAlertController(title: nil, message: loadingContent, preferredStyle: .alert)
        self.mLoadingAlertController?.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10,y:5, width:50, height:50))
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        self.mLoadingAlertController?.view.addSubview(loadingIndicator)
        self.present(self.mLoadingAlertController!, animated: true, completion: nil)
    }
    
    func closeLoadingDialog() {
        if self.mLoadingAlertController != nil {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            self.mLoadingAlertController = nil
        }
    }
    
}
