//
//  HoursHeaderTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/17/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class HoursHeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet private var openClosed: UILabel!
    @IBOutlet private var openUntil: UILabel!
    
    private let border = CALayer()
    private let nextDateFormatter = DateFormatter()
    private let closesDateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nextDateFormatter.dateFormat = "EEEE, MMM d h:mm a"
        closesDateFormatter.dateFormat = "h:mm a"
        
        addBottomBorderWithColor(color: UIColor.init(hex: 0xD3D2D2, alpha: 1.0))
    }
    
    fileprivate func processClosed(_ hours: [BusinessHour], _ nextIndex: Int) {
        DispatchQueue.main.async {
            self.openClosed.text = "CLOSED"
            self.openClosed.textColor = FanFindConfiguration.closedColor
            
            let nextHours = hours[nextIndex]
            
            
            self.openUntil.text = "Opens " + self.nextDateFormatter.string(from: nextHours.startTime)
        }
    }
    
    fileprivate func addBottomBorderWithColor(color: UIColor) {
        border.backgroundColor = color.cgColor
        
        self.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
    }
    
    func setHours(hours: Array<BusinessHour>){
        if(hours.count == 0){
            return
        }
        
        let todaysDate = Date()
        let dayNumberOfWeek = Date.init().dayNumberOfWeek()!
        
        if let hoursForCurrentDay = hours.first(where: { (hour) -> Bool in
            hour.dayNumberOfWeek == dayNumberOfWeek
        }) {
            let startTime = hoursForCurrentDay.startTime
            var endTime = hoursForCurrentDay.endTime
            
            if(hoursForCurrentDay.endTime < hoursForCurrentDay.startTime){
                endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
            }
            
            if(todaysDate > startTime && todaysDate < endTime ){
                DispatchQueue.main.async {
                    self.openClosed.text = "OPEN"
                    self.openUntil.text = "Closes " + self.closesDateFormatter.string(from: hoursForCurrentDay.endTime)
                }
            }else{
                let currentIndex = hours.firstIndex { (hour) -> Bool in
                    hour.dayNumberOfWeek == hoursForCurrentDay.dayNumberOfWeek && hour.startTime == hoursForCurrentDay.startTime
                }
                
                // Check if the restaurant will still open today
                if todaysDate < hoursForCurrentDay.startTime {
                    self.openClosed.text = "CLOSED"
                    self.openClosed.textColor = FanFindConfiguration.closedColor
                    
                    self.openUntil.text = "Opens " + self.closesDateFormatter.string(from: hoursForCurrentDay.startTime)
                } else {
                    // Try for a later day
                    if(currentIndex! >= (hours.count - 1)){
                        processClosed(hours, 0)
                    }else{
                        processClosed(hours, currentIndex! + 1)
                    }
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
