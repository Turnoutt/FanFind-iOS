//
//  PlacesAnnotationView.swift
//  LE
//
//  Created by Christopher Woolum on 12/28/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import Foundation
import MapKit

internal class PlacesAnnotationView: MKAnnotationView {
    static let ReuseID = "placesAnnotation"
    
    let brandsImageView = UIImageView()

    
    var bundle = Bundle(for: PlacesAnnotationView.self)
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .required
        
        guard let place = annotation as? Place
            else { return }
         
        self.brandsImageView.frame = CGRect(x: 7, y: 22, width: 17, height: 17)
        
        if(place.isSponsoredPlace){
            if let logoUrl = place.logoUrl {
                DispatchQueue.main.async {
                    self.brandsImageView.imageFromURL(urlString: logoUrl)
                    self.addSubview(self.brandsImageView)
                    self.bringSubviewToFront(self.brandsImageView)
                }
            }
        }else{
            if(place.nearByPlace?.primaryCategory == "Full-Service Restaurants"){
                let restaurantImage: UIImage?
                
                if FanFindConfiguration.currentTheme == .Dark {
                    restaurantImage = UIImage(named: "Restaurant_Dark", in: self.bundle, compatibleWith: nil)
                    
                } else {
                    restaurantImage = UIImage(named: "Restaurant_Light", in: self.bundle, compatibleWith: nil)
                }
                self.brandsImageView.image = restaurantImage
            }else{
                let barImage: UIImage?
                if FanFindConfiguration.currentTheme == .Dark {
                    barImage = UIImage(named: "Bar_Dark", in: self.bundle, compatibleWith: nil)
                } else {
                    barImage = UIImage(named: "Bar_Light", in: self.bundle, compatibleWith: nil)
                }
                self.brandsImageView.image = barImage
            }
            
            self.addSubview(self.brandsImageView)
            self.bringSubviewToFront(self.brandsImageView)
        }
        
        redrawCircle(isSelected)
    }

    fileprivate func redrawCircle(_ selected: Bool) {
        if let place = annotation as? Place{
            if(place.isSponsoredPlace){
                image = DrawingTools.drawNewBadge(wholeColor: UIColor.white, isSelected: selected, count: Int(place.totalCount))
                
            } else{
                image = DrawingTools.drawNewBadge(wholeColor: UIColor.white, isSelected: selected, count: Int(place.totalCount))
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
