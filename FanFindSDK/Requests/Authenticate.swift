import AdSupport
import Foundation

internal struct Authenticate: APIRequest {
    public typealias Response = TokenResponse
    
    public var resourceName: String {
        return "v1/auth/sign-in"
    }
    
    // Parameters
    private let clientUserId: String
    private let apiKey: String
    private var phoneSessionId: String?
    
    public init(clientUserId: String, apiKey: String, phoneSessionId: String) {
        self.clientUserId = clientUserId
        self.apiKey = apiKey        
        self.phoneSessionId = phoneSessionId
    }
}
