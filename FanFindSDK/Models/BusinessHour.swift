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
    
    enum CodingKeys: String, CodingKey{
        case dayOfWeek
        case startTime
        case endTime
        case dayNumberOfWeek
    }
    
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
    
    required init(from decoder: Decoder) throws{
        let inFormatter = DateFormatter()
        inFormatter.timeZone = TimeZone.current
        inFormatter.locale = Locale.current
        inFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xx"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let endDateString = try container.decode(String.self, forKey: .endTime)
        let startDateString = try container.decode(String.self, forKey: .startTime)
        
        self.dayNumberOfWeek = try container.decode(Int.self, forKey: .dayNumberOfWeek)
        // Adjust the value from the API to the OSX value
        self.dayNumberOfWeek += 1
        
        self.dayOfWeek = try container.decode(String.self, forKey: .dayOfWeek)
        
        let currentDayOfWeek = Date().dayNumberOfWeek()
        
        let calendar = Calendar(identifier: .gregorian)
        
        // Weekday units are the numbers 1 through n, where n is the number of days in the week.
        // For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
        
        let sundayComponents = DateComponents(calendar: calendar, weekday: dayNumberOfWeek)
        
        var nextDate: String = ""
        
        if(self.dayNumberOfWeek > currentDayOfWeek!){
            let nextDateString = calendar.nextDate(after: Date(), matching: sundayComponents, matchingPolicy: .nextTime)
             nextDate = dateFormatter.string(from: nextDateString!)
        }else if(self.dayNumberOfWeek < currentDayOfWeek!){
            let nextDateString = calendar.nextDate(
                after: Date(),
                matching: sundayComponents,
                matchingPolicy: .nextTime,
                direction: .backward)
             nextDate = dateFormatter.string(from: nextDateString!)
        } else{
             nextDate = dateFormatter.string(from: Date())
        }
        
        self.endTime = inFormatter.date(from: nextDate + " " + endDateString + " " + TimeZone.current.offsetFromUTC())!
        self.startTime = inFormatter.date(from: nextDate + " " + startDateString + " " + TimeZone.current.offsetFromUTC())!
        
        print(self.startTime, self.endTime)
        
    }
}

extension TimeZone {
    
    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetInHours() -> String
    {
        
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
