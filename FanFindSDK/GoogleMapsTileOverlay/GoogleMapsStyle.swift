//
//  GoogleMapsStyle.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/11/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal struct GoogleMapsStyle: Decodable {
    
    var featureType: String?
    var elementType: String?
    var stylers: [Styler]?
    
    init(featureType: String? = nil,
         elementType: String? = nil,
         stylers: [Styler]? = nil) {
        self.featureType = featureType
        self.elementType = elementType
        self.stylers = stylers
    }
    
}


internal struct Styler: Decodable {
    
    var visibility: String?
    var color: String?
    var weight: Double?
    var gamma: String?
    var hue: String?
    var saturation: Int?
    var lightness: Int?
    var invertLightness: String?
    
    init(visibility: String? = nil,
         color: String? = nil,
         weight: Double? = nil,
         gamma: String? = nil,
         hue: String? = nil,
         saturation: Int? = nil,
         lightness: Int? = nil,
         invertLightness: String? = nil) {
        
        self.visibility = visibility
        self.color = color
        self.weight = weight
        self.gamma = gamma
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
        self.invertLightness = invertLightness
    }
    
}
