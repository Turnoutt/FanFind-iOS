//
//  ValidationProblemDetails.swift
//  FanFind
//
//  Created by Christopher Woolum on 4/9/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import Foundation

class ValidationProblemDetails : Decodable {
    var detail: String
    
    var status: String
    
    var title: String
}
