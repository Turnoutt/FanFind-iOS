//
//  FacetSelector.swift
//  FanFind
//
//  Created by Christopher Woolum on 12/29/19.
//

import Foundation

internal class FacetSelector: UISwitch {
    public var facetValue: String
    public var facetName: String
    
    init(
        value: String,
        facetName: String){
        self.facetValue = value
        self.facetName = facetName
        
        super.init(frame: .zero)
        
        self.onTintColor = FanFindConfiguration.primaryColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
