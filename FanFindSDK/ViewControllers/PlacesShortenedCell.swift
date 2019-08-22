//
//  PlacesShortenedCell.swift
//  LE
//
//  Created by Luis Garcia on 8/22/17.
//  Copyright © 2017 locateeveryone. All rights reserved.
//

import UIKit

internal class PlacesShortenedCell: UICollectionViewCell {
    @IBOutlet var directionsButton: UIButton!
    @IBOutlet var pointOfInterestLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    var place: Place?

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }

    func configureWith(place: Place?) -> Self {
        pointOfInterestLabel.text = place?.name
        addressLabel.text = place?.address
        self.place = place

        return self
    }
}
