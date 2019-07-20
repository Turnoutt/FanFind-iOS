//
//  DateExtensions.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/18/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    /*
     Returns the day number of the week where 1 is Sunday
     */
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
