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
    func showGenderRequiredModal(_ frame: CGRect, _ view: UIView)
}

class PlacesCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var navigateButton: UIButton!
    @IBOutlet var numbers: PeopleCountNumbers!
    @IBOutlet var poweredBy: UIImageView!
    
    @IBAction func navigateClicked(_ sender: UIButton) {
        
        delegate?.showGenderRequiredModal(sender.frame, self.contentView)
    }
    
    @IBOutlet var pointOfInterestLabel: UILabel! {
        didSet {
            pointOfInterestLabel.text = nil
        }
    }

    @IBOutlet var addressLabel: UILabel! {
        didSet {
            addressLabel.text = nil
        }
    }
    
    @IBOutlet var categoryLabel: UILabel!{
        didSet{
            categoryLabel.text = nil
        }
    }
    
    var place: Place?
    var delegate: PlacesCellDelegate?
    var bundle = Bundle(for: PlacesCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(zoomOnPlace(sender:)))
    }

    func configureWith(place: Place?) -> Self {
        
        self.numbers.setTotals(maleCount: 0, femaleCount: 0, neutralCount: place!.totalCount)
        self.pointOfInterestLabel.text = place?.name
        self.addressLabel.text = place?.address
        
        self.place = place
        
        self.populateImagePager()
        return self
    }

    func populateImagePager() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        guard let place = self.place?.nearByPlace else { return }
        DispatchQueue.main.async {
            let address1 = place.address1 ?? ""
            let address2 = place.address2
            self.addressLabel.text = address1 + " " + address2 + " " + place.cityName + ", " + place.stateCode
            
            if(place.primaryCategory == "Full-Service Restaurants"){
                self.imageView.image = UIImage(named: "restaurant", in: self.bundle, compatibleWith: nil)
            }else{
                self.imageView.image = UIImage(named: "bar", in: self.bundle, compatibleWith: nil)
            }
            
            self.categoryLabel.text = place.primaryCategory
            
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
