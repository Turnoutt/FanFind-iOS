//
//  RoundedCollectionViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/26/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class RoundedCollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutView()
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        self.layer.shadowRadius = 15.0
        self.layer.shadowColor = FanFindConfiguration.primaryColor.cgColor
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
