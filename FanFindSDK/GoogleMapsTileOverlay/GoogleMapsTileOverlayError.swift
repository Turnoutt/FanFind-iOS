//
//  GoogleMapsTileOverlayError.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/11/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal enum GoogleMapsTileOverlayError: Error {
    
    case invalidJSON
    case failedToEncodeURL
    
}


extension GoogleMapsTileOverlayError: LocalizedError {
    
    internal var errorDescription: String? {
        switch self {
        case .invalidJSON:        return "JSON file is not valid"
        case .failedToEncodeURL:  return "Failed to encode URL with percentage encoding"
        }
    }
    
}
