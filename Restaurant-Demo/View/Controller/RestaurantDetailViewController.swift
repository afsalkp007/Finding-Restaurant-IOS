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
    private static let API_TAG_REVIEWS = "API_TAG_REVIEWStrGFD"
    
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
    @IBOutlet var mTcReviewCellItems: [UITableViewCell]!
    
    
    private var mJsonDecoder:JSONDecoder?
    private var mLoadingAlertController:UIAlertController?
    private var mIsFirst = true
    private var mReviewInfo:YelpReviewInfo? = nil
    var mRestaurantSummaryInfo:YelpRestaruantSummaryInfo?
    var mRestaurantDetailInfo:YelpRestaruantDetailInfo?
    
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
        
        // Coz id has chinese words, so I need to do Url-Encoding before calling API
        showLoadingDialog(loadingContent: NSLocalizedString("Loading Data...", comment: ""))
        YelpApiUtil.business(apiTag: RestaurantDetailViewController.API_TAG_BUSINESS
            , id: (self.mRestaurantSummaryInfo?.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            , locale: YelpUtil.getPreferedLanguage()
            , callback: self)
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
        self.mLbReviews.text = "\(self.mRestaurantDetailInfo?.review_count ?? 0) " + NSLocalizedString("Reviews", comment: "");
        
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
        let alertController = UIAlertController(title: NSLocalizedString("Select a action", comment: ""), message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let navigationAction = UIAlertAction(title: NSLocalizedString("Navigation", comment: ""), style: .default) { (action) in
            let url = URL(string: String(format:"http://maps.apple.com/?daddr=%f,%f&dirflg=d", lat!, lng!))
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
        let streetViewAction = UIAlertAction(title: NSLocalizedString("Street View", comment: ""), style: .default) { (action) in
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
            YelpApiUtil.reviews(apiTag: RestaurantDetailViewController.API_TAG_REVIEWS
                , id: (self.mRestaurantSummaryInfo?.id)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                , locale: YelpUtil.getPreferedLanguage()
                , callback: self)
        } else if apiTag == RestaurantDetailViewController.API_TAG_REVIEWS, let reviewsInfo = try?self.mJsonDecoder?.decode(YelpReviewInfo.self, from: jsonData!) {
            let reviewsCount = reviewsInfo?.reviews?.count ?? 0
            self.mReviewInfo = reviewsInfo
            
            for i in 0..<reviewsCount {
                if let review = reviewsInfo?.reviews![i], let user = review.user {
                    let reviewCellItem = self.mTcReviewCellItems[i]
                    if i == 0 {
                        //assign a title for Reviews Section
                        (reviewCellItem.viewWithTag(5) as? UILabel)?.text = NSLocalizedString("Review", comment: "")
                    }
                    (reviewCellItem.viewWithTag(2) as? UILabel)?.text = user.name
                    (reviewCellItem.viewWithTag(4) as? UILabel)?.text = review.text
                    (reviewCellItem.viewWithTag(1) as? UIImageView)?.kf.setImage(with: URL(string: (user.image_url)!))
                    (reviewCellItem.viewWithTag(3) as? UIImageView)?.image = review.getRatingImage(rating: Double.init(review.rating!))
                }
            }
            
            // Hide the remain TableViewCellItems without data
            for i in reviewsCount..<self.mTcReviewCellItems.count {
                self.mTcReviewCellItems[i].isHidden = true
                self.tableView.contentSize.height -= self.mTcReviewCellItems[i].frame.size.height
            }
            self.tableView.contentSize.height += 30
            
            self.closeLoadingDialog()
        }
    }
 }
