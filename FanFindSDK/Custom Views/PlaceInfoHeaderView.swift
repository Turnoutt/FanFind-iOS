//
//  PlaceInfoHeaderView.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/25/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

@IBDesignable
class PlaceInfoHeaderView: UIStackView {
    var businessNameLabel = ThemedUILabel()
    var categoryNameLabel = ThemedUILabel()
    var addressLabel = ThemedUILabel()
    var phoneLabel = ThemedUILabel()
    var websiteLabel = ThemedUILabel()
    
    @IBInspectable
    var showExtendedDetails : Bool = false {
        didSet {
            print("This was just set")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutLabels()
    }
    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        
    }
    
    open override func prepareForInterfaceBuilder() {
        businessNameLabel.text = "Business Name"
    }
    
    func setPlace(place: NearByPlace){
        businessNameLabel.text = place.name
        categoryNameLabel.text = place.primaryCategory
        addressLabel.text = place.fullAddress
        
        self.sizeToFit()
        self.layoutIfNeeded()
    }
    
    func setPlaceDetails(place: NearByPlaceDetails){
        phoneLabel.text = place.formattedPhoneNumber
        
        if showExtendedDetails {
            
            self.addArrangedSubview(phoneLabel)
            self.addArrangedSubview(websiteLabel)
        }
        
        self.sizeToFit()
        self.layoutIfNeeded()
    }
    
    private func layoutLabels() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        
        businessNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        categoryNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        addressLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        
        categoryNameLabel.insets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        phoneLabel.font = phoneLabel.font.withSize(14)
        
        websiteLabel.font = websiteLabel.font.withSize(14)
        
        self.addArrangedSubview(businessNameLabel)
        self.addArrangedSubview(categoryNameLabel)
        self.addArrangedSubview(addressLabel)
        
        if showExtendedDetails {
            
            self.addArrangedSubview(phoneLabel)
            self.addArrangedSubview(websiteLabel)
        }
        
    }
    
}
