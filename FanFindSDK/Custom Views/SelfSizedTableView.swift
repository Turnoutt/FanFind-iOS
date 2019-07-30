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
            totalHeight += self.numberOfRows(inSection: section) * Int(self.rowHeight)
        }
        
        // Header Heights
        totalHeight += self.numberOfSections * Int(self.sectionHeaderHeight)
        
        let height = min(CGFloat(totalHeight), maxHeight)
        
        print(height)
        
        return CGSize(width: contentSize.width, height: height)
    }
}
