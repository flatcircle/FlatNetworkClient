//
//  PutEndPoint.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

protocol PutEndpointCreator: EndpointCreator { }

extension PutEndpointCreator {
    var HTTPMethod: String {
        return HTTPVerb.put.rawValue
    }
}

