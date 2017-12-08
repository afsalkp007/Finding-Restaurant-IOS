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

class RestaurantListViewController: UITableViewController, UISearchResultsUpdating, ApiCallback, GMSPlacePickerViewControllerDelegate, LocationStatusDelegate {
    
    private static let API_TAG_REQUEST_TOKEN = "API_TAG_REQUEST_TOKEN"
    private static let API_TAG_BUSINESS_SEARCH = "API_TAG_BUSINESS_SEARCH"
    private static let CELL_ID = "menu_cell"
    
    private var mScNameSearchController:UISearchController?
    private var mFilteredRetaruantInfos:[YelpRestaruantSummaryInfo]? = nil
    private var mAllRestaruantInfos:[YelpRestaruantSummaryInfo]? = [YelpRestaruantSummaryInfo]()
    private var mJsonDecoder:JSONDecoder?
    private var mSearchInfo:YelpSearchInfo?
    private var mLoadingAlertController:UIAlertController?
    private var mIsFirst = true
    private var mLocationMgr:LocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Only the first time need to fetch data from API
        if self.mIsFirst {
            self.mIsFirst = false
            initConfig()
        }
    }
    
    func initView() {
        /* Init NavigationController  */
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        /* Init TableView  */
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 30
        
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
        
        /* Add the float button */
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
            
            guard (self.mLocationMgr?.isAuthorized())! else {
                self.showAlertDialog(title: "Notice!!!", content: "Location services were previously denied. Please enable location services for this app in Settings.") {
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
        self.view.addSubview(floaty)
    }
    
    func initConfig() {
        self.mJsonDecoder = Util.getJsonDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        self.mLocationMgr = LocationManager.getInstance()
        
        self.mLocationMgr?.setDelegate(delegate: self)
        YelpApiUtil.requestToken(apiTag: RestaurantListViewController.API_TAG_REQUEST_TOKEN, callback: self)
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
        cell.mLbReviewsLabel.text = (restaurantInfo.review_count != nil) ? "\(restaurantInfo.review_count ?? 0) reviews" : ""
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
        
        performSegue(withIdentifier: "show_restaurant_detail", sender: selectedInfo)
    }
    
    // MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! RestaurantDetailViewController
        let restaurantInfo = sender as! YelpRestaruantSummaryInfo
        
        destViewController.mRestaurantSummaryInfo = restaurantInfo
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
            self.mLoadingAlertController?.dismiss(animated: true, completion: nil)
            self.mLoadingAlertController = nil
        }
    }
    
    // MARK: - API Callback
    
    func onError(apiTag: String, errorMsg: String) {
        self.closeLoadingDialog()
    }
    
    func onSuccess(apiTag: String, jsonData: Data?) {
        if apiTag == RestaurantListViewController.API_TAG_REQUEST_TOKEN {
            self.mLocationMgr?.requestLocationUpdate()
        } else if apiTag == RestaurantListViewController.API_TAG_BUSINESS_SEARCH {
            if let searchInfo = try?self.mJsonDecoder?.decode(YelpSearchInfo.self, from: jsonData!) {
                self.mSearchInfo = searchInfo
                self.mAllRestaruantInfos = self.mSearchInfo?.businesses
                
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
        }
    }
    
    // MARK: - LocationStatusDelegate
    
    func isLocationAuthorized(isAuthorized: Bool) {
        guard isAuthorized else {
            // Use the taipei station as default location
            showLoadingDialog(loadingContent: "Loading Data...")
            YelpApiUtil.businessSearch(apiTag: RestaurantListViewController.API_TAG_BUSINESS_SEARCH, term: "Restaurants", lat: 25.047908 , lng: 121.517315, locale: "zh_TW", callback: self)
            return
        }
        
        self.mLocationMgr?.requestLocationUpdate()
    }
    
    func didUpdateLocation(location: CLLocation) {
        self.mLocationMgr?.setDelegate(delegate: nil)
        self.mLocationMgr?.stopLocationUpdate()
        showLoadingDialog(loadingContent: "Loading Data...")
        YelpApiUtil.businessSearch(apiTag: RestaurantListViewController.API_TAG_BUSINESS_SEARCH, term: "Restaurants", lat: location.coordinate.latitude , lng: location.coordinate.longitude, locale: "zh_TW", callback: self)
    }
    
    // MARK: - PlacePicker callback
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // To receive the results from the place picker 'self' will need to conform to
        // GMSPlacePickerViewControllerDelegate and implement this code.
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        showLoadingDialog(loadingContent: "Loading Data...")
        YelpApiUtil.businessSearch(apiTag: RestaurantListViewController.API_TAG_BUSINESS_SEARCH, term: "Restaurants", lat: place.coordinate.latitude , lng: place.coordinate.longitude, locale: "zh_TW", callback: self)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
    }
}

