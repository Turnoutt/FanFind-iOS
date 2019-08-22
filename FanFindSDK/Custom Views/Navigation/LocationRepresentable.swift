//
//  LocationRepresentable.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/27/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

internal protocol LocationRepresentable {
    var latitude: Double { get }
    var longitude: Double { get }
    /// - Note: This property is not supported by all navigation apps.
    var name: String? { get }
    var address: String? { get }
}

extension LocationRepresentable {
    internal var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude,
                                                                       longitude: self.longitude),
                                    addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }
    
    internal var coordString: String {
        return "\(self.latitude),\(self.longitude)"
    }
}

extension Navigator.Location: LocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }
    
    public var longitude: Double {
        return self.coordinate.longitude
    }
}

internal class NavigatorLocation: LocationRepresentable{
    var coords: CLLocationCoordinate2D
    var _name: String
    var _address: String
    
    init(coords: CLLocationCoordinate2D, name: String, address: String){
        self.coords = coords
        self._name = name
        self._address = address
    }
    
    public var latitude: Double {
        return self.coords.latitude
    }
    
    public var longitude: Double {
        return self.coords.longitude
    }
    
    public var name: String? {
        return self._name
    }
    
    public var address: String? {
        return self._address
    }
}
// MARK: CoreLocation helpers

extension CLLocation: LocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }
    
    public var longitude: Double {
        return self.coordinate.longitude
    }
    
    public var name: String? {
        return nil
    }
    
    public var address: String? {
        return nil
    }
}

extension CLLocationCoordinate2D: LocationRepresentable {
    public var name: String? {
        return nil
    }
    
    public var address: String? {
        return nil
    }
}
