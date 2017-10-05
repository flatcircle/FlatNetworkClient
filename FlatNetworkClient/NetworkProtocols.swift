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
    var session: URLSessionInjectable { get set }}

protocol URLSessionInjectable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

extension URLSession: URLSessionInjectable {}
