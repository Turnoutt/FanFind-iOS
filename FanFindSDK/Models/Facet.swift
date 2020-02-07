//
//  Facet.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 12/28/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal class Facet: Decodable {
    public var from: String?
    public var to: String?
    public var value: String
    public var count: CLong?
    
    init(
        from: String?,
        to: String?,
        value: String,
        count: CLong?
    ){
        self.from = from
        self.to = to
        self.value = value
        self.count = count ?? 0
    }
}
