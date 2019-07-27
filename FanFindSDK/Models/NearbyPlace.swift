//
//  NearbyPlace.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/10/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

public class NearByPlace: Decodable {
    
    public var latitude: Double?
    public var longitude: Double?
    public var name: String?
    public var placeId: String?
    public var peopleCount: Int64?
    public var isSponsoredPlace: Bool
    public var address1: String?
    public var address2: String
    public var cityName: String
    public var stateCode: String
    public var postalCode: String
    public var primaryCategory: String
    public var logoUrl: String?
    public var hasDeals: Bool?
    public var hasEvents: Bool?
    
    public var fullAddress: String{
        var fullAddress = ""
        
        if let address1 = address1 {
            fullAddress += address1
        }
        
        if !address2.isEmpty {
            fullAddress += " " + address2
        }
        
        if !cityName.isEmpty {
            fullAddress += " " + cityName
        }
        
        if !stateCode.isEmpty {
            fullAddress += ", " + stateCode
        }
        
        if !postalCode.isEmpty {
            fullAddress += " " + postalCode
        }
        
        return fullAddress
    }
    
    public init(
        name: String?,
        placeId: String?,
        peopleCount: Int64?,
        latitude: Double,
        longitude:Double,
        isSponsoredPlace: Bool,
        address1: String?,
        address2: String?,
        cityName: String,
        stateCode: String,
        postalCode: String,
        primaryCategory: String,
        logoUrl: String?,
        hasDeals: Bool?,
        hasEvents: Bool?
        ) {
        
        self.name = name
        self.placeId = placeId
        self.peopleCount = peopleCount
        self.latitude = latitude
        self.longitude = longitude
        self.isSponsoredPlace = isSponsoredPlace
        self.address1 = address1 ?? ""
        self.address2 = address2 ?? ""
        self.cityName = cityName
        self.stateCode = stateCode
        self.postalCode = postalCode
        self.primaryCategory = primaryCategory
        self.logoUrl = logoUrl
        self.hasDeals = hasDeals ?? false
        self.hasEvents = hasEvents ?? false
    }
}
