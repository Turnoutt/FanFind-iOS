//
//  GoogleMapsURLStyleConverter.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/11/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class GoogleMapsURLStyleConverter {
    
    class func convertedStyleFrom(styles: [GoogleMapsStyle]) -> String {
        return styles.map { $0.convertedStyle() }.joined(separator: ",")
    }
    
    class func encodedURLStringFrom(urlString: String) throws -> String {
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw GoogleMapsTileOverlayError.failedToEncodeURL
        }
        return encodedString.replacingOccurrences(of: ":", with: "%3A")
            .replacingOccurrences(of: ",", with: "%2C")
    }
    
}
