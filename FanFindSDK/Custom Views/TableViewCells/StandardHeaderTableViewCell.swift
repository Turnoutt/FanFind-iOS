//
//  StandardHeaderTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class StandardHeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet var label: UILabel!
    let border = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addBottomBorderWithColor(color: UIColor.init(hex: 0xD3D2D2, alpha: 1.0))
    }
    
    func addBottomBorderWithColor(color: UIColor) {        
        border.backgroundColor = color.cgColor
        
        self.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
    }
    
}
