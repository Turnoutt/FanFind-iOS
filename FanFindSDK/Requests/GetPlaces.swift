//
//  GetPlaces.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/9/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

internal struct GetPlaces: APIRequest {
    public typealias Response = [NearByPlace]
    
    public var resourceName: String {
        return "places/v2/nearby"
    }
    
    public init(latitude: Float, longitude: Float, radius: Int, query: String?){
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.query = query
    }
    
    let latitude: Float
    let longitude: Float
    let radius: Int
    let query: String?
    
}
