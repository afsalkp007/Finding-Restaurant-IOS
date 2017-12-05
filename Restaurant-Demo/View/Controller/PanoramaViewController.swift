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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude:150.312))
    }
}
