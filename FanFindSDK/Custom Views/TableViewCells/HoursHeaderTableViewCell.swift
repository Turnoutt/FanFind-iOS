//
//  HoursHeaderTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class HoursHeaderTableViewCell: UITableViewCell {
    @IBOutlet private var openClosed: UILabel!
    @IBOutlet private var openUntil: UILabel!
    
    private let nextDateFormatter = DateFormatter()
    private let closesDateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nextDateFormatter.dateFormat = "EEEE, MMM d h:mma"
        closesDateFormatter.dateFormat = "h:mma"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func processClosed(_ hours: [BusinessHour], _ nextIndex: Int) {
        openClosed.text = "CLOSED"
        
        let nextHours = hours[nextIndex]

        openUntil.text = "Opens " + nextDateFormatter.string(from: nextHours.startTime)
    }
    
    func setHours(hours: Array<BusinessHour>){
        if(hours.count == 0){
            return
        }
        
        // Need to offset this since the API returns 0 as Sunday
        let todaysDate = Date.init()
        let dayNumberOfWeek = Date.init().dayNumberOfWeek()! - 1
        
        if let hoursForCurrentDay = hours.first(where: { (hour) -> Bool in
            hour.dayNumberOfWeek == dayNumberOfWeek
        }) {
            let calendar = Calendar.current
            
            // Build Start Time
            let startHour = calendar.component(.hour, from: hoursForCurrentDay.startTime)
            let startMinutes = calendar.component(.minute, from: hoursForCurrentDay.startTime)
            
            let startDate = Calendar.current.date(bySettingHour: startHour, minute: startMinutes, second: 0, of: Date())!
            
            // Build End Time
            let endHour = calendar.component(.hour, from: hoursForCurrentDay.endTime)
            let endMinutes = calendar.component(.minute, from: hoursForCurrentDay.endTime)
            
            let endDate = Calendar.current.date(bySettingHour: endHour, minute: endMinutes, second: 0, of: Date())!
            
            if(todaysDate>startDate && todaysDate<endDate ){
                openClosed.text = "OPEN"
                openUntil.text = "Closes " + closesDateFormatter.string(from: endDate)
            }else{
                let currentIndex = hours.firstIndex { (hour) -> Bool in
                    hour.dayNumberOfWeek == hoursForCurrentDay.dayNumberOfWeek && hour.startTime == hoursForCurrentDay.startTime
                }
                
                if(currentIndex! >= (hours.count - 1)){
                    processClosed(hours, 0)
                }else{
                    processClosed(hours, currentIndex! + 1)
                }
            }
        }else{
            // There were no hours for the current day. Find the next ones
            let firstIndex = hours.firstIndex(where: { (hour) -> Bool in
                hour.dayNumberOfWeek > dayNumberOfWeek
            })
            
            // If still nil, let's loop back around and select the first day
            if let firstIndex = firstIndex {
                processClosed(hours, firstIndex)
                
            } else{
                processClosed(hours, 0)
            }
            
        }
    }
    
}
