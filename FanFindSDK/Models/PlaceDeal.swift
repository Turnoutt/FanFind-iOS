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
    
    public init(
        startDate: Date,
        endDate: Date,
        dealText: String){
        self.endDate = endDate
        self.startDate = startDate
        self.dealText = dealText
    }
}
