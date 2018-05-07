import Foundation

open class NetworkClient: NSObject, NetworkConnectable {
    
    open var getJWT: (() -> String?)?
    open var refreshJWT: ((@escaping () -> Void) -> Void)?
    open var tasks = [String: URLSessionTask]()
    
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
        print("Performing call: \(endPoint.urlRequest?.url?.absoluteString ?? endPoint.URLString)")
        if let request = createRequest(endPoint) {
            startTask(request: request as URLRequest, httpVerb: endPoint.HTTPMethod) { data, error in
                completion(type?.createFromData(data).flatMap { $0 as? A }, error)
            }
        }
    }
    
    private func execute<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        print("Handling \(endPoint.urlRequest?.url?.absoluteString ?? endPoint.URLString)")
        if !endPoint.jwtRequired {
            print("JWT not required, proceeding")
            performNetworkCall(endPoint, completion, type)
        } else if isJWTValid() {
            print("JWT is valid")
            performNetworkCall(endPoint, completion, type)
        } else {
            print("JWT invalid and required, refreshing")
            refreshJWT? {
                self.performNetworkCall(endPoint, completion, type)
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
        let taskKey = (url: request.url!.absoluteString, verb: httpVerb)
        let task = createTask(request as URLRequest, completion: completion)
        set(task: task, for: taskKey)
        task.resume()
    }
    
    private func set(task: URLSessionTask, for key: (url: String, verb: String)) {
        self.tasks["\(key.url)+\(key.verb)"] = task
    }
    
    private func getTask(for key: (url: String, verb: String)) -> URLSessionTask? {
        return self.tasks["\(key.url)+\(key.verb)"]
    }
    
    open func cancelCurrentTasks() {
        tasks.forEach { (key, urlTask) in
            urlTask.cancel()
        }
    }
    
    private func  isJWTValid() -> Bool {
        if let jwt = getJWT?(),
            let tokenDate = extractExpiration(jwt) {
            print("JWT validness: \(tokenDate > Date()), \(tokenDate) - \(Date())")
            return tokenDate > Date()
        } else {
            return false
        }
    }
    
    func extractExpiration(_ token: String?) -> Date? {
        if let interval = decodeJWT(token, key: "exp") as? TimeInterval {
            return Date(timeIntervalSince1970: interval)
        }
        return nil
    }
    
    func decodeJWT(_ token: String?, key: String) -> Any? {
        guard let parts = token?.components(separatedBy: "."),
            parts.count == 3
            else {
                return nil
        }
        var splitToken = parts[1]
        if splitToken.count % 4 != 0 {
            let padlen = 4 - splitToken.count % 4
            splitToken.append(contentsOf: repeatElement("=", count: padlen))
        }
        
        if let data = Data(base64Encoded: splitToken),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return json?[key]
        }
        return nil
    }
}
