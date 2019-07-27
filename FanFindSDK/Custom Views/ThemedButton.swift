//
//  ThemedButton.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

@IBDesignable
class ThemedButton : UIButton{

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = FanFindConfiguration.primaryColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
}
