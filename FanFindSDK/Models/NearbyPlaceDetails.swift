//
//  NearbyPlaceDetails.swift
//  FanFind
//
//  Created by Christopher Woolum on 6/4/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

import Foundation

public class NearByPlaceDetails: Decodable {

    public init(address1: String, address2: String?, cityName: String, phoneNumber: String, postalCode: String, stateCode: String, primaryCategory: String){
        self.address1 = address1
        self.address2 = address2
        self.cityName = cityName
        self.stateCode = stateCode
        self.postalCode = postalCode
        self.phoneNumber = phoneNumber
        self.primaryCategory = primaryCategory
    }
    
    public let address1: String
    public let address2: String?
    public let cityName: String
    public let phoneNumber: String
    public let postalCode: String
    public let stateCode: String
    public let primaryCategory: String
}
