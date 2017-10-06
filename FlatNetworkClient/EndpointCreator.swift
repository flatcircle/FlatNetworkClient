//
//  EndPointCreator.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

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
}

extension EndpointCreator {
    func getURL() -> URL? {
        return URL(string: "\(URLString)")
    }
}

