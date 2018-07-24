import Foundation

public typealias NetworkResult = (Data?, Error?) -> Void

public protocol NetworkConnectable {
    var session: URLSessionInjectable { get set }
    var isJWTValid: (() -> Bool)? { get set }
    
    func get<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func post<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func delete<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func put<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
}

public protocol URLSessionInjectable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionInjectable {}
