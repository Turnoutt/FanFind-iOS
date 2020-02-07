//
//  TeamSelector.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 2/2/20.
//  Copyright © 2020 Turnoutt Inc. All rights reserved.
//

import UIKit

class TeamSelector: UIView {
    @IBOutlet var button: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(red:0.89, green:0.09, blue:0.22, alpha:1.0)
        roundCorners(corners: [.topLeft, .bottomLeft], radius: 10.0)
    }
}
