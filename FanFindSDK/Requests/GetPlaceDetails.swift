//
//  GetPlaceDetails.swift
//  FanFind
//
//  Created by Christopher Woolum on 5/28/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

internal struct GetPlaceDetails: APIRequest {
    public typealias Response = NearByPlaceDetails
    
    public var resourceName: String {
        return "places/v2/" + self.placeId + "/details"
    }
    
    public init(placeId: String){
        self.placeId = placeId
    }
    
    let placeId: String
}
