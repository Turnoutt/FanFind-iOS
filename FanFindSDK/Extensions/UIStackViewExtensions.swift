//
//  UIStackViewExtensions.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 8/17/21.
//  Copyright © 2021 Turnoutt Inc. All rights reserved.
//

import Foundation

extension UIStackView {

    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.layer.cornerRadius = 10;
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }

}
