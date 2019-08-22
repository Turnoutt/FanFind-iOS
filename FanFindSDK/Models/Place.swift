//
//  Place.swift
//  FanFindDemo
//
//  Created by Christopher Woolum on 6/3/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation
import MapKit

internal class Place: PeopleLocationAnnotation {
    var name: String = ""
    var address: String = ""
    var placeId: String = ""
    var nearByPlace: NearByPlace?
    
    var isSponsoredPlace: Bool {
        get{
            return nearByPlace?.isSponsoredPlace ?? false
        }
    }
    
    var logoUrl: String? {
        get{
            return nearByPlace?.logoUrl
        }
    }
    
    init(object: NearByPlace) {
        self.nearByPlace = object
        
        super.init(
            maleCount: 0,
            femaleCount: 0,
            unspecifiedCount: object.peopleCount ?? 0,
            coordinate: CLLocationCoordinate2D(latitude: object.latitude!, longitude: object.longitude!),
            latestUpdateDate: Date(),
            geoHash: ""
        )
    
        self.name = object.name ?? ""
        
        guard let placeId = object.placeId else { return }
        self.placeId = placeId
    }
}

extension Place {
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
}
