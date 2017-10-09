//
//  FlatNetworkClient.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

open class NetworkClient: NSObject, NetworkConnectable {
    
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
    
    open func post(_ endPoint: EndpointCreator, completion: @escaping (Data?, Error?) -> Void) {
        if let request = createRequest(endPoint) {
            startTask(request: request as URLRequest) { data, error in
                completion(data, error)
            }
        }
    }
    
    open func delete<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    open func put<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        execute(endPoint, type: type, completion: completion)
    }
    
    private func execute<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable {
        if let request = createRequest(endPoint) {
            startTask(request: request as URLRequest) { data, error in
                completion(type?.createFromData(data).flatMap { $0 as? A }, error)
            }
        }
    }
    
    private func createTask(_ request: URLRequest, completion: @escaping NetworkResult) -> URLSessionDataTask {
        return session.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
    }
    
    private func createRequest(_ endpoint: EndpointCreator) -> NSMutableURLRequest? {
        if let url = endpoint.getURL() {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = endpoint.HTTPMethod
            request.httpBody = endpoint.requestBody
            if let headerFields = endpoint.headerFields {
                request.allHTTPHeaderFields = headerFields
            }
            return request
        }
        return nil
    }
    
    private func startTask(request: URLRequest, completion: @escaping NetworkResult) {
        getTask(for: request.url!.absoluteString)?.cancel()
        let task = createTask(request as URLRequest, completion: completion)
        set(task: task, for: request.url!.absoluteString)
        task.resume()
    }
    
    private func set(task: URLSessionTask, for key: String) {
        self.tasks[key] = task
    }
    
    private func getTask(for key: String) -> URLSessionTask? {
        return self.tasks[key]
    }
    
    open func cancelCurrentTasks() {
        tasks.forEach { [weak self] key, _ in
            self?.getTask(for: key)?.cancel()
        }
    }
}
