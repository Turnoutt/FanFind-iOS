//
//  OSLog.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 8/7/21.
//  Copyright © 2021 Turnoutt Inc. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let map = OSLog(subsystem: subsystem, category: "Map")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let location = OSLog(subsystem: subsystem, category: "Location")
}
