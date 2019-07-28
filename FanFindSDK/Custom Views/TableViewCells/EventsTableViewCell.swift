//
//  EventsTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
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
        
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "EEEE, MMM d - h:mma"
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "h:mma"
        
        self.eventDate.text = startDateFormatter.string(from: event.startDate)+"-"+endDateFormatter.string(from: event.endDate)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
