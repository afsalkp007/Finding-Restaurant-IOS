//
//  PanoramaViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2017/12/5.
//  Copyright © 2017年 yomi. All rights reserved.
//

import UIKit
import GoogleMaps

class PanoramaViewController: UIViewController, GMSMapViewDelegate {
    
    var mLat:Double = 25.047908
    var mLng:Double = 121.517315
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hideTransparentNavigationBar()
    }

    override func loadView() {
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: self.mLat, longitude:self.mLng))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
