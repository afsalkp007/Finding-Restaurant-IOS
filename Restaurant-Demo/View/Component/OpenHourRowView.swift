//
//  OpenHourRowView.swift
//  Restaurant-Demo
//
//  Created by yomi on 2018/2/16.
//  Copyright © 2018年 yomi. All rights reserved.
//

import UIKit

class OpenHourRowView: UIView {
    
    @IBOutlet var mVContentView: UIView!
    
    @IBOutlet weak var mLbDayLabel: UILabel!
    
    @IBOutlet weak var mLbOpenTiemRangeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("OpenHourRowView", owner: self, options: nil)
        addSubview(mVContentView)
        self.mVContentView.bounds = self.bounds
        self.mVContentView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
    }
}
