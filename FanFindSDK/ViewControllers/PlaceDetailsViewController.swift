//
//  PlaceDetailsViewController.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation
import MapKit

class PlaceDetailsViewController : UIViewController{
    @IBOutlet var dealsEventsView: SelfSizedTableView!
    @IBOutlet var hoursTableView: SelfSizedTableView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var fanCount: PeopleCountNumbers!
    @IBOutlet var placeInfoHeader: PlaceInfoHeaderView!
    
    @IBOutlet var websiteButton: UIButton!
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigate(_ sender: Any) {
        let locationCoords = CLLocationCoordinate2D(
            latitude: (self.place!.latitude)!,
            longitude: (self.place!.longitude)!
        )
        
        if let place = place{
            
            let location = NavigatorLocation(coords: locationCoords, name: place.name ?? "", address: place.fullAddress)
            
            Navigator.presentPicker(destination: location, presentOn: self)
        }
    }
    
    @IBAction func callPlace(_ sender: Any) {
        if let phoneNumber = self.placeDetails?.phoneNumber {
            guard let number = URL(string: "tel://" + phoneNumber) else { return }
            UIApplication.shared.open(number)
        }
    }
    
    var deals: Array<PlaceDeal> = []
    var events: Array<PlaceEvent> = []
    var hours: Array<BusinessHour> = []
    var placeDetails: NearByPlaceDetails? = nil
    var place: NearByPlace? = nil
    
    public init(place: NearByPlace, placeDetails: NearByPlaceDetails) {
        self.place = place
        self.placeDetails = placeDetails
        
        self.hours = placeDetails.hours.sorted(by: { (prev, next) -> Bool in
            if(prev.dayNumberOfWeek == next.dayNumberOfWeek){
                return prev.startTime < next.startTime
            }
            
            return prev.dayNumberOfWeek < next.dayNumberOfWeek
        })
        self.deals = placeDetails.deals
        self.events = placeDetails.events
        
        super.init(nibName: "PlaceDetailsViewController", bundle: Bundle(for: PlaceDetailsViewController.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(nibName: "PlaceDetailsViewController", bundle: Bundle(for: PlaceDetailsViewController.self))
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeInfoHeader.showExtendedDetails = true
        
        self.view.backgroundColor = FanFindConfiguration.backgroundColor
        
        dealsEventsView.delegate = self
        dealsEventsView.dataSource = self
        dealsEventsView.allowsSelection = false
        dealsEventsView.separatorStyle = .none
        
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        hoursTableView.allowsSelection = false
        hoursTableView.separatorStyle = .none
        
        if(self.hours.count == 0){
            hoursTableView.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.placeInfoHeader.setPlace(place: self.place!)
            self.placeInfoHeader.setPlaceDetails(place: self.placeDetails!)
        
            self.websiteButton.isHidden = true
        }
        
        dealsEventsView.register(UINib(nibName: "EventsTableViewCell", bundle: Bundle(for: EventsTableViewCell.self)), forCellReuseIdentifier: "eventsTableViewCell")
        
        dealsEventsView.register(UINib(nibName: "DealsTableViewCell", bundle: Bundle(for: DealsTableViewCell.self)), forCellReuseIdentifier: "dealsTableViewCell")
        
        dealsEventsView.register(UINib(nibName: "StandardHeaderTableViewCell", bundle: Bundle(for: StandardHeaderTableViewCell.self)), forHeaderFooterViewReuseIdentifier: "standardHeaderTableViewCell")
        
        hoursTableView.register(UINib(nibName: "HoursHeaderTableViewCell", bundle: Bundle(for: HoursHeaderTableViewCell.self)), forHeaderFooterViewReuseIdentifier: "hoursHeaderTableViewCell")
        
        hoursTableView.register(UINib(nibName: "HoursTableViewCell", bundle: Bundle(for: HoursTableViewCell.self)), forCellReuseIdentifier: "hoursTableViewCell")
    }
    
}

extension PlaceDetailsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == self.hoursTableView){
            return 1
        }
        
        if deals.count == 0 {
            if events.count == 0 {
                return 0
            }
            
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.dealsEventsView){
            switch section {
            case 0:
                return deals.count
            case 1:
                return events.count
            default:
                return 0
            }
        }
        
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == self.hoursTableView){
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "hoursHeaderTableViewCell") as! HoursHeaderTableViewCell
            cell.setHours(hours: hours)
            return cell
        } else {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "standardHeaderTableViewCell") as! StandardHeaderTableViewCell
            
            switch section {
            case 0:
                cell.label.text = "DEALS"
            case 1:
                cell.label.text =  "EVENTS"
            default:
                cell.label.text =  ""
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.hoursTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "hoursTableViewCell") as! HoursTableViewCell
            
            cell.dayOfWeek.text = hours[indexPath.row].dayOfWeek
            cell.setTime(startTime: hours[indexPath.row].startTime, endTime: hours[indexPath.row].endTime)
            
            return cell
        } else {
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dealsTableViewCell") as! DealsTableViewCell
                cell.label.text = deals[indexPath.row].dealText
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as! EventsTableViewCell
                cell.setEvent(event: events[indexPath.row])
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dealsTableViewCell") as! DealsTableViewCell
                cell.label.text = deals[indexPath.row].dealText
                
                return cell
            }
        }
    }
}

extension PlaceDetailsViewController: UITableViewDelegate{
    
}
