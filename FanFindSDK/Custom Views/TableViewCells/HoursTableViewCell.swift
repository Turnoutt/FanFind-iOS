//
//  HoursTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class HoursTableViewCell: UITableViewCell {
    @IBOutlet var dayOfWeek: UILabel!
    @IBOutlet private var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTime(startTime: Date, endTime: Date, dayNumberOfWeek: Int){
        
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = DateIntervalFormatter.Style.none
        formatter.timeStyle = DateIntervalFormatter.Style.short
        let dateRangeStr = formatter.string(from: startTime, to: endTime)
        
        endTimeLabel.text = dateRangeStr
        
        let currentDayNumberOfWeek = Date.init().dayNumberOfWeek()!
        
        if dayNumberOfWeek == currentDayNumberOfWeek {
            dayOfWeek.font = UIFont.boldSystemFont(ofSize: 14.0)
            endTimeLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
    }
    
}
