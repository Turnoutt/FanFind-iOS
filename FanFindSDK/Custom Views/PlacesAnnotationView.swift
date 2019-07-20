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
        
        
        place.logoUrl = "https://banner2.kisspng.com/20180713/jq/kisspng-bubba-gump-shrimp-company-bubba-gump-shrimp-co-re-forest-gump-5b48eb72147cc4.2970315615315055220839.jpg"
        
        if(place.isSponsoredPlace){
            if let logoUrl = place.logoUrl {
                DispatchQueue.main.async {
                    let brandsImageView = UIImageView()
                    brandsImageView.frame = CGRect(x: 8, y: 24, width: 50, height: 50)
                    brandsImageView.imageFromURL(urlString: logoUrl)
                    self.addSubview(brandsImageView)
                    self.bringSubviewToFront(brandsImageView)
                }
            }
        }
        
        redrawCircle(isSelected)
    }

    fileprivate func redrawCircle(_ selected: Bool) {
        if let place = annotation as? Place{
            if(place.isSponsoredPlace){
                image = DrawingTools.drawSponsoredPlace(wholeColor: UIColor.white, isSelected: false, count: Int(place.totalCount))
                
            } else{
                image = DrawingTools.setupGradientLayer(unspecifiedCount: place.totalCount , isSelected: selected)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        redrawCircle(selected)
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
