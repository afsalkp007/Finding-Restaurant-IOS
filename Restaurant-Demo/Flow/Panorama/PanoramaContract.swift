//
//  PanoramaContract.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/3/18.
//  Copyright © 2018年 yomi. All rights reserved.
//

import Foundation
import CoreLocation

protocol PanoramaPresenterProtocol {
    
    func attachView(view:PanoramaViewProtocol)
    func onInitParameters(lat:Double, lng:Double)
    func onViewDidLoad()
    func onViewDidAppear()
    
    func onLoadViewFinish()
}


protocol PanoramaViewProtocol {
    func onMoveNearCoordinate(coordinate:CLLocationCoordinate2D?)
}
