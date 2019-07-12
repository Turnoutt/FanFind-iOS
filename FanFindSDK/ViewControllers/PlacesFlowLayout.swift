//
//  PlacesFlowLayout.swift
//  LE
//
//  Created by Luis Garcia on 8/22/17.
//  Copyright © 2017 locateeveryone. All rights reserved.
//

import UIKit

class PlacesFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = UICollectionView.ScrollDirection.horizontal
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity _: CGPoint) -> CGPoint {
        var offsetAdustment = MAXFLOAT
        let horizontalCenter = proposedContentOffset.x + (collectionView?.bounds.width)! / 2.0
        let proposedRect: CGRect = CGRect(x: proposedContentOffset.x,
                                          y: 0.0,
                                          width: (collectionView?.bounds.size.width)!,
                                          height: (collectionView?.bounds.size.height)!)

        let array = layoutAttributesForElements(in: proposedRect)

        for layoutAttributes in array! {
            let itemHorizontalCenter: CGFloat = layoutAttributes.center.x
            if fabsf(Float(itemHorizontalCenter - horizontalCenter)) < fabsf(offsetAdustment) {
                offsetAdustment = Float(itemHorizontalCenter - horizontalCenter)
            }
        }

        return CGPoint(x: CGFloat(Float(proposedContentOffset.x) + offsetAdustment), y: proposedContentOffset.y)
    }
}
