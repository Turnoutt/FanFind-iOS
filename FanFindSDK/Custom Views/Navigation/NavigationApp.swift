//
//  NavigationApp.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/27/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

extension Navigator {
    public enum NavigationApp: String, CaseIterable {
        case appleMaps
        case googleMaps // https://developers.google.com/maps/documentation/ios/urlscheme
        
        case lyft
        case uber
        case waze
        
        @available(*, unavailable, renamed: "allCases")
        static var all: [NavigationApp] {
            fatalError()
        }
        
        var urlScheme: String {
            switch self {
            case .appleMaps: return "" // Uses System APIs, so this is just a placeholder
            case .googleMaps: return "comgooglemaps://"
            case .lyft: return "lyft://"
            case .uber: return "uber://"
            case .waze: return "waze://"
            }
        }
        
        public var name: String {
            switch self {
            case .appleMaps: return "Apple Maps"
            case .googleMaps: return "Google Maps"
            case .lyft: return "Lyft"
            case .uber: return "Uber"
            case .waze: return "Waze"
            }
        }
        
        public var image: String {
            switch self {
            case .appleMaps: return "apple-maps"
            case .googleMaps: return "google-maps-1"
            case .lyft: return "lyft-1"
            case .uber: return "uber-1"
            case .waze: return "waze"
            }
        }
        
        /// Validates if an app supports a mode. The given mode is optional and this defaults to `true`
        /// if the mode is `nil`.
        func supports(mode: Mode?) -> Bool {
            guard let mode = mode else {
                return true
            }
            
            switch self {
            case .appleMaps:
                return mode != .bicycling
            case .googleMaps:
                return true
            case .lyft, .uber:
                return mode == .taxi
            case .waze:
                return mode == .driving
            }
        }
        
        // swiftlint:disable cyclomatic_complexity
        // swiftlint:disable function_body_length
        /// Build a query string for this app using the parameters. Returns nil if a mode is specified,
        /// but not supported by this app.
        func queryString(origin: LocationRepresentable?,
                         destination: LocationRepresentable,
                         mode: Mode?) -> String? {
            guard self.supports(mode: mode) else {
                // if a mode is present, validate if the app supports it, otherwise we don't care
                return nil
            }
            
            var parameters = [String: String]()
            
            switch self {
            case .appleMaps:
                // Apple Maps gets special handling, since it uses System APIs
                return nil
            case .googleMaps:
                parameters.set("saddr", origin?.coordString)
                parameters.set("daddr", destination.coordString)
                
                let modeIdentifier = mode?.identifier(for: self) as? String
                parameters.set("directionsmode", modeIdentifier)
                return "\(self.urlScheme)maps?\(parameters.urlParameters)"
            case .lyft:
                parameters.set("pickup[latitude]", origin?.latitude)
                parameters.set("pickup[longitude]", origin?.longitude)
                parameters.set("destination[latitude]", destination.latitude)
                parameters.set("destination[longitude]", destination.longitude)
                return "\(self.urlScheme)ridetype?id=lyft&\(parameters.urlParameters)"
            case .uber:
                parameters.set("action", "setPickup")
                if let origin = origin {
                    parameters.set("pickup[latitude]", origin.latitude)
                    parameters.set("pickup[longitude]", origin.longitude)
                } else {
                    parameters.set("pickup", "my_location")
                }
                parameters.set("dropoff[latitude]", destination.latitude)
                parameters.set("dropoff[longitude]", destination.longitude)
                parameters.set("dropoff[nickname]", destination.name)
                return "\(self.urlScheme)?\(parameters.urlParameters)"
            case .waze:
                // swiftlint:disable:next line_length
                return "\(self.urlScheme)?ll=\(destination.latitude),\(destination.longitude)&navigate=yes"
            }
        }
        // swiftlint:enable function_body_length
        // swiftlint:enable cyclomatic_complexity
    }
}
