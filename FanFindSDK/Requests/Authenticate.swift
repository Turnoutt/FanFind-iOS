import AdSupport
import Foundation

internal struct Authenticate: APIRequest {
    public typealias Response = TokenResponse
    
    public var resourceName: String {
        return "auth/v1/sign-in"
    }
    
    private var mobileAdId: String?
    
    // Parameters
    private let clientUserId: String
    private let apiKey: String
    
    public init(clientUserId: String, apiKey: String) {
        self.clientUserId = clientUserId
        self.apiKey = apiKey
        
        self.mobileAdId = identifierForAdvertising()
    }
    
    func identifierForAdvertising() -> String? {
        // Check whether advertising tracking is enabled
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        // Get and return IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
