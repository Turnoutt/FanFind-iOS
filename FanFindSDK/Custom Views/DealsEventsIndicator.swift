//
//  DealsEventsIndicator.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/24/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

@IBDesignable
internal class DealsEventsIndicator: UIView {
    private var _hasEvents = false
    var hasEvents: Bool {
        set(newVal){
            eventsImageView.isHidden = !newVal
            _hasEvents = newVal
        }
        get{
            return _hasEvents
        }
    }
    
    private var _hasDeals = false
    var hasDeals: Bool {
        set(newVal){
            dealsImageView.isHidden = !newVal
            _hasDeals = newVal
        }
        get{
            return _hasDeals
        }
    }
    
    var bundle = Bundle(for: DealsEventsIndicator.self)
    var dealsImage = UIImage(named: "Deals_Icon_Gray", in: Bundle(for: DealsEventsIndicator.self), compatibleWith: nil)
    var eventsImage = UIImage(named: "Events_Icon_Gray", in: Bundle(for: DealsEventsIndicator.self), compatibleWith: nil)
    var dealsImageView = UIImageView()
    var eventsImageView = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupImages()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImages()
    }
    
    func setupImages(){
        
        if(FanFindConfiguration.currentTheme == .Dark){
            dealsImage = UIImage(named: "Deals_Icon_White", in: self.bundle, compatibleWith: nil)
            eventsImage = UIImage(named: "Events_Icon_White", in: self.bundle, compatibleWith: nil)
        }
        
        dealsImageView = UIImageView(image: dealsImage!)
        dealsImageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        self.addSubview(dealsImageView)
        
        eventsImageView = UIImageView(image: eventsImage!)
        eventsImageView.frame = CGRect(x: 30, y: 0, width: 28, height: 28)
        self.addSubview(eventsImageView)
    }
    
}
