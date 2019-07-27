import Foundation
import CoreLocation

public class FanFindClient: NSObject {
    
    public static var shared = FanFindClient()
    
    private static var baseEndpointUrl = URL(string: "https://findfans.turnoutt.com/")!
    private static let apiKey = FanFindConfiguration.apiKey
    private var locationManager = CLLocationManager()
    
    private var userId: String? = nil
    private var authToken: String? = nil
    private var session: URLSession {
        let sessionConfig = URLSessionConfiguration.default
        let authValue: String? = "Bearer \(String(describing: authToken))"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authValue ?? ""]
        
        return URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    }
    
    private override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 20 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        
    }
    
   
    
    public static func initialize(baseUrl: String) {
        
        self.baseEndpointUrl = URL(string: baseUrl)!
    }
    
    /**
     Signs in the user. You will not be able to call any of the other methods until this is called.
     
     - Parameter userId: The id of the user being signed in. This must be a unique value.
     */
    public func signIn(userId: String, completion: @escaping ((_ error: Error?) -> Void)) {
        
        self.userId = userId;
        
        let request = Authenticate(clientUserId: self.userId!, apiKey: FanFindClient.apiKey)
        self.sendWithBody(request) { (res) in
            switch res {
            case .success(let tokenResponse):
                self.authToken = tokenResponse.token
                completion(nil)
            case .failure(let err):
                completion(err)
            }
        }
    }
    
    /**
     Gets nearby places for the user. Please be sure to call FanFindClient.initialize before calling this.
     
     - Parameter userId: The id of the user being signed in. This must be a unique value.
     */
    internal func getNearbyPlaces(latitude: Float, longitude: Float, radius: Int, query: String?, completion: @escaping ((_ data: [NearByPlace]?, _ error: Error?) -> Void)) {
        let request = GetPlaces(latitude: latitude, longitude: longitude, radius: radius, query: query)
        
        self.sendWithBody(request) { (res) in
            switch res {
            case .success(let tokenResponse):
                completion(tokenResponse, nil)
            case .failure(let err):
                completion(nil, err)
            }
            
        }
    }
    
    /**
     Gets details for a specific place. Please be sure to call FanFindClient.initialize before calling this.
     
     - Parameter placeId: The id of the place to be requested.
     
     */
    internal func getPlaceDetails(placeId: String, completion: @escaping ((_ data: NearByPlaceDetails?, _ error: Error?) -> Void)) {
        let request = GetPlaceDetails(placeId: placeId)
        
        self.sendWithBody(request) { (res) in
            switch res {
            case .success(let response):
                completion(response, nil)
            case .failure(let err):
                completion(nil, err)
            }
        }
    }
    
    public func startUpdatingLocation() {
        print("Starting Location Updates")
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                self.locationManager.startUpdatingLocation()
                self.locationManager.startMonitoringVisits()
            }
        }
    }
    
    public func stopUpdatingLocation() {
        print("Stop Location Updates")
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    private func sendWithBody<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) {
        let endpoint = self.endpoint(for: request)
        
        var postRequest = URLRequest(url: endpoint)
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("Bearer " + (self.authToken ?? ""), forHTTPHeaderField: "Authorization")
        
        guard let uploadData = try? JSONEncoder().encode(request) else {
            return
        }
        
        let task = session.uploadTask(with: postRequest, from: uploadData) { data, response, error in
            
            guard let response = response else {
                completion(.failure(error!))
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 401 {
                let authRequest = Authenticate(clientUserId: self.userId!, apiKey: FanFindClient.apiKey)
                self.sendWithBody(authRequest) { (res) in
                    switch res {
                    case .success(let tokenResponse):
                        self.authToken = tokenResponse.token
                        self.sendWithBody(request) { (res) in
                            switch res {
                                case .success(let response):
                                    completion(.success(response))
                                case .failure(let error):
                                    completion(.failure(error))
                            }
                            
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if statusCode == 400 {
                guard response as? HTTPURLResponse != nil else {
                    
                    do {
                        let validationResponse = try JSONDecoder().decode(ValidationProblemDetails.self, from: data!)
                        print(validationResponse.detail)
                        print(validationResponse.title)
                        
                        let error = FanFindError.validation(detail: validationResponse.detail)
                        completion(.failure(error))
                    } catch {
                        
                    }
                    
                    return
                }
                
            } else {
                guard response as? HTTPURLResponse != nil else {
                    completion(.failure(error!))
                    return
                }
                
                if let data = data {
                    do {
                        
                        let response = try JSONDecoder().decode(T.Response.self, from: data)
                        completion(.success(response))
                    } catch let jsonError {
                        print(jsonError)
                        completion(.failure(jsonError))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func trackLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, accuracy: Double, completion: @escaping ((_ error: Error?) -> Void)) {
        let request = TrackLocation(latitude: latitude, longitude: longitude, accuracy: accuracy)
        
        self.sendWithBody(request) { (res) in
            switch res {
            case .success( _):
                completion(nil)
            case .failure(let err):
                completion(err)
            }
            
        }
    }
    
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let baseUrl = URL(string: request.resourceName, relativeTo: FanFindClient.baseEndpointUrl) else {
            fatalError("Bad resourceName: \(request.resourceName)")
        }
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        
        let customQueryItems: [URLQueryItem]
        
        do {
            customQueryItems = try URLQueryItemEncoder.encode(request)
        } catch {
            fatalError("Wrong parameters: \(error)")
        }
        
        components.queryItems = customQueryItems
        
        // Construct the final URL with all the previous data
        return components.url!
    }
}

extension FanFindClient : CLLocationManagerDelegate{
    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        FanFindClient.shared.trackLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude, accuracy: visit.horizontalAccuracy) { (err) in
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        FanFindClient.shared.trackLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, accuracy: location.horizontalAccuracy) { (err) in
            
        }
    }
}
