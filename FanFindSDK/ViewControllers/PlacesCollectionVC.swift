//
//  PlacesCollectionVC.swift
//  LE
//
//  Created by Luis Garcia on 8/22/17.
//  Copyright © 2017 locateeveryone. All rights reserved.
//

import UIKit
import MapKit

protocol PlacesCenterCellDelegate {
    func collectionViewStoppedAt(place: Place)
    func tappedOnPlace(place: Place)
    func collectionViewChangedHeight()
}

class PlacesCollectionVC: UIViewController, UIPopoverPresentationControllerDelegate {
    func closeView() {
        dismiss(animated: false)
    }
    
    @IBOutlet var collectionView: UICollectionView!

    fileprivate var height: CGFloat = 0
    fileprivate var cellWidth: CGFloat = 0
    fileprivate var isCellFullHeight = true

    var delegate: PlacesCenterCellDelegate?
    var placeArray = [Place]()

    // MARK: - Init

    init(height: CGFloat) {
        super.init(nibName: "PlacesCollectionVC", bundle: Bundle(for: PlacesCollectionVC.self))
        
        self.height = height - 30
        cellWidth = height * 1.02
        isCellFullHeight = true
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController delegate methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = UIView.AutoresizingMask.flexibleHeight

        configureCollectionView()
        addGesturesToCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(incredibleShrinkingAct), name: Notification.Name(rawValue: "ShrinkPlacesView"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func configureCollectionView() {
        collectionView.register(UINib(nibName: "PlacesCell", bundle: Bundle(for: PlacesCell.self)),
                                forCellWithReuseIdentifier: "placesCell")
        collectionView.register(UINib(nibName: "PlacesShortenedCell", bundle: Bundle(for: PlacesShortenedCell.self)),
                                forCellWithReuseIdentifier: "shortPlacesCell")
        collectionView.collectionViewLayout = PlacesFlowLayout()
    }

    func addGesturesToCollectionView() {
        let swipeDownGesture = UISwipeGestureRecognizer()
        swipeDownGesture.addTarget(self, action: #selector(shrinkCollectionView(sender:)))
        swipeDownGesture.direction = .down
        collectionView.addGestureRecognizer(swipeDownGesture)

        let swipeUpGesture = UISwipeGestureRecognizer()
        swipeUpGesture.addTarget(self, action: #selector(growCollectionView(sender:)))
        swipeUpGesture.direction = .up
        collectionView.addGestureRecognizer(swipeUpGesture)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(selectPlace(sender:)))
       
        collectionView.addGestureRecognizer(tapGesture)
    }

    @objc func incredibleShrinkingAct() {
        if isCellFullHeight {
            isCellFullHeight = false
            collectionView.reloadData()
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = CGRect(x: 0,
                                         y: (self.parent?.view.frame.height)! - (self.parent?.view.frame.height)! * 0.12,
                                         width: self.view.frame.width,
                                         height: (self.parent?.view.frame.height)! * 0.12)
                self.delegate?.collectionViewChangedHeight()
                // NotificationCenter.default.post(name: Notification.Name(rawValue: "PlacesViewHeightDidChange"), object: nil)
            }, completion: { _ in
                self.isCellFullHeight = false
                self.collectionView.reloadData()
            })
        }
    }

    @objc func shrinkCollectionView(sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            if isCellFullHeight {
                isCellFullHeight = false
                collectionView.reloadData()
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: (self.parent?.view.frame.height)! - (self.parent?.view.frame.height)! * 0.12,
                                             width: self.view.frame.width,
                                             height: (self.parent?.view.frame.height)! * 0.12)
                    self.delegate?.collectionViewChangedHeight()
                    // NotificationCenter.default.post(name: Notification.Name(rawValue: "PlacesViewHeightDidChange"), object: nil)
                }, completion: { _ in
                    self.isCellFullHeight = false
                    self.collectionView.reloadData()
                })
            }
        }
    }

    @objc func growCollectionView(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            if !isCellFullHeight {
                animateCellGrowth()
            }
        }
    }
    
    @objc func selectPlace(sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            let cell = self.collectionView?.cellForItem(at: indexPath) as? PlacesCell
            if let placeId=cell?.place?.placeId{
                DispatchQueue.main.async {
                    ProgressView.shared.showProgressView()
                    
                }
                
                FanFindClient.shared.getPlaceDetails(placeId: placeId) { (placeDetails, err) in
                    DispatchQueue.main.async {
                        self.present(PlaceDetailsViewController(place: cell!.place!.nearByPlace!, placeDetails: placeDetails!), animated: true)
                        
                        ProgressView.shared.hideProgressView()
                    }
                    
                    
                }
            }
        }
        
    }

    func animateCellGrowth() {
        isCellFullHeight = true
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.frame.size.height = self.height
            self.view.frame.origin.y = (self.parent?.view.frame.height)! - self.height
            self.delegate?.collectionViewChangedHeight()
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlacesViewHeightDidChange"), object: nil)
        }, completion: { _ in
        })
    }

    func showNavigationModal(_ frame: CGRect, _ view: UIView, location: LocationRepresentable) {
        Navigator.presentPicker(destination: location, presentOn: self.parent!)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
}

extension PlacesCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, PlacesCellDelegate {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == self.collectionView {
            return placeArray.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCellFullHeight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placesCell", for: indexPath) as! PlacesCell
            cell.delegate = self
            let currentPlace = placeArray[indexPath.row]
            
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            if currentPlace.isSponsoredPlace{
                cell.layer.shadowColor = FanFindConfiguration.primaryColor.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 10.0)
                cell.layer.shadowRadius = 10.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            }
            return cell.configureWith(place: currentPlace)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shortPlacesCell", for: indexPath) as! PlacesShortenedCell
            return cell.configureWith(place: placeArray[indexPath.row])
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let s = scrollView.contentOffset.x
        let s2 = CGPoint(x: s, y: 0)
        if isCellFullHeight {
            let indexArray = collectionView.indexPathsForVisibleItems
            if indexArray.count < 3 {
                centerCell(place: placeArray[0])
            }
            for index in indexArray {
                let cell = collectionView.cellForItem(at: index) as! PlacesCell
                let cellRect = cell.convert(cell.bounds, to: collectionView)

                let centerRect = CGRect(origin: CGPoint(x: cellRect.origin.x, y: 0),
                                        size: CGSize(width: cell.frame.width, height: cell.frame.height))

                if centerRect.contains(s2) {
                    let indexPath = IndexPath(row: index.row + 1, section: index.section)
                    centerCell(place: placeArray[indexPath.row])
                    break
                }
            }
        } else {
            let indexArray = collectionView.indexPathsForVisibleItems
            if indexArray.count < 3 {
                centerCell(place: placeArray[0])
            }
            for index in indexArray {
                let cell = collectionView.cellForItem(at: index) as! PlacesShortenedCell
                let cellRect = cell.convert(cell.bounds, to: collectionView)

                let centerRect = CGRect(origin: CGPoint(x: cellRect.origin.x, y: 0),
                                        size: CGSize(width: cell.frame.width, height: cell.frame.height))

                if centerRect.contains(s2) {
                    let indexPath = IndexPath(row: index.row + 1, section: index.section)
                    centerCell(place: placeArray[indexPath.row])
                    break
                }
            }
        }
    }

    func centerCell(place: Place) {
        delegate?.collectionViewStoppedAt(place: place)
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        if !isCellFullHeight {
            animateCellGrowth()
        }
    }

    func didTapOnPlace(place: Place) {
        delegate?.tappedOnPlace(place: place)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        if isCellFullHeight {
            return CGSize(width: height * 1.02, height: height)
        } else {
            let newHeight = (parent?.view.frame.height)! * 0.12
            return CGSize(width: cellWidth, height: newHeight)
        }
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return CGFloat(0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        let cellSpace = view.frame.width * 0.08
        return CGFloat(cellSpace)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        let screenCenter = collectionView.frame.width / 2
        let cellHalfWidthValue = cellWidth / 2
        let leftMargin = screenCenter - cellHalfWidthValue
        return UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: leftMargin)
    }
}
