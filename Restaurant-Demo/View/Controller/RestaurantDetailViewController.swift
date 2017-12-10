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

class RestaurantDetailViewController: UITableViewController, ApiCallback {
    
    private static let API_TAG_BUSINESS = "API_TAG_BUSINESS"
    
    @IBOutlet weak var mIvMainPhotoImageView: UIImageView!
    @IBOutlet weak var mIvStaticMapImageView: UIImageView!
    @IBOutlet weak var mLbAddressLabel: UILabel!
    @IBOutlet weak var mBtnPhoneButton: UIButton!
    @IBOutlet weak var mLbTypeLabel: UILabel!
    @IBOutlet weak var mLbPriceLabel: UILabel!
    @IBOutlet weak var mLbReviews: UILabel!
    @IBOutlet weak var mLbIsOpenStatusLabel: UILabel!
    @IBOutlet var mIvSubPhotos: [UIImageView]!
    @IBOutlet weak var mIvRatingImage: UIImageView!
    
    private var mJsonDecoder:JSONDecoder?
    private var mLoadingAlertController:UIAlertController?
    var mRestaurantSummaryInfo:YelpRestaruantSummaryInfo?
    var mRestaurantDetailInfo:YelpRestaruantDetailInfo?
    private var mIsFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.mIsFirst {
            self.mIsFirst = false
            fetchData()
        }
    }
    
    func initView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = self.mRestaurantSummaryInfo?.name ?? ""
        let lat = self.mRestaurantSummaryInfo?.coordinates?.latitude
        let lng = self.mRestaurantSummaryInfo?.coordinates?.longitude
        
        self.mIvStaticMapImageView.kf.setImage(with: URL(string: GoogleApiUtil.createStaticMapUrl(lat: lat!, lng: lng!, w: 200, h: 200)), placeholder:  #imageLiteral(resourceName: "no_image"))
    }
    
    func initConfig() {
        self.mJsonDecoder = Util.getJsonDecoder()
    }
    
    func fetchData() {
        if mRestaurantSummaryInfo == nil {
            return
        }
        
        let id = ((self.mRestaurantSummaryInfo?.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        // Coz id has chinese words, so I need to do Url-Encoding before calling API
        showLoadingDialog(loadingContent: "Loading Data...")
        YelpApiUtil.business(apiTag: RestaurantDetailViewController.API_TAG_BUSINESS, id: id, locale: "zh_TW", callback: self)
    }
    
    func updateView() {
        if self.mRestaurantDetailInfo == nil {
            return;
        }
        
        self.mIvMainPhotoImageView.kf.setImage(with: URL(string: (self.mRestaurantDetailInfo?.image_url)!), placeholder: #imageLiteral(resourceName: "no_image"))
        //mIvStreetImageView: UIImageView!
        self.mLbAddressLabel.text = self.mRestaurantDetailInfo?.location?.display_address?.joined()
    self.mBtnPhoneButton.setTitle(self.mRestaurantDetailInfo?.phone, for: .normal)
        
        var categoriyTitles:[String] = [String]()
        for categoryInfo in (self.mRestaurantSummaryInfo?.categories)! {
            categoriyTitles.append(categoryInfo.title ?? "")
        }
        self.mLbTypeLabel.text = categoriyTitles.joined(separator: ",")
        self.mIvRatingImage.image = self.mRestaurantDetailInfo?.getRatingImage(rating: self.mRestaurantDetailInfo?.rating ?? 0.0)
        self.mLbPriceLabel.text = self.mRestaurantDetailInfo?.price ?? ""
        self.mLbReviews.text = "\(self.mRestaurantDetailInfo?.review_count ?? 0) 評論"
        
        self.mLbIsOpenStatusLabel.text = "N/A"
        if let hours = self.mRestaurantDetailInfo?.hours, let isOpenNow = hours[0].is_open_now {
            self.mLbIsOpenStatusLabel.text = (isOpenNow) ? "OPEN" : "CLOSE"
        }
        
        for i in stride(from: 0, to: (self.mRestaurantDetailInfo?.photos?.count)!, by: 1) where i < self.mIvSubPhotos.count {
            self.mIvSubPhotos[i].kf.setImage(with: URL(string: (self.mRestaurantDetailInfo?.photos![i])!), placeholder: #imageLiteral(resourceName: "no_image"))
        }
    }
    
    // MARK: - onStaticMapPressed
    @IBAction func onStaticMapPressed(_ sender: Any) {
        let lat = self.mRestaurantSummaryInfo?.coordinates?.latitude
        let lng = self.mRestaurantSummaryInfo?.coordinates?.longitude
        let alertController = UIAlertController(title: "Select a action", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let navigationAction = UIAlertAction(title: "Navigation", style: .default) { (action) in
            let url = URL(string: String(format:"http://maps.apple.com/?daddr=%f,%f&dirflg=d", lat!, lng!))
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
        let streetViewAction = UIAlertAction(title: "Street View", style: .default) { (action) in
            let panormaViewController = PanoramaViewController()
            panormaViewController.mLat = lat!
            panormaViewController.mLng = lng!
            self.navigationController?.pushViewController(panormaViewController, animated: true)
        }
        alertController.addAction(navigationAction)
        alertController.addAction(streetViewAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - onPhoneButtonPressed
    @IBAction func onPhoneButtonPressed(_ sender: Any) {
        let rawPhoneNum = self.mBtnPhoneButton.titleLabel?.text ?? ""
        let phoneNum = rawPhoneNum.replacingOccurrences(of: "+", with: "")
        let url = URL(string: "tel://\(phoneNum)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!)
        } else {
            UIApplication.shared.openURL(url!)
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
            self.dismiss(animated: true, completion: nil)
            self.mLoadingAlertController = nil
        }
    }
    
    // MARK: - API Callback
    
    func onError(apiTag: String, errorMsg: String) {
        closeLoadingDialog()
    }
    
    func onSuccess(apiTag: String, jsonData: Data?) {
        if apiTag == RestaurantDetailViewController.API_TAG_BUSINESS {
            if let detailInfo = try?self.mJsonDecoder?.decode(YelpRestaruantDetailInfo.self, from: jsonData!) {
                self.mRestaurantDetailInfo = detailInfo
                self.updateView()
            }
        }
        closeLoadingDialog()
    }    
}
