//
//  FacetTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 1/5/20.
//  Copyright © 2020 Turnoutt Inc. All rights reserved.
//

import UIKit

internal class FacetTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var facetSelector: UISwitch!
    
    var facets: [FacetResponse] = []
    var selectedFacets: [String: [String]] = [:]
    
    var facetName: String?
    var facetValue: String?
    var count: Int?
    var delegate: FacetChangeHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        facetSelector.onTintColor = FanFindConfiguration.primaryColor
    }
    
    func setFacetData(facets: [FacetResponse], selectedFacets: [String: [String]]){
        self.facets = facets
        self.selectedFacets = selectedFacets
    }
    
    @IBAction func selectionChanged(_ sender: UISwitch) {
        
        guard let facetName = facetName else { return }
        
        if (selectedFacets[facetName] == nil){
            selectedFacets[facetName] = []
        }
        
        if(sender.isOn){
            selectedFacets[facetName]?.append(facetValue!)
        } else {
            selectedFacets[facetName]?.removeAll { $0 == facetValue! }
        }
        
        self.delegate?.updateSelectedFacets(selectedFacets: selectedFacets)
    }
    
    func setValues(facetName: String, facetValue: String, count: Int){
        self.facetName = facetName
        self.facetValue = facetValue
        self.count = count
        
        if let facetName = self.facetName, let facetValue = self.facetValue {
            label.text = facetValue // + " (" + String(count ) + ")"
            
            if selectedFacets[facetName]?.firstIndex(of: facetValue) ?? -1 > -1 {
                facetSelector.setOn(true, animated: true)
            } else {
                facetSelector.setOn(false, animated: true)
            }
        }
    }
    
}
