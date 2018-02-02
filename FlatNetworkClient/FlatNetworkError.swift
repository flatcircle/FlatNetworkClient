

public enum FlatNetworkError: Error,Equatable {
    case authenticationError
    case serverError
    case networkError(Error?)
    
    public var description: String {
        var message = "Unknown Error"
        switch self {
        case .authenticationError:
            message = "A authorization error has occurred"
        case .serverError:
            message = "A server error has occurred"
        case .networkError(let error):
            message = "A network error has occurred: \(error?.localizedDescription ?? "NA")"
        }
        return message
    }
    
    public static func ==(lhs: FlatNetworkError, rhs: FlatNetworkError) -> Bool {
        switch (lhs,rhs) {
        case (.authenticationError, .authenticationError): return true
        case (.serverError, .serverError): return true
        case (.networkError, .networkError): return true
        default: return false
        }
    }
}
