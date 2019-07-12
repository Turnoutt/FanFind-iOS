//
//  PeopleLocationAnnotation.swift
//  FanFind
//
//  Created by Christopher Woolum on 7/9/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation
import MapKit

class PeopleLocationAnnotation: NSObject, MKAnnotation {
    public static func == (lhs: PeopleLocationAnnotation, rhs: PeopleLocationAnnotation) -> Bool {
        return lhs.geoHash == rhs.geoHash
            && lhs.latestUpdateDate == rhs.latestUpdateDate
    }
    
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(geoHash)
        return hasher.finalize()
    }
    
    var maleCount: Int64
    var femaleCount: Int64
    var unspecifiedCount: Int64
    var coordinate: CLLocationCoordinate2D
    var latestUpdateDate: Date
    var geoHash: String
    
    var totalCount: Int64 {
        return femaleCount + maleCount + unspecifiedCount
    }
    
    init(maleCount: Int64, femaleCount: Int64, unspecifiedCount: Int64, coordinate: CLLocationCoordinate2D, latestUpdateDate: Date, geoHash: String) {
        self.maleCount = maleCount
        self.femaleCount = femaleCount
        self.unspecifiedCount = unspecifiedCount
        self.coordinate = coordinate
        self.latestUpdateDate = latestUpdateDate
        self.geoHash = geoHash
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let annot = object as? PeopleLocationAnnotation {
            // Add your defintion of equality here. i.e what determines if two Annotations are equal.
            return annot.geoHash == geoHash && annot.latestUpdateDate == latestUpdateDate
        }
        return false
    }
}
