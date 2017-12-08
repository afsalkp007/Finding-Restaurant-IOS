//
//  NavigationControllerExtension.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/8.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.shadowImage = nil
    }
}
