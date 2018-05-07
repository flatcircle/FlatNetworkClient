import Foundation

public enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol EndpointCreator {
    var URLString: String { get }
    var requestBody: Data? { get }
    var HTTPMethod: String { get }
    var headerFields: [String: String]? { get }
    var urlRequest: NSMutableURLRequest? { get }
    var jwtRequired: Bool { get }
}

extension EndpointCreator {
    func getURL() -> URL? {
        return URL(string: "\(URLString)")
    }
}

