//
//  BusinessHour.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class BusinessHour: Decodable{
    public var dayOfWeek: String
    public var startTime: Date
    public var endTime: Date
    public var dayNumberOfWeek: Int
    
    public init(
    dayOfWeek: String,
    startTime: String,
    endTime: String,
    dayNumberOfWeek: Int
        ){
        
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"
        
        self.dayNumberOfWeek = dayNumberOfWeek
        self.dayOfWeek = dayOfWeek
        self.endTime = inFormatter.date(from: endTime)!
        self.startTime = inFormatter.date(from: startTime)!
    }
}
