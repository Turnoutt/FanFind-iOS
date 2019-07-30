//
//  SelfSizedTableView.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        var totalHeight = 0
        
        if self.numberOfSections == 0 {
            return CGSize(width: contentSize.width, height: 0)
        }
        
        // Row Heights
        for section in 0...(self.numberOfSections - 1) {
            totalHeight += self.numberOfRows(inSection: section) * 20
        }
        
        // Header Heights
        totalHeight += self.numberOfSections * 40
        
        let height = min(CGFloat(totalHeight), maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
