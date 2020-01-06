//
//  GetPlacesResponse.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 12/28/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class GetPlacesResponse: Decodable {
    public var results: [NearByPlace]
    public var facets: [FacetResponse]
    
    init(
        results: [NearByPlace],
        facets: [FacetResponse]
    ){
        self.results = results
        self.facets = facets
    }
}
