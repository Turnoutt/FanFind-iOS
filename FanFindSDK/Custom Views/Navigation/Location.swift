//
//  Location.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/27/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation
import CoreLocation

extension Navigator {
    public struct Location {
        public let coordinate: CLLocationCoordinate2D
        public let name: String?
        public let address: String?
        
        public init(name: String? = nil, address: String? = nil, coordinate: CLLocationCoordinate2D) {
            self.name = name
            self.address = address
            self.coordinate = coordinate
        }
        
        public init(name: String? = nil,
                    address: String? = nil,
                    latitude: CLLocationDegrees,
                    longitude: CLLocationDegrees) {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.init(name: name, address: address, coordinate: coordinate)
        }
    }
}
