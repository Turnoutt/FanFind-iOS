//
//  FacetResponse.swift
//  FanFind
//
//  Created by Christopher Woolum on 12/30/19.
//

import Foundation


internal class FacetResponse: Decodable {
    public var displayName: String
    public var fieldName: String
    public var values: [Facet]
    
    init(
    displayName: String,
    fieldName: String,
    values: [Facet]
    ){
        self.displayName = displayName
        self.fieldName = fieldName
        self.values = values
    }
}
