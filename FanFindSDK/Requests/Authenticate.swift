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
    
    public init(clientUserId: String, apiKey: String, phoneSessionId: String) {
        self.clientUserId = clientUserId
        self.apiKey = apiKey
        
        self.phoneSessionId = phoneSessionId
    }
}
