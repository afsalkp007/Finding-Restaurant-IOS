//
//  PanoramaPresenter.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation

class PanoramaPresenter: PanoramaPresenterProtocol {
    
    
    private var mView:PanoramaViewProtocol?
    private var mModel:PanoramaModel? = PanoramaModel()
    
    // MARK:- PanoramaPresenterProtocol
    
    func onInitParameters(lat: Double, lng: Double) {
        self.mModel?.setLocationLatLng(lat: lat, lng: lng)
    }
    
    func attachView(view: PanoramaViewProtocol) {
        self.mView = view
    }
    
    func onViewDidLoad() {
        self.mView?.onMoveNearCoordinate(coordinate: self.mModel?.getLocationCoordinate())
    }
    
    func onViewDidAppear() {}
    
    func onViewDidDisappear() {}
    
    func onLoadViewFinish() {}
}
