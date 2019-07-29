//
//  StandardHeaderTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class StandardHeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if FanFindConfiguration.currentTheme == .Dark {
            label.textColor = UIColor.white
        } else{
            label.textColor = FanFindConfiguration.textColor
        }
        
        addBottomBorderWithColor(color: UIColor.init(hex: 0xD3D2D2, alpha: 1.0), width: 1.0)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
}
