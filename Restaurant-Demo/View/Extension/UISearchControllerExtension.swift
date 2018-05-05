//
//  UISearchControllerExtension.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/5/5.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import UIKit

extension UISearchController {
    func initStyle(updater:UISearchResultsUpdating, placeholoderTxt:String) {
        self.hidesNavigationBarDuringPresentation = false
        // Don't darker the background color during searching
        self.dimsBackgroundDuringPresentation = false
        self.searchResultsUpdater = updater
        self.definesPresentationContext = true
        self.searchBar.sizeToFit()
        self.searchBar.tintColor = UIColor.white
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.white
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        self.searchBar.placeholder = placeholoderTxt
        self.searchBar.searchBarStyle = .prominent
    }
}
