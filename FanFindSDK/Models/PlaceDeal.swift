//
//  PlaceDeal.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

class PlaceDeal : Decodable {
    public var startDate: Date
    public var endDate: Date
    public var dealText: String
    
    enum CodingKeys: String, CodingKey{
        case dealText
        case startDate
        case endDate
    }
    
    public init(
        startDate: Date,
        endDate: Date,
        dealText: String){
        self.endDate = endDate
        self.startDate = startDate
        self.dealText = dealText
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
        dealText = try container.decode(String.self, forKey: .dealText)
        
    }
}
