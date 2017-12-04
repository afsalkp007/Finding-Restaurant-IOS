//
//  LocationManager.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/4.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    private static var sLocationMgr:CLLocationManager?
    
    func getInstance() -> CLLocationManager? {
        
        if LocationManager.sLocationMgr != nil {
            return LocationManager.sLocationMgr
        } else {
            LocationManager.sLocationMgr = CLLocationManager()
            return LocationManager.sLocationMgr
        }
    }
    
}
