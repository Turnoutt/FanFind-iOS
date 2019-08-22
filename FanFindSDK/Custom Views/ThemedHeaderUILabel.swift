//
//  ThemedHeaderUILabel.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/30/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class ThemedHeaderUILabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        if FanFindConfiguration.currentTheme == .Dark {
            self.textColor = UIColor.white
        } else{
            self.textColor = FanFindConfiguration.textColor
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if FanFindConfiguration.currentTheme == .Dark {
            self.textColor = UIColor.white
        } else{
            self.textColor = FanFindConfiguration.textColor
        }
    }
    
   
}
