//
//  NavigateButton.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/27/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

@IBDesignable
class NavigateButton: UIButton{
    var bundle = Bundle(for: PlacesCell.self)
    
    override func awakeFromNib() {
        if FanFindConfiguration.currentTheme == .Light {
            self.setImage(UIImage(named: "arrow_gray", in: self.bundle, compatibleWith: nil), for: UIControl.State.normal)
        }else{
            self.setImage(UIImage(named: "arrow", in: self.bundle, compatibleWith: nil), for: UIControl.State.normal)
        }
    }
    
    
}
