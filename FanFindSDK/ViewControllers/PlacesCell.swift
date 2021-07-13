//
//  PlacesCell.swift
//  LE
//
//  Created by Luis Garcia on 8/22/17.
//  Copyright © 2017 locateeveryone. All rights reserved.
//

import MapKit
import UIKit

protocol PlacesCellDelegate {
    func didTapOnPlace(place: Place)
    func showNavigationModal(_ frame: CGRect, _ view: UIView, location: LocationRepresentable)
}

internal class PlacesCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var navigateButton: UIButton!
    @IBOutlet var numbers: PeopleCountNumbers!
    @IBOutlet var poweredBy: UIImageView!
    @IBOutlet var dealsEventsIndicator: DealsEventsIndicator!
    @IBOutlet var placeInfoHeader: PlaceInfoHeaderView!
    
    @IBOutlet var logoImage: UIImageView!
    
    @IBAction func navigateClicked(_ sender: UIButton) {
        let locationCoords = CLLocationCoordinate2D(
            latitude: (self.place!.nearByPlace!.latitude)!,
            longitude: (self.place!.nearByPlace!.longitude)!
        )
        
        if let place = place{
            
            let location = NavigatorLocation(coords: locationCoords, name: place.nearByPlace?.name ?? "", address: place.address)
            
            delegate?.showNavigationModal(sender.frame, self.contentView, location: location)
        }
    }
    
    var place: Place?
    var delegate: PlacesCellDelegate?
    var bundle = Bundle(for: PlacesCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = FanFindConfiguration.backgroundColor
        
        numbers.translatesAutoresizingMaskIntoConstraints = false
        
        if FanFindConfiguration.currentTheme == .Dark {
            self.poweredBy.image = UIImage(named: "FanFindLogo", in: self.bundle, compatibleWith: nil)
        }
        
       self.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(zoomOnPlace(sender:)))
    }
    
    func configureWith(place: Place?) -> Self {
       
        
        self.numbers.setTotals(maleCount: 0, femaleCount: 0, neutralCount: place!.totalCount)
        
        self.place = place
        
        dealsEventsIndicator.hasDeals = place?.nearByPlace?.hasDeals ?? false
        dealsEventsIndicator.hasEvents = place?.nearByPlace?.hasEvents ?? false
        
        self.populateImagePager()
        
        return self
    }
    
    func populateImagePager() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.contentScaleFactor = 1.2
        
        let isSponsoredPlace = place?.isSponsoredPlace ?? false
        
        if isSponsoredPlace, let logoImageUrl = place?.logoUrl {
            logoImage.imageFromURL(urlString: logoImageUrl)
            logoImage.isHidden = false
        } else {
            logoImage.isHidden = true
        }
        
        guard let place = self.place?.nearByPlace else { return }
        DispatchQueue.main.async {
            self.placeInfoHeader.setPlace(place: place)
            
            if FanFindConfiguration.currentTheme == .Dark {
                self.imageView.backgroundColor = UIColor.init(hexString: "171717")
            }
            
            if(place.primaryCategory == "Full-Service Restaurants"){
                self.imageView.image = UIImage(named: "CafeHeader_" + FanFindConfiguration.currentTheme.rawValue, in: self.bundle, compatibleWith: nil)
            }else{
                self.imageView.image = UIImage(named: "BarHeader_" + FanFindConfiguration.currentTheme.rawValue, in: self.bundle, compatibleWith: nil)
            }
        }
    }
    
    func shrinkCollectionView() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ShrinkPlacesView"), object: nil)
    }
    
    @objc func zoomOnPlace(sender _: UITapGestureRecognizer) {
        guard let place = place else { return }
        delegate?.didTapOnPlace(place: place)
    }
    
    
}
