//
//  NumberAbbreviator.swift
//  LE
//
//  Created by Luis Garcia on 9/14/17.
//  Copyright © 2017 locateeveryone. All rights reserved.
//

import Foundation

internal struct NumberAbbreviator {
    func formatPoints(num: Double) -> String {
        var thousandNum = num / 1000
        var millionNum = num / 1_000_000
        if num >= 1000, num < 1_000_000 {
            if floor(thousandNum) == thousandNum {
                return ("\(Int(thousandNum))k")
            }
            return ("\(thousandNum.roundToPlaces(1))k")
        }
        if num > 1_000_000 {
            if floor(millionNum) == millionNum {
                return "\(Int(thousandNum))k"
            }
            return "\(millionNum.roundToPlaces(1))M"
        } else {
            if floor(num) == num {
                return "\(Int(num))"
            }
            return "\(num)"
        }
    }
}

extension Double {
    // Rounds the double to decimal places value
    mutating func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (rounded() * divisor) / divisor
    }
}
