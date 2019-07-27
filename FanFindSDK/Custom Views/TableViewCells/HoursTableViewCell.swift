//
//  HoursTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    @IBOutlet var dayOfWeek: UILabel!
    @IBOutlet private var startTimeLabel: UILabel!
    @IBOutlet private var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTime(startTime: Date, endTime: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        startTimeLabel.text = dateFormatter.string(from: startTime)
        endTimeLabel.text = dateFormatter.string(from: endTime)
    }
    
}
