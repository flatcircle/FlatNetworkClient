import Foundation

public typealias NetworkResult = (Data?, Error?) -> Void

public protocol NetworkConnectable {
    var tasks: [String: URLSessionTask] { get set }
    var session: URLSessionInjectable { get set }
    var refreshJWT: ((@escaping () -> Void) -> Void)? { get set }
    var getJWT: (() -> String?)? { get set }
    
    func get<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func post<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func delete<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func put<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
}

public protocol URLSessionInjectable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionInjectable {}
