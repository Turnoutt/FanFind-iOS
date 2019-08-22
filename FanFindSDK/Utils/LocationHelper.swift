//
//  LocationHelper.swift
//  LE
//
//  Created by Luis Garcia on 3/13/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import CoreLocation

private struct LocationDistance {
    let place: Place
    let distance: Double
}

internal struct LocationHelper {
    public func sort(places: [Place], byDistanceFrom currentLocation: CLLocationCoordinate2D) -> [Place] {
        let myLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        var locationDistanceArray: [LocationDistance] = []
        for place in places {
            let otherLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            let distance = myLocation.distance(from: otherLocation)
            locationDistanceArray.append(LocationDistance(place: place, distance: distance))
        }
        
        let sorted = locationDistanceArray.sorted(by:
            { ($0.place.isSponsoredPlace ? 1 : 0) > ($1.place.isSponsoredPlace ? 1 : 0) && $0.distance < $1.distance }
        )
        
        return sorted.map({ $0.place })
    }
}
