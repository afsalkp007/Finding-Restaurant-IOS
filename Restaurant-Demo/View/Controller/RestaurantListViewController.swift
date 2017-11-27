//
//  MenuTableViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/11/25.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class RestaurantListViewController: UITableViewController, UISearchResultsUpdating {
    private static let CELL_ID = "menu_cell"
    
    private var mScNameSearchController:UISearchController?
    private var mFilteredRetaruantInfos:[YelpRestaruantInfo]?
    private var mAllRestaruantInfos:[YelpRestaruantInfo]?
    private var mJsonDecoder:JSONDecoder?
    private var mYelpAuthenticationInfo:YelpAuthenticationInfo?
    private var mYelpSearchInfo:YelpSearchInfo?
    private var mLoadingAlertController:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mAllRestaruantInfos = [YelpRestaruantInfo]()
        self.mFilteredRetaruantInfos = nil
        self.mJsonDecoder = JSONDecoder()
        self.mJsonDecoder?.dateDecodingStrategy = .iso8601
        
        initView()
        fetchData()
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
    }
    
    func fetchData() {
        var parameters: Parameters = ["grant_type": YelpApiConfigs.OAUTH_GRANT_TYPYE
            , "client_id":YelpApiConfigs.CLIENT_ID
            , "client_secret":YelpApiConfigs.CLIENT_SECRET]
        
        showLoadingDialog(loadingContent: "Loading Data...")
        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters).responseJSON {
            response in
            if response.error == nil, let authenticationInfo = try? self.mJsonDecoder?.decode(YelpAuthenticationInfo.self, from: response.data!) {
                self.mYelpAuthenticationInfo = authenticationInfo
                parameters = ["term":"Restaurants", "location":"Taipei, Taiwan", "locale":"zh_TW"]
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(self.mYelpAuthenticationInfo?.access_token ?? "")",
                    "Accept": "application/json"
                ]
                
                Alamofire.request("https://api.yelp.com/v3/businesses/search", method: .get, parameters: parameters, headers: headers).responseJSON {
                    response in
                    if response.error == nil, let searchInfo = try?self.mJsonDecoder?.decode(YelpSearchInfo.self, from: response.data!) {
                        self.mYelpSearchInfo = searchInfo
                        self.mAllRestaruantInfos = self.mYelpSearchInfo?.businesses
                        
                        self.tableView.reloadData()
                    } else {
                        print("Error = \(response.error.debugDescription), or mYelpSearchInfo = nil")
                    }
                    self.closeLoadingDialog()
                }
            } else {
                print("Error = \(response.error.debugDescription), or YelpAuthenticationInfo = nil")
                self.closeLoadingDialog()
            }
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
        present(self.mLoadingAlertController!, animated: true, completion: nil)
    }
    
    func closeLoadingDialog() {
        if self.mLoadingAlertController != nil {
            self.mLoadingAlertController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func filterTable(searchText:String) {
        // TODO: Apply search text
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Search Text = \(searchController.searchBar.text ?? "")")
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
        cell.mLbRatingLabel.text = (restaurantInfo.rating != nil) ? "\(restaurantInfo.rating ?? 0) starts" : ""
        cell.mLbAddressLabel.text = restaurantInfo.location?.display_address?.joined()
        cell.mIvPhotoImageView.kf.setImage(with: URL(string: restaurantInfo.image_url ?? ""), placeholder: UIImage(named: "no_image"))
        
        var categoriyTitles:[String] = [String]()
        for categoryInfo in restaurantInfo.categories! {
            categoriyTitles.append(categoryInfo.title ?? "")
        }
        cell.mLbTypeLabel.text = categoriyTitles.joined(separator: ",")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantInfos:[YelpRestaruantInfo]? = (self.mFilteredRetaruantInfos != nil) ? self.mFilteredRetaruantInfos : self.mAllRestaruantInfos
        let selectedInfo = restaurantInfos![indexPath.row]
        
        performSegue(withIdentifier: "show_restaurant_detail", sender: selectedInfo)
    }
    
    // MARK: - Prepare Segue
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController = segue.destination as! RestaurantDetailViewController
        let restaurantInfo = sender as! YelpRestaruantInfo
        
        destViewController.mRestaurantInfo = restaurantInfo
    }    
}
