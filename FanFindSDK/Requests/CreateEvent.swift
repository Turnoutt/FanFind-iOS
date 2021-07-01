//
//  CreateEvent.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 9/3/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

internal struct CreateEvent: APIRequest {
    public typealias Response = NoReply
    
    public var resourceName: String {
        return "v1/analytics?eventType=" + self.eventType
    }
    
    public init(eventType: String, placeId: String){
        self.eventType = eventType
        self.placeId = placeId
    }
    
    let eventType: String
    let placeId: String
    
}
