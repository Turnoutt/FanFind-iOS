import Foundation

internal enum Result<Value> {
	case success(Value)
	case failure(Error)
}

internal typealias ResultCallback<Value> = (Result<Value>) -> Void
