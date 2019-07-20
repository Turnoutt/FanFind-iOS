//
//  FanFindConfiguration.swift
//  FanFind
//
//  Created by Christopher Woolum on 7/8/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

public enum FanFindConfiguration {
    enum Themes: String{
        case Light = "Light"
        case Dark = "Dark"
    }
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let primaryColor = "FANFIND_PRIMARY_COLOR"
            static let secondaryColor = "FANFIND_SECONDARY_COLOR"
            static let apiKey = "FANFIND_API_KEY"
            static let theme = "FANFIND_THEME"
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
    
    static let theme: Themes = {
         let theme = FanFindConfiguration.infoDictionary[Keys.Plist.theme] as? String
        
        return (theme == nil) ? Themes.Light : Themes(rawValue: theme!)!
    }()
    
    static let textColor : UIColor = {
        if FanFindConfiguration.theme == Themes.Dark {
            return UIColor(named: "TextPrimaryDark", in: Bundle(for: PlacesCell.self), compatibleWith: nil)!
        }
        
        return UIColor(named: "TextPrimary", in: Bundle(for: PlacesCell.self), compatibleWith: nil)!
    }()
    
    static let backgroundColor : UIColor = {
        if FanFindConfiguration.theme == Themes.Dark {
            return UIColor(named: "ViewBackgroundDark", in: Bundle(for: PlacesCell.self), compatibleWith: nil)!
        }
        
        return UIColor.white
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
