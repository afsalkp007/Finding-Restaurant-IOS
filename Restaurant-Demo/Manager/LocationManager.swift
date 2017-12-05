//
//  LocationManager.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/4.
//  Copyright © 2017年 yomi. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationStatusDelegate {
    func isLocationAuthorized(isAuthorized:Bool)
    func didUpdateLocation(location:CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private static var sInstance:LocationManager?
    
    private var mLocationMgr:CLLocationManager?
    private var mDelegate:LocationStatusDelegate?
    
    static func getInstance() -> LocationManager? {
        
        if sInstance == nil {
            sInstance = LocationManager()
            sInstance?.mLocationMgr = CLLocationManager()
            sInstance?.mLocationMgr?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        return sInstance
    }
    
    func setDelegate(delegate:LocationStatusDelegate?
        ) {
        self.mDelegate = delegate
    }
    
    func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||  CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    func requestAuthorize(authorizeStatus:CLAuthorizationStatus) {
        switch (authorizeStatus) {
        case .authorizedAlways:
            self.mLocationMgr?.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            self.mLocationMgr?.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func requestLocationUpdate() -> Void {
        self.mLocationMgr?.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 1. 還沒有詢問過用戶以獲得權限
            requestAuthorize(authorizeStatus:.authorizedWhenInUse)
        } else if CLLocationManager.authorizationStatus() == .denied {
            // 2. 用戶不同意
            if self.mDelegate != nil {
                self.mDelegate?.isLocationAuthorized(isAuthorized: false)
            }
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.mLocationMgr?.startUpdatingLocation()
        }
    }
    
    func stopLocationUpdate() {
        self.mLocationMgr?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard self.mDelegate != nil else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.mDelegate?.isLocationAuthorized(isAuthorized: true)
        } else {
            self.mDelegate?.isLocationAuthorized(isAuthorized: false)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard self.mDelegate != nil else {
            return
        }
        
        let location = locations[0]
        self.mDelegate?.didUpdateLocation(location: location)
    }
    
}
