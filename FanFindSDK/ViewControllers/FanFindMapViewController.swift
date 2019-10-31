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

public class FanFindMapViewController: UIViewController {
    @IBOutlet var map: MKMapView!
    @IBOutlet var redoSearchButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var centerLocationButton: UIButton!
    @IBOutlet var searchBarWrapper: UIView!
    
    var fanFindClient = FanFindClient.shared
    var location:CLLocationCoordinate2D? = nil
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
        super.init(nibName: "FanFindMapViewController", bundle: Bundle(for: FanFindMapViewController.self))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(nibName: "FanFindMapViewController", bundle: Bundle(for: FanFindMapViewController.self))
    }
    
    override public var shouldAutorotate: Bool{
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [];
        guard let jsonURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") else { return }
        
        if let tileOverlay = try? GoogleMapsTileOverlay(jsonURL: jsonURL) {
            tileOverlay.canReplaceMapContent = true
            map?.addOverlay(tileOverlay)
            
            self.tileOverlay = tileOverlay
        }
        
        self.searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        
        redoSearchButton.isHidden = true
        redoSearchButton.layer.masksToBounds =  false
        redoSearchButton.layer.shadowColor = UIColor.gray.cgColor
        redoSearchButton.layer.shadowOpacity = 1
        redoSearchButton.layer.shadowOffset = .init(width: 0, height: 2)
        redoSearchButton.layer.shadowRadius = 2
        
        searchBarWrapper.layer.masksToBounds = false
        searchBarWrapper.layer.shadowColor = UIColor.gray.cgColor
        searchBarWrapper.layer.shadowOpacity = 1
        searchBarWrapper.layer.shadowOffset = .init(width: 0, height: 2)
        searchBarWrapper.layer.shadowRadius = 2
        
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
        
        fanFindClient.delegate = self
        
        map.register(PlacesAnnotationView.self, forAnnotationViewWithReuseIdentifier: "placesViewReuseIdentitier")
        
        addMapTrackingButton()
    }
    
    func addMapTrackingButton(){
      
        centerLocationButton.addTarget(self, action: #selector(centerMapOnUserButtonClicked), for:.touchUpInside)
    }

    @objc func centerMapOnUserButtonClicked() {
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        self.loadPlaces(self.location)
    }
    
    override public func viewWillAppear(_ animated: Bool){
        showLocationRequestModal()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        fanFindClient.stopUpdatingLocation()
    }
    
    func showLocationRequestModal(){
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                fanFindClient.startUpdatingLocation()
                fanFindClient.startUpdatingBackgroundLocation()
                
                if let lastLocation =  self.fanFindClient.lastLocation {
                    loadInitialMap(lastLocation.coordinate)
                }
            } else if CLLocationManager.authorizationStatus() == .denied {
                let alert = UIAlertController(title: "Need Authorization", message: "You have denied location access for this application. In order to use the fan map, please enable location access.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self.goBackToPreviousView()
                }))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    self.goBackToPreviousView()
                }))
                self.present(alert, animated: true, completion: nil)
            }             else{
                RequestLocationViewController.show(on: self, action: { [weak self] (allowClicked, controller) in
                    guard let self = self else { return }
                    
                    if allowClicked{
                        self.fanFindClient.requestLocationAuthorization()
                        controller.dismiss(animated: true)
                       
                    }else{
                        self.goBackToPreviousView()
                        
                        controller.dismiss(animated: true)
                    }
                })
            }
        }
    }
    
    private func goBackToPreviousView(){
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
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

extension FanFindMapViewController: MKMapViewDelegate {
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

extension FanFindMapViewController: LocationUpdateDelegate{
    func authorizationStatusChanged(_ status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            self.goBackToPreviousView()
        } else {
            fanFindClient.startUpdatingLocation()
            fanFindClient.startUpdatingBackgroundLocation()
        }
    }
    
    fileprivate func loadInitialMap(_ location: CLLocationCoordinate2D) {
        DispatchQueue.global(qos: .background).async {
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            DispatchQueue.main.async {
                self.map.setRegion(region, animated: true)
            }
            
            let span = region.span
            
            let loc1 = CLLocation(latitude: location.latitude - span.latitudeDelta * 0.5, longitude: location.longitude)
            let loc2 = CLLocation(latitude: location.latitude + span.latitudeDelta * 0.5, longitude: location.longitude)
            
            
            let metersInLatitude = loc1.distance(from: loc2)
            
            self.loadPlaces(location, metersInLatitude)
            
            self.hasLoaded = true
            
        }
    }
    
    func locationUpdated(_ location: CLLocationCoordinate2D){
        if(!hasLoaded){
            loadInitialMap(location)
        }
        
        self.location = location
    }
}

extension FanFindMapViewController: PlacesCenterCellDelegate{
    func collectionViewStoppedAt(place: Place, focusOnPlace: Bool) {
        setAnnotationAsSelected(place)
        
        
        FanFindClient.shared.createEvent(eventType: "PlaceFocused", placeId: place.placeId) { (err) in
            
        }
        
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

extension FanFindMapViewController: UISearchBarDelegate{
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.map.removeAnnotations(self.map.annotations)
        
        self.loadPlaces()
        
        self.searchBar.endEditing(true)
    }
}

