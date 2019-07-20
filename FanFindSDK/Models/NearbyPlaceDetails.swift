//
//  NearbyPlaceDetails.swift
//  FanFind
//
//  Created by Christopher Woolum on 6/4/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

import Foundation

internal class NearByPlaceDetails: Decodable {
    
    public init(
        phoneNumber: String,
        deals: Array<PlaceDeal>,
        events: Array<PlaceEvent>,
        hours: Array<BusinessHour>
        ){
        
        self.phoneNumber = phoneNumber
        self.events = events
        self.deals = deals
        self.hours = hours
    }
    
    
    public let phoneNumber: String
    public let deals: Array<PlaceDeal>
    public let events: Array<PlaceEvent>
    public let hours: Array<BusinessHour>
    
    var formattedPhoneNumber: String {
        get{
            
            
            let cleanPhoneNumber = self.phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "(XXX) XXX-XXXX"
            
            var result = ""
            var index = cleanPhoneNumber.startIndex
            for ch in mask where index < cleanPhoneNumber.endIndex {
                if ch == "X" {
                    result.append(cleanPhoneNumber[index])
                    index = cleanPhoneNumber.index(after: index)
                } else {
                    result.append(ch)
                }
            }
            return result
        }
    }
}
