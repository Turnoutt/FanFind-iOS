//
//  PlaceDetailsViewController.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import Foundation

class PlaceDetailsViewController : UIViewController{
    @IBOutlet var dealsEventsView: SelfSizedTableView!
    @IBOutlet var hoursTableView: SelfSizedTableView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var fanCount: PeopleCountNumbers!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var website: UILabel!
    @IBOutlet var websiteButton: UIButton!
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        self.hours = placeDetails.hours
        self.deals = placeDetails.deals
        self.events = placeDetails.events
        
        super.init(nibName: "PlaceDetailsViewController", bundle: Bundle(for: PlaceDetailsViewController.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(nibName: "PlaceDetailsViewController", bundle: Bundle(for: PlaceDetailsViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = FanFindConfiguration.backgroundColor
        
        deals.append(PlaceDeal(startDate: Date.init(), endDate: Date.init(), dealText: "$5 Coors Light draft during Rockets games"))
        deals.append(PlaceDeal(startDate: Date.init(), endDate: Date.init(), dealText: "$0.50 Wings during Rockets games"))
        
        events.append(PlaceEvent(startDate: Date.init(), endDate: Date.init(), eventText: "Rockets vs. Warriors viewing party"))
        events.append(PlaceEvent(startDate: Date.init(), endDate: Date.init(), eventText: "Rockets Player Meet and Greet"))
        
        hours.append(BusinessHour(dayOfWeek: "Monday", startTime: "09:00:00", endTime: "17:30:00", dayNumberOfWeek: 1))
        hours.append(BusinessHour(dayOfWeek: "Tuesday", startTime: "09:00:00", endTime: "17:30:00", dayNumberOfWeek: 2))
        hours.append(BusinessHour(dayOfWeek: "Wednesday", startTime: "09:00:00", endTime: "17:30:00", dayNumberOfWeek: 3))
        hours.append(BusinessHour(dayOfWeek: "Thursday", startTime: "09:00:00", endTime: "17:30:00", dayNumberOfWeek: 4))
        hours.append(BusinessHour(dayOfWeek: "Friday", startTime: "09:00:00", endTime: "17:30:00", dayNumberOfWeek: 5))
        
        dealsEventsView.delegate = self
        dealsEventsView.dataSource = self
        dealsEventsView.allowsSelection = false
        dealsEventsView.separatorColor = UIColor.clear
        
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        hoursTableView.allowsSelection = false
        hoursTableView.separatorColor = UIColor.clear
        
        DispatchQueue.main.async {
            self.name.text = self.place?.name
            self.address.text = self.place?.address1
            self.phone.text = self.placeDetails?.formattedPhoneNumber
            
            self.website.isHidden = true
            self.websiteButton.isHidden = true
            
            self.dealsEventsView.maxHeight = 300
            self.hoursTableView.maxHeight = 300
        }
        
        dealsEventsView.register(UINib(nibName: "EventsTableViewCell", bundle: Bundle(for: EventsTableViewCell.self)), forCellReuseIdentifier: "eventsTableViewCell")
        
        dealsEventsView.register(UINib(nibName: "DealsTableViewCell", bundle: Bundle(for: DealsTableViewCell.self)), forCellReuseIdentifier: "dealsTableViewCell")
        
        dealsEventsView.register(UINib(nibName: "StandardHeaderTableViewCell", bundle: Bundle(for: StandardHeaderTableViewCell.self)), forCellReuseIdentifier: "standardHeaderTableViewCell")
        
        hoursTableView.register(UINib(nibName: "HoursHeaderTableViewCell", bundle: Bundle(for: HoursHeaderTableViewCell.self)), forCellReuseIdentifier: "hoursHeaderTableViewCell")
        
        hoursTableView.register(UINib(nibName: "HoursTableViewCell", bundle: Bundle(for: HoursTableViewCell.self)), forCellReuseIdentifier: "hoursTableViewCell")
    }
    
}

extension PlaceDetailsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == self.hoursTableView){
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "hoursHeaderTableViewCell") as! HoursHeaderTableViewCell
            cell.setHours(hours: hours)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardHeaderTableViewCell") as! StandardHeaderTableViewCell
            
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mma"
            
            cell.hours.text = dateFormatter.string(from: hours[indexPath.row].startTime) + " - " + dateFormatter.string(from: hours[indexPath.row].endTime)
            
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
