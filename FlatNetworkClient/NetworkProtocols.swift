//
//  NetworkProtocols.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

public typealias NetworkResult = (Data?, Error?) -> Void

public protocol NetworkConnectable {

    var tasks: [String: URLSessionTask] { get set }
    var session: URLSessionInjectable { get set }
    
    
    var executionInterceptionTask: InterceptionClosure? { get set }
    
    func get<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func post<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func post(_ endPoint: EndpointCreator, completion: @escaping (Data?, Error?) -> Void)
    func delete<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func put<A>(_ endPoint: EndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
}

public protocol URLSessionInjectable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionInjectable {}
