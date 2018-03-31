//
//  PanoramaViewController.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import UIKit
import GoogleMaps

class PanoramaViewController: UIViewController, GMSMapViewDelegate, PanoramaViewProtocol {
    
    var mLat:Double = 25.047908
    var mLng:Double = 121.517315
    
    private var mPresenter:PanoramaPresenterProtocol?
    
    // MARK:- Life Cycle & Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mPresenter = PanoramaPresenter()
        self.mPresenter?.onInitParameters(lat: mLat, lng: mLng)
        self.mPresenter?.attachView(view: self)
        self.mPresenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.navigationController?.presentTransparentNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mPresenter?.onViewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.mPresenter?.onViewDidDisappear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hideTransparentNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- GMSMapViewDelegate
    override func loadView() {
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        self.mPresenter?.onLoadViewFinish()
    }
    
    // MARK:- PanoramaViewProtocol
    func onMoveNearCoordinate(coordinate: CLLocationCoordinate2D?) {
        guard let panoView = self.view as? GMSPanoramaView else {
            return
        }
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!))
    }
}
