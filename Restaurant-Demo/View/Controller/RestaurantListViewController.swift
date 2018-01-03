//
//  MenuTableViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/25.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit
import Kingfisher
import GooglePlaces
import GooglePlacePicker
import TagListView
import Crashlytics
import FirebaseCrash

class RestaurantListViewController: UITableViewController, UISearchResultsUpdating, ApiCallback, GMSPlacePickerViewControllerDelegate, LocationStatusDelegate, TagListViewDelegate {
    
    private static let API_TAG_REQUEST_TOKEN = "API_TAG_REQUEST_TOKEN"
    private static let API_TAG_BUSINESS_SEARCH = "API_TAG_BUSINESS_SEARCH"
    private static let CELL_ID = "menu_cell"
    
    @IBOutlet weak var mVFilterRuleListContainerView: UIView!
    @IBOutlet weak var mTlvFilterRuleTagList: TagListView!
    
    private var mScNameSearchController:UISearchController?
    private var mRcRefreshControl:UIRefreshControl?
    private var mFilteredRetaruantInfos:[YelpRestaruantSummaryInfo]? = nil
    private var mAllRestaruantInfos:[YelpRestaruantSummaryInfo]? = [YelpRestaruantSummaryInfo]()
    private var mJsonDecoder:JSONDecoder?
    private var mSearchInfo:YelpSearchInfo?
    private var mLoadingAlertController:UIAlertController?
    private var mIsFirst = true
    private var mIsNeedReFetch = false
    var mFilterConfig:FilterConfigs?
    var mCurLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Only the first time need to fetch data from API
        if self.mIsFirst {
            self.mIsFirst = false
            initConfig()
        } else if self.mIsNeedReFetch {
            self.mIsNeedReFetch = false
            
            updateRestaruantList()
        }
    }
    
    func initView() {
        /* Init NavigationController  */
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        /* Init TableView  */
        self.mRcRefreshControl = UIRefreshControl()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 30
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.mRcRefreshControl
        } else {
            self.tableView.addSubview(self.mRcRefreshControl!)
        }
        self.mRcRefreshControl?.addTarget(self, action: #selector(refreshListToDefaultConfigs), for:.valueChanged)
        self.mRcRefreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("Loading Data...", comment: ""))
        
        /* Init tag list view */
        self.mTlvFilterRuleTagList.textFont = UIFont.systemFont(ofSize: 16)
        
        /* Init SearchController */
        self.mScNameSearchController = UISearchController(searchResultsController: nil)
        // Don't hide nav bar during searching
        self.mScNameSearchController?.hidesNavigationBarDuringPresentation = false
        // Don't darker the background color during searching
        self.mScNameSearchController?.dimsBackgroundDuringPresentation = false
        self.mScNameSearchController?.searchResultsUpdater = self
        self.mScNameSearchController?.definesPresentationContext = true
        self.mScNameSearchController?.searchBar.sizeToFit()
        self.mScNameSearchController?.searchBar.placeholder = "Please input the keyword..."
        self.navigationItem.searchController = self.mScNameSearchController
        // Hide the search bar when scrolling up, Default is true. if setup as false it will always display
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.mScNameSearchController?.searchBar.searchBarStyle = .prominent
        
        /* Init float button */
        let floaty = Floaty()
        floaty.buttonImage =  #imageLiteral(resourceName: "menu_icon")
        floaty.openAnimationType = .pop
        floaty.hasShadow = false
        floaty.sticky = true
        floaty.paddingX = 20
        floaty.paddingY = 20
        floaty.itemTitleColor = UIColor.darkGray
        // Locate user's location
        floaty.addItem(icon:  #imageLiteral(resourceName: "location_icon")) { (floatItem) in
            guard LocationManager.shared.isAuthorized() else {
                let title = NSLocalizedString("Notice!!!", comment: "")
                let content = NSLocalizedString("Location services were previously denied. Please enable location services for this app in Settings.", comment: "")
                self.showAlertDialog(title: title, content: content) {
                    action in
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            let config = GMSPlacePickerConfig(viewport: nil)
            let placePicker = GMSPlacePickerViewController(config: config)
            placePicker.delegate = self as GMSPlacePickerViewControllerDelegate
            
            self.present(placePicker, animated: true, completion: nil)
        }
        floaty.addItem(icon:  #imageLiteral(resourceName: "filter")) { (floatItem) in
            self.performSegue(withIdentifier: "show_restaurant_filter", sender: nil)
        }
        self.view.addSubview(floaty)
    }
    
    func initFilterRuleList() {
        guard let filterConfig = self.mFilterConfig else {
            return
        }
        
        self.mTlvFilterRuleTagList.removeAllTags()
        if let sortRuleStr = filterConfig.mSortingRuleDisplayStr {
            let tagView = self.mTlvFilterRuleTagList.addTag(sortRuleStr)
            tagView.onTap = {
                tagView in
                guard self.mTlvFilterRuleTagList.tagViews.count > 1 else {
                    return
                }
                self.mTlvFilterRuleTagList.removeTagView(tagView)
                filterConfig.mSortingRule = nil
                
                self.updateRestaruantList()
            }
        }
        if let openAt = filterConfig.mOpenAt {
            let openDate = Date(timeIntervalSince1970: Double(openAt))
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let tagView = self.mTlvFilterRuleTagList.addTag(NSLocalizedString("OPEN AT ", comment: "") + formatter.string(from: openDate))
            tagView.onTap = {
                tagView in
                guard self.mTlvFilterRuleTagList.tagViews.count > 1 else {
                    return
                }
                self.mTlvFilterRuleTagList.removeTagView(tagView)
                filterConfig.mOpenAt = nil
                
                self.updateRestaruantList()
            }
        }
        if let priceStr = filterConfig.mPriceDisplayStr {
            let tagView = self.mTlvFilterRuleTagList.addTag(priceStr)
            tagView.onTap = {
                tagView in
                guard self.mTlvFilterRuleTagList.tagViews.count > 1 else {
                    return
                }
                self.mTlvFilterRuleTagList.removeTagView(tagView)
                filterConfig.mPrice = nil
                
                self.updateRestaruantList()
            }
        }
    }
    
    func initConfig() {
        self.mJsonDecoder = Util.getJsonDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        self.mCurLocation = CLLocation(latitude: 25.047908, longitude: 121.517315)
        self.mFilterConfig = FilterConfigs()
        self.mFilterConfig?.mSortingRule = FilterConfigs.SortingRuleAPIConstants.best_match.rawValue
        
        initFilterRuleList()
        LocationManager.shared.setDelegate(delegate: self)
        YelpApiUtil.requestToken(apiTag: RestaurantListViewController.API_TAG_REQUEST_TOKEN
            , callback: self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.mFilteredRetaruantInfos != nil) ? self.mFilteredRetaruantInfos?.count : self.mAllRestaruantInfos?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListViewController.CELL_ID, for: indexPath) as? RestaurantInfoTableViewCell else {
            fatalError("Cell is not of kind RestaurantInfoTableViewCell")
        }
        let restaurantInfo = (self.mFilteredRetaruantInfos != nil) ? self.mFilteredRetaruantInfos![indexPath.row] : self.mAllRestaruantInfos![indexPath.row]
        
        cell.mLbNameLabel.text = restaurantInfo.name
        cell.mLbDistanceLabel.text = String(format: "%.2fm", arguments: [restaurantInfo.distance!])
        cell.mLbPriceLabel.text = restaurantInfo.price ?? ""
        cell.mLbReviewsLabel.text = (restaurantInfo.review_count != nil) ? "\(restaurantInfo.review_count ?? 0) " + NSLocalizedString("Reviews", comment: "") : ""
        cell.mLbAddressLabel.text = restaurantInfo.location?.display_address?.joined()
        cell.mIvPhotoImageView.kf.setImage(with: URL(string: restaurantInfo.image_url ?? ""), placeholder:  #imageLiteral(resourceName: "no_image"))
        cell.mIvRatingImage.image = restaurantInfo.getRatingImage(rating: restaurantInfo.rating ?? 0.0)
        cell.mLbTypeLabel.text = restaurantInfo.categoriesStr
        
        return cell
    }
    
    // MARK: - Table view data delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantInfos:[YelpRestaruantSummaryInfo]? = (self.mFilteredRetaruantInfos != nil) ? self.mFilteredRetaruantInfos : self.mAllRestaruantInfos
        let selectedInfo = restaurantInfos![indexPath.row]
        
        // TODO: It's workaround to avoid the crash when searchcontroller is activie and go back from detail page
        self.mScNameSearchController?.isActive = false
        performSegue(withIdentifier: "show_restaurant_detail", sender: selectedInfo)
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier;
        
        if identifier == "show_restaurant_detail" {
            let destViewController = segue.destination as! RestaurantDetailViewController
            let restaurantInfo = sender as! YelpRestaruantSummaryInfo
            
            destViewController.mRestaurantSummaryInfo = restaurantInfo
        }
    }
    
    // MARK: - Unwind Segue
    @IBAction func unwindToRestaurantList(segue: UIStoryboardSegue) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "press_apply_unwind_segue" {
            self.mIsNeedReFetch = true
        }
    }
    
    // MARK: - AlertController
    
    func showAlertDialog(title:String, content:String, handler:((UIAlertAction) -> Swift.Void)?) {
        let alertDialog = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:handler)
        alertDialog.addAction(okAction)
        self.present(alertDialog, animated: true, completion: nil)
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
    
    // MARK: - API function call
    func updateRestaruantList(isNeedShowLoading:Bool = true) {
        initFilterRuleList()
        
        if isNeedShowLoading {
            showLoadingDialog(loadingContent: NSLocalizedString("Loading Data...", comment: ""))
        }
        
        YelpApiUtil.businessSearch(apiTag: RestaurantListViewController.API_TAG_BUSINESS_SEARCH
            , term: "Restaurants"
            , lat: (self.mCurLocation?.coordinate.latitude)!
            , lng: (self.mCurLocation?.coordinate.longitude)!
            , locale: "zh_TW"
            , openAt: (self.mFilterConfig != nil && self.mFilterConfig?.mOpenAt != nil) ? self.mFilterConfig?.mOpenAt : nil
            , sortBy: (self.mFilterConfig != nil && self.mFilterConfig?.mSortingRule != nil) ? self.mFilterConfig?.mSortingRule : nil
            , price: (self.mFilterConfig != nil && self.mFilterConfig?.mPrice != nil) ? self.mFilterConfig?.mPrice : nil
            , callback: self)
    }
    
    // MARK: - API Callback
    func onError(apiTag: String, errorMsg: String) {
        self.closeLoadingDialog()
    }
    
    func onSuccess(apiTag: String, jsonData: Data?) {
        if apiTag == RestaurantListViewController.API_TAG_REQUEST_TOKEN {
            LocationManager.shared.requestLocationUpdate()
        } else if apiTag == RestaurantListViewController.API_TAG_BUSINESS_SEARCH {
            if let searchInfo = try?self.mJsonDecoder?.decode(YelpSearchInfo.self, from: jsonData!) {
                self.mSearchInfo = searchInfo
                self.mAllRestaruantInfos = self.mSearchInfo?.businesses ?? [YelpRestaruantSummaryInfo]()
                
                // Compose the categories string
                for i in stride(from: 0, to: (self.mAllRestaruantInfos?.count)!, by: 1) {
                    var categoriyTitles:[String] = [String]()
                    
                    for categoryInfo in self.mAllRestaruantInfos![i].categories! {
                        categoriyTitles.append(categoryInfo.title ?? "")
                    }
                    self.mAllRestaruantInfos![i].categoriesStr = categoriyTitles.joined(separator: ",")
                }
                self.tableView.reloadData()
            }
            self.closeLoadingDialog()
            self.mRcRefreshControl?.endRefreshing()
        }
    }
    
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        var keyword = searchController.searchBar.text ?? ""
        keyword = keyword.trimmingCharacters(in: .whitespaces)
        
        if keyword.count == 0 {
            self.mFilteredRetaruantInfos = nil
        } else {
            self.mFilteredRetaruantInfos = [YelpRestaruantSummaryInfo]()
            
            for info in self.mAllRestaruantInfos! {
                if (info.name?.contains(keyword))! || (info.location?.display_address?.contains(keyword))! ||
                    (info.categoriesStr?.contains(keyword))! {
                    self.mFilteredRetaruantInfos?.append(info)
                }
            }            
        }
        self.tableView.reloadData()
    }
    
    // MARK: - UIRefreshController pull-to-refresh target
    @objc func refreshListToDefaultConfigs(_ sender: Any) {
        // Use the taipei station as default location
        self.mFilterConfig?.mPrice = nil
        self.mFilterConfig?.mOpenAt = nil
        self.mFilterConfig?.mSortingRule = FilterConfigs.SortingRuleAPIConstants.best_match.rawValue
        
        updateRestaruantList(isNeedShowLoading: false)
    }
    
    // MARK: - LocationStatusDelegate
    func isLocationAuthorized(isAuthorized: Bool) {
        guard isAuthorized else {
            // Use the taipei station as default location
            updateRestaruantList()
            return
        }
        
        LocationManager.shared.requestLocationUpdate()
    }
    
    func didUpdateLocation(location: CLLocation) {
        self.mCurLocation = location
        
        LocationManager.shared.setDelegate(delegate: nil)
        LocationManager.shared.stopLocationUpdate()
        updateRestaruantList()
    }
    
    // MARK: - PlacePicker callback
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // To receive the results from the place picker 'self' will need to conform to
        // GMSPlacePickerViewControllerDelegate and implement this code.
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        self.mCurLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.mIsNeedReFetch = true
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
    }
}

