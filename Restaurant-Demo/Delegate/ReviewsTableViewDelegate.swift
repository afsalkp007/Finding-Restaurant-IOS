//
//  ReviewsTableViewDelegate.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/2/8.
//  Copyright © 2018年 yomi. All rights reserved.
//

import UIKit

class ReviewsTableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private static let REVIEW_REVIEW_COUNT = 3
    private static let REVIEW_ITEM_CELL_ID = "review_detail_info_cell"
    
    private var mReviewDetailInfos:[YelpReviewDetailInfo]?
    
    init(reviewDetailInfos:[YelpReviewDetailInfo]) {
        self.mReviewDetailInfos = reviewDetailInfos
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mReviewDetailInfos?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewDelegate.REVIEW_ITEM_CELL_ID) as? ReviewDetailInfoTableViewCell else {
            fatalError("Cell is not of kind RestaurantInfoTableViewCell")
        }
        
        let reviewDetailInfo = self.mReviewDetailInfos![indexPath.row]
        cell.mIvReviewerRatingImageView.image = reviewDetailInfo.getRatingImage(rating: Double.init(reviewDetailInfo.rating ?? 0))
        cell.mIvReviewerHeadIconImageView.kf.setImage(with: URL(string: reviewDetailInfo.user?.image_url ?? ""))
        cell.mLbReviewerNameLabel.text = reviewDetailInfo.user?.name ?? ""
        cell.mLbReviewContentLabel.text = reviewDetailInfo.text ?? ""
        
        return cell
    }
    
    
}
