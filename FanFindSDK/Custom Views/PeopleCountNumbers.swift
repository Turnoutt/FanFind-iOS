//
//  PeopleCountBar.swift
//  LE
//
//  Created by Christopher Woolum on 10/22/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import Foundation
import UIKit

internal class PeopleCountNumbers: UIView {
    @IBOutlet weak var totalBox: UIStackView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initViews()
    }
    
    public func setTotals(maleCount: Int64, femaleCount: Int64, neutralCount: Int64) {
        
        let totalCount = maleCount + femaleCount + neutralCount
        
        DispatchQueue.main.async {
            self.totalCountLabel.text = NumberAbbreviator().formatPoints(num: Double(totalCount))
        }
    }
    
    override var intrinsicContentSize: CGSize{
        let height = totalBox.frame.size.height
        let width = totalBox.frame.size.width + totalCountLabel.frame.size.width + 12
        return CGSize(width: width, height: height)
    }
    
    func initViews() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PeopleCountNumbers", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        translatesAutoresizingMaskIntoConstraints = false
        
        frame.size.height = 40
        totalBox.layer.backgroundColor = FanFindConfiguration.primaryColor.cgColor
        totalLabel.textColor = FanFindConfiguration.secondaryColor
        totalCountLabel.textColor = UIColor.white
        
        self.totalCountLabel.text = "1000"
        
    }
    
    
}
