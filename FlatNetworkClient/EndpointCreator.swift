//
//  EndPointCreator.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndpointCreator {
    var URLString: String { get }
    var requestBody: Data? { get }
    var HTTPMethod: String { get }
    var headerFields: [String: String]? { get }
    func getURL() -> URL?
}

extension EndpointCreator {
    func getURL() -> URL? {
        return URL(string: "\(URLString)")
    }
}
