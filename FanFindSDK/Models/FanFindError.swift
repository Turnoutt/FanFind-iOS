import Foundation

public enum FanFindError: Error {
    case encoding
    case decoding
    case server(message: String)
    case initializeNotCalled
    case authenticateFailed(message: String)
    case validation(detail: String)
    case configuration(message: String)
}
