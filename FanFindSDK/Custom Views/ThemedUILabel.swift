//
//  ThemedUILabel.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/18/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class ThemedUILabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = FanFindConfiguration.textColor
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = FanFindConfiguration.textColor
    }
}
