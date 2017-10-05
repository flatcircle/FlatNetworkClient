//
//  NetworkProtocols.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

typealias NetworkResult = (Data?, Error?) -> Void

protocol NetworkConnectable {
    var tasks: [String: URLSessionTask] { get set }
    var session: URLSessionInjectable { get set }
    
    func get<A>(_ endPoint: GetEndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func post<A>(_ endPoint: PostEndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func delete<A>(_ endPoint: DeleteEndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
    func put<A>(_ endPoint: PutEndpointCreator, type: A.Type?, completion: @escaping (A?, Error?) -> Void) where A: JsonCreatable
}

protocol URLSessionInjectable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionInjectable {}
