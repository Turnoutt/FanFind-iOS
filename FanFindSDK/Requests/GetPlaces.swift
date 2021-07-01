//
//  GetPlaces.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/9/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

internal struct GetPlaces: APIRequest {
    public typealias Response = GetPlacesResponse
    
    public var resourceName: String {
        return "v3/places/nearby"
    }
    
    public init(latitude: Float, longitude: Float, radius: Int, query: String?, facets: [String: [String]]){
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.query = query
        self.facets = facets
    }
    
    let latitude: Float
    let longitude: Float
    let radius: Int
    let query: String?
    let facets: [String: [String]]
    
}
