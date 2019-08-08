//
//  FirstViewController.swift
//  SampleApp
//
//  Created by Christopher Woolum on 4/7/19.
//  Copyright © 2019 Turnoutt. All rights reserved.
//

import UIKit
import MapKit
import os

public class MapViewController: UIViewController {
    @IBOutlet var map: MKMapView!
    @IBOutlet var redoSearchButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    var fanFindClient = FanFindClient.shared
    var location:CLLocation? = nil
    var hasSearched = false
    var hasLoaded = false
    private var mapChangedFromUserInteraction = false
    var tileOverlay: GoogleMapsTileOverlay?
    
    @IBAction func onTapped(_ sender: UITapGestureRecognizer) {
        self.searchBar.endEditing(true)
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.map.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate var placesVC: PlacesCollectionVC?
    public var isLocationShowing = false
    fileprivate var placeArray: [Place]?
    
    @IBAction func redoSearchClicked(_ sender: Any) {
        self.searchBar.endEditing(true)
        loadPlaces()
    }
    
    public init() {
        super.init(nibName: "MapViewController", bundle: Bundle(for: MapViewController.self))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(nibName: "MapViewController", bundle: Bundle(for: MapViewController.self))
    }
    
    override public var shouldAutorotate: Bool{
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let jsonURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") else { return }
        
        if let tileOverlay = try? GoogleMapsTileOverlay(jsonURL: jsonURL) {
            tileOverlay.canReplaceMapContent = true
            map?.addOverlay(tileOverlay)
            
            self.tileOverlay = tileOverlay
        }
        
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        
        redoSearchButton.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        redoSearchButton.layer.masksToBounds =  false
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.layoutMargins = UIEdgeInsets(top: 50, left: 0, bottom: 220, right: 0)
        
        self.redoSearchButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10)
        self.redoSearchButton.layer.borderColor = UIColor.darkGray.cgColor
        
        if let coor = map.userLocation.location?.coordinate {
            map.setCenter(coor, animated: true)
        }
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        map.register(PlacesAnnotationView.self, forAnnotationViewWithReuseIdentifier: "placesViewReuseIdentitier")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        if(!hasLoaded){
            DispatchQueue.global(qos: .background).async {
                let center = CLLocationCoordinate2D(latitude: 34.0430, longitude: -118.2673)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                DispatchQueue.main.async {
                    self.map.setRegion(region, animated: true)
                }
                
                let span = region.span
                
                let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
                let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
                
                
                let metersInLatitude = loc1.distance(from: loc2)
                
                self.loadPlaces(center, metersInLatitude)
                
                self.hasLoaded = true
                
            }
        }
    }
    
    func loadPlaces(_ location: CLLocationCoordinate2D? = nil, _ distance: Double? = nil){
        let coord = location ?? self.map.centerCoordinate
        hasSearched = true
        
        DispatchQueue.main.async {
            self.redoSearchButton.isHidden = true
            ProgressView.shared.showProgressView()
            
            var radius = distance
            
            if( radius == nil){
                radius = self.map.currentRadius()
            }
            
            print(Int(radius!))
            
            self.fanFindClient.getNearbyPlaces(latitude: Float(coord.latitude), longitude: Float(coord.longitude), radius: Int(radius!), query: self.searchBar?.text, completion: { (places, innerErr) in
                if let places = places{
                    
                    let mappedPlaces = places.map({ (place) -> Place in
                        return Place(object: place)
                    })
                    
                    self.placeArray = LocationHelper().sort(places: mappedPlaces, byDistanceFrom: coord)
                    
                    DispatchQueue.main.sync {
                        self.map.removeAnnotations(self.map.annotations)
                        self.map.showAnnotations(self.placeArray!, animated: true)
                        
                        self.showPlacesViewWith(places: mappedPlaces)
                        
                        if places.count == 0{
                            self.showToast(message: "No results were returned.")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    ProgressView.shared.hideProgressView()
                }
            })
        }
    }
    
    func showPlacesViewWith(places: [Place]) {
        if isLocationShowing == false {
            isLocationShowing = true
            if placesVC == nil {
                let placesHeight = CGFloat(280)
                placesVC = PlacesCollectionVC(height: placesHeight)
                placesVC?.placeArray = places
                placesVC?.delegate = self
                
                placesVC?.view.frame = CGRect(x: 0,
                                              y: view.frame.height,
                                              width: view.frame.width,
                                              height: placesHeight)
                placesVC?.view.backgroundColor = UIColor.clear
                placesVC?.view.clipsToBounds = false
                
                addChild(placesVC!)
                didMove(toParent: self)
                
                view.addSubview((placesVC?.view)!)
                changeMapOptionConstraint(to: placesHeight + 20)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                    self.placesVC?.view.frame = CGRect(x: 0,
                                                       y: self.view.frame.height - placesHeight,
                                                       width: self.view.frame.width,
                                                       height: placesHeight)
                    
                }, completion: { _ in
                    
                    if let firstPlace = places.first {
                        self.setAnnotationAsSelected(firstPlace)
                    }
                    
                })
            }
        } else {
            placeArray = places
            
            if places.count == 0 {
                self.placesVC!.view.isHidden = true
            } else {
                self.placesVC!.view.isHidden = false
                placesVC?.setPlaces(places: places)
            }
        }
    }
    
    func centerOnPlace(place: Place) {
        let currentCL = CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude)
        if currentCL.distance(from: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)) > 20000 {
            if map.camera.altitude > 5000.00 {
                DispatchQueue.main.async {
                    self.setAnnotationAsSelected(place)
                    self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 2000), animated: false)
                }
            } else {
                DispatchQueue.main.async {
                    self.setAnnotationAsSelected(place)
                    self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 2000), animated: false)
                }
            }
        } else {
            if map.camera.altitude > 5000.00 {
                DispatchQueue.main.async {
                    self.setAnnotationAsSelected(place)
                    self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 2000), animated: false)
                }
            } else {
                DispatchQueue.main.async {
                    self.setAnnotationAsSelected(place)
                    self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 2000), animated: true)
                }
            }
        }
    }
    
    func centerOnSpecificPlace(place: Place) {
        placeArray = [place]
        map.removeAnnotations(map.annotations)
        if let places = self.placeArray {
            DispatchQueue.main.async {
                self.map.removeAnnotations(self.map.annotations)
                self.map.addAnnotations(places)
                self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 150), animated: false)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let place = annotation as? Place {
            return mapView.dequeueReusableAnnotationView(withIdentifier: PlacesAnnotationView.ReuseID) ??
                PlacesAnnotationView(annotation: place, reuseIdentifier: PlacesAnnotationView.ReuseID)
        }
        
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Place {
            //mapView.setCenter(annotation.coordinate, animated: true)
            guard let placesVC = self.placesVC else {  return }
            
            if let placeIndex = placesVC.placeArray.firstIndex(where: { $0.placeId == annotation.placeId }) {
                placesVC.collectionView.scrollToItem(at: IndexPath(row: placeIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        if mapViewRegionDidChangeFromUserInteraction() {
            redoSearchButton.isHidden = false
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if(self.location == nil){
                self.location = location
            }
        }
    }
}

extension MapViewController: PlacesCenterCellDelegate{
    func collectionViewStoppedAt(place: Place, focusOnPlace: Bool) {
        setAnnotationAsSelected(place)
        
        if(!focusOnPlace){
            return
        }
        
        DispatchQueue.main.async {
            if self.map.camera.altitude > 550 {
                self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: self.map.camera.altitude), animated: true)
            } else {
                self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 550), animated: true)
            }
        }
    }
    
    func tappedOnPlace(place: Place) {
        DispatchQueue.main.async {
            self.map.setCamera(MKMapCamera(lookingAtCenter: place.coordinate, fromEyeCoordinate: place.coordinate, eyeAltitude: 550), animated: true)
        }
    }
    
    func collectionViewChangedHeight() {
        placeViewDidShrink()
    }
    
    func placeViewDidShrink() {
        let newConstant = (placesVC?.view.frame.height)! + 15
        changeMapOptionConstraint(to: newConstant)
    }
    
    fileprivate func setAnnotationAsSelected(_ place: Place) {
        let annotationToSelect = map.annotations.first { (annotation) -> Bool in
            annotation.coordinate.latitude == place.coordinate.latitude &&
                annotation.coordinate.longitude == place.coordinate.longitude
        }
        
        if annotationToSelect != nil {
            map.selectAnnotation(annotationToSelect!, animated: true)
        }
    }
    
    func changeMapOptionConstraint(to constant: CGFloat) {
        DispatchQueue.main.async {
            // self.mapOptionsBottomConstraint.constant = constant
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
            }
        }
    }
    
}

extension MapViewController: UISearchBarDelegate{
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.map.removeAnnotations(self.map.annotations)
        
        self.loadPlaces()
        
        self.searchBar.endEditing(true)
    }
}

