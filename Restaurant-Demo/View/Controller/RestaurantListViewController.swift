//
//  MenuTableViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/25.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantListViewController: UITableViewController, UISearchResultsUpdating, ApiCallback {
    
    private static let API_TAG_REQUEST_TOKEN = "API_TAG_REQUEST_TOKEN"
    private static let API_TAG_BUSINESS_SEARCH = "API_TAG_BUSINESS_SEARCH"
    private static let CELL_ID = "menu_cell"
    
    private var mScNameSearchController:UISearchController?
    private var mFilteredRetaruantInfos:[YelpRestaruantSummaryInfo]?
    private var mAllRestaruantInfos:[YelpRestaruantSummaryInfo]?
    private var mJsonDecoder:JSONDecoder?
    private var mSearchInfo:YelpSearchInfo?
    private var mLoadingAlertController:UIAlertController?
    private var mIsFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mAllRestaruantInfos = [YelpRestaruantSummaryInfo]()
        self.mFilteredRetaruantInfos = nil
        self.mJsonDecoder = Util.getJsonDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Only the first time need to fetch data from API
        if self.mIsFirst {
            self.mIsFirst = false
            fetchData()
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
        floaty.buttonImage = #imageLiteral(resourceName: "menu_icon")
        floaty.openAnimationType = .pop
        floaty.hasShadow = false
        floaty.sticky = true
        floaty.paddingX = 20
        floaty.paddingY = 20
        floaty.itemTitleColor = UIColor.darkGray
        // Locate user's location
        floaty.addItem(icon: #imageLiteral(resourceName: "location_icon")) { (floatItem) in
            print("Location float pressed")
        }
        self.view.addSubview(floaty)
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
        // #warning Incomplete implementation, return the number of sections
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
        cell.mIvPhotoImageView.kf.setImage(with: URL(string: restaurantInfo.image_url ?? ""), placeholder: #imageLiteral(resourceName: "no_image"))
        cell.mIvRatingImage.image = restaurantInfo.getRatingImage(rating: restaurantInfo.rating ?? 0.0)
        cell.mLbTypeLabel.text = restaurantInfo.categoriesStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantInfos:[YelpRestaruantSummaryInfo]? = (self.mFilteredRetaruantInfos != nil) ? self.mFilteredRetaruantInfos : self.mAllRestaruantInfos
        let selectedInfo = restaurantInfos![indexPath.row]
        
        performSegue(withIdentifier: "show_restaurant_detail", sender: selectedInfo)
    }
    
    // MARK: - Prepare Segue
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! RestaurantDetailViewController
        let restaurantInfo = sender as! YelpRestaruantSummaryInfo
        
        destViewController.mRestaurantSummaryInfo = restaurantInfo
    }
    
    // MARK: - API Callback
    func fetchData() {
        showLoadingDialog(loadingContent: "Loading Data...")
        YelpApiUtil.requestToken(apiTag: RestaurantListViewController.API_TAG_REQUEST_TOKEN, callback: self)
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
    
    func onError(apiTag: String, errorMsg: String) {
        self.closeLoadingDialog()
    }
    
    func onSuccess(apiTag: String, jsonData: Data?) {
        if apiTag == RestaurantListViewController.API_TAG_REQUEST_TOKEN {
            YelpApiUtil.businessSearch(apiTag: RestaurantListViewController.API_TAG_BUSINESS_SEARCH, term: "Restaurants", location: "Taipei, Taiwan", locale: "zh_TW", callback: self)
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
}
