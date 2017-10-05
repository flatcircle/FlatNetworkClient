//
//  JSONProtocols.swift
//  FlatNetworkClient
//
//  Created by Rohan Jansen on 2017/10/05.
//  Copyright © 2017 io.flatcircle. All rights reserved.
//

import Foundation

protocol JsonCreatable {
    associatedtype T
    associatedtype A
    static func createFromJSON(_ json: A?) -> T?
}

//TODO: perhaps look at adding a swift 4 implementation and see if it works with solutions that are swift 3 and down comaptible
extension JsonCreatable {
    static func createFromData(_ data: Data?) -> T? {
        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? A {
            return self.createFromJSON(json)
        } else {
            return nil
        }
    }
}
