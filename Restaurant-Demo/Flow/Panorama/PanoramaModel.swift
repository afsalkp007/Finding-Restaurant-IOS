//
//  PanoramaModel.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import CoreLocation

class PanoramaModel {
    
    private var mLocCoordinate:CLLocationCoordinate2D?
    private var mLat:Double = 25.047908
    private var mLng:Double = 121.517315
    
    init() {
        self.mLocCoordinate = CLLocationCoordinate2D();
        self.mLocCoordinate?.latitude = self.mLat
        self.mLocCoordinate?.longitude = self.mLng
    }
    
    func setLocationLatLng(lat:Double, lng:Double) {
        self.mLocCoordinate?.latitude = lat
        self.mLocCoordinate?.longitude = lng
    }
    
    func getLocationCoordinate() -> CLLocationCoordinate2D? {
        return self.mLocCoordinate
    }
}
