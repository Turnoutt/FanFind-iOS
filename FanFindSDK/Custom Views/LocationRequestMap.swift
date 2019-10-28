//
//  LocationRequestMap.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 10/24/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class LocationRequestMap: UIView {

    @IBOutlet var contentView: UIView!
    var bundle = Bundle(for: PlacesCell.self)
    
    
      override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
     }
     
     func commonInit() {
        let nib = UINib(nibName: "LocationRequestMap", bundle: self.bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
     }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = FanFindConfiguration.primaryColor
    }
}
