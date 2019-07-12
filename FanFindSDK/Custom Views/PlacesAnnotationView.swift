//
//  PlacesAnnotationView.swift
//  LE
//
//  Created by Christopher Woolum on 12/28/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import Foundation
import MapKit

class PlacesAnnotationView: MKAnnotationView {
    static let ReuseID = "placesAnnotation"
   
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        
        guard let place = annotation as? Place
            else { return }
        
        image = DrawingTools.setupGradientLayer(unspecifiedCount: place.totalCount, isSelected: isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let place = annotation as? Place
            else { return }
        
        image = DrawingTools.setupGradientLayer(unspecifiedCount: place.totalCount , isSelected: selected)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        clusteringIdentifier = nil
        backgroundColor = .clear
        displayPriority = .required
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
}
