//
//  FanFindConfiguration.swift
//  FanFind
//
//  Created by Christopher Woolum on 7/8/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

public enum FanFindConfiguration {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let primaryColor = "FANFIND_PRIMARY_COLOR"
            static let secondaryColor = "FANFIND_SECONDARY_COLOR"
            static let apiKey = "FANFIND_API_KEY"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        
        guard let apiKey = FanFindConfiguration.infoDictionary[Keys.Plist.apiKey] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        
        return apiKey
    }()
    
    static let primaryColor: UIColor = {
        
        guard let primaryColor = FanFindConfiguration.infoDictionary[Keys.Plist.primaryColor] as? String else {
            fatalError("Primary color not set in plist for this environment")
        }
        
        return UIColor(hexString: primaryColor)!
    }()
    
    static let secondaryColor: UIColor = {
        guard let secondaryColor = FanFindConfiguration.infoDictionary[Keys.Plist.secondaryColor] as? String else {
            fatalError("Secondary color not set in plist for this environment")
        }
        
        return UIColor(hexString: secondaryColor)!
    }()
}

internal extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
