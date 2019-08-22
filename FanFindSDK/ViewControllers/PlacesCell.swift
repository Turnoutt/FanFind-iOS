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
        
        guard let place = self.place?.nearByPlace else { return }
        DispatchQueue.main.async {
            self.placeInfoHeader.setPlace(place: place)
            
            if(place.primaryCategory == "Full-Service Restaurants"){
                self.imageView.image = UIImage(named: "restaurant", in: self.bundle, compatibleWith: nil)
            }else{
                self.imageView.image = UIImage(named: "bar", in: self.bundle, compatibleWith: nil)
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
