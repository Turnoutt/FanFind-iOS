//
//  PlaceDeal.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

class PlaceEvent : Decodable {
    public var startDate: Date
    public var endDate: Date
    public var eventText: String
    
    public init(
        startDate: Date,
        endDate: Date,
        eventText: String){
        self.endDate = endDate
        self.startDate = startDate
        self.eventText = eventText
    }
}
