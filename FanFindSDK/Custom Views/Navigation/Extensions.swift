//
//  Extensions.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/27/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal extension String {
    var urlQuery: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

internal extension Dictionary where Key == String, Value == String {
    var urlParameters: String {
        return self
            .map {"\($0)=\($1.urlQuery ?? "")"}
            .sorted() // basically only needed so that the tests can be deterministic
            .joined(separator: "&")
    }
    
    mutating func set<T>(_ key: String, _ value: T?) {
        if let value = value {
            self[key] = "\(value)"
        }
    }
}
