//
//  EventsTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class EventsTableViewCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var eventText: UILabel!
    @IBOutlet var eventDate: UILabel!
    
    var bundle = Bundle(for: EventsTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(FanFindConfiguration.currentTheme == .Light){
            icon.image = UIImage(named: "Events_Icon_Gray", in: self.bundle, compatibleWith: nil)
        }else{
            icon.image = UIImage(named: "Events_Icon_White", in: self.bundle, compatibleWith: nil)
        }
    }
    
    func setEvent(event: PlaceEvent){
        self.eventText.text = event.eventText
        
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = DateIntervalFormatter.Style.full
        formatter.timeStyle = DateIntervalFormatter.Style.short
        let dateRangeStr = formatter.string(from: event.startDate, to: event.endDate)
        
        self.eventDate.text = dateRangeStr
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
