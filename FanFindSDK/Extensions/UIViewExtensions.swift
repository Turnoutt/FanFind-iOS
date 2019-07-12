//
//  UIViewExtensions.swift
//  FanFind
//
//  Created by Christopher Woolum on 7/8/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
