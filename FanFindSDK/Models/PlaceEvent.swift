//
//  PlaceDeal.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class PlaceEvent : Decodable {
    public var startDate: Date
    public var endDate: Date
    public var eventText: String
    
    enum CodingKeys: String, CodingKey{
        case eventText
        case startDate
        case endDate
    }
    
    public init(
        startDate: Date,
        endDate: Date,
        eventText: String){
        self.endDate = endDate
        self.startDate = startDate
        self.eventText = eventText
    }
    
    required init(from decoder: Decoder) throws{
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let endDateString = try container.decode(String.self, forKey: .endDate)
        let startDateString = try container.decode(String.self, forKey: .startDate)
        
        startDate = inFormatter.date(from: startDateString)!
        endDate = inFormatter.date(from: endDateString)!
        eventText = try container.decode(String.self, forKey: .eventText)
        
    }
}
