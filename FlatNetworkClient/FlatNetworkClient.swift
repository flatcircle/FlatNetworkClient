import Foundation

open class NetworkClient: NSObject, NetworkConnectable {
    
    open var isJWTValid: (() -> Bool)?
    
    open var session: URLSessionInjectable = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    public convenience init(session: URLSessionInjectable) {
        self.init()
        self.session = session
    }
    
    open func get<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    open func post<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    open func delete<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    open func put<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    fileprivate func performNetworkCall<A>(_ endPoint: EndpointCreator, _ completion: @escaping (A?, Error?) -> Void, _ type: A.Type?) where A: JsonCreatable {
        if let request = createRequest(endPoint) {
            startTask(request: request as URLRequest, httpVerb: endPoint.HTTPMethod) { data, error in
                completion(type?.createFromData(data).flatMap { $0 as? A }, error)
            }
        }
    }
    
    private func execute<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        DispatchQueue.global(qos: .userInitiated).async {
            if !endPoint.jwtRequired {
                self.performNetworkCall(endPoint, completion, type)
            } else if self.isJWTValid?() ?? false {
                self.performNetworkCall(endPoint, completion, type)
            } else {
                self.execute(endPoint, type: type, completion: completion)
            }
        }
    }
    
    private func createTask(_ request: URLRequest, completion: @escaping NetworkResult) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299: completion(data, nil)
                case 400...499: completion(nil, FlatNetworkError.authenticationError)
                case 500...599: completion(nil, FlatNetworkError.serverError)
                default: completion(nil, FlatNetworkError.networkError(error))
                }
            } else {
                completion(data, error)
            }
        }
    }
    
    private func createRequest(_ endpoint: EndpointCreator) -> NSMutableURLRequest? {
        
        var request: NSMutableURLRequest? = endpoint.urlRequest
        
        if let url = endpoint.getURL() {
            request = NSMutableURLRequest(url: url)
        }
        
        request?.httpMethod = endpoint.HTTPMethod
        request?.httpBody = endpoint.requestBody
        
        if let headerFields = endpoint.headerFields {
            request?.allHTTPHeaderFields = headerFields
        }
        return request
    }
    
    private func startTask(request: URLRequest, httpVerb: String, completion: @escaping NetworkResult) {
        let task = createTask(request as URLRequest, completion: completion)
        task.resume()
    }
}
