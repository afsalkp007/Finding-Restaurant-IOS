//
//  Util.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/2.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import UIKit
import RIGImageGallery
import Kingfisher

class Util {
    private static let sJsonDecoder:JSONDecoder = JSONDecoder()
    
    static func getJsonDecoder() -> JSONDecoder {
        return sJsonDecoder
    }
    
    static func openUrl(url:URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func getNowWeekDay() -> Int {
        return Calendar.current.component(.weekday, from: Date())
    }
    
    static func createPhotoGallery(sourceViewController:UIViewController, currentImgIndex:Int, urlStrs:[String]) -> RIGImageGalleryViewController {
        let urls: [URL?] = urlStrs.map {URL(string:$0)}
        let rigItems: [RIGImageGalleryItem] = urls.map { _ in
            RIGImageGalleryItem(placeholderImage: #imageLiteral(resourceName: "no_image"),
                                isLoading: true)
        }        
        let rigController = RIGImageGalleryViewController(images: rigItems)
        
        for (index, url) in urls.enumerated() {
            ImageDownloader.default.downloadImage(with: url! , options: [.fromMemoryCacheOrRefresh, .backgroundDecode], progressBlock: nil) {
                [weak rigController] (image, error, url, data) in
                rigController?.images[index].image = image
                rigController?.images[index].isLoading = false
            }
        }
        rigController.dismissHandler = {
           [weak sourceViewController] (rigController:RIGImageGalleryViewController) -> Void in
            sourceViewController?.navigationController?.popViewController(animated: true)
            rigController.navigationController?.toolbar.isHidden = true
        }
        
        rigController.navigationController?.toolbar.isHidden = false
        rigController.setCurrentImage(currentImgIndex, animated: false)
        
        return rigController
    }
}
