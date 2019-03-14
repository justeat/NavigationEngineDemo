//
//  LoginViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 05/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation

struct Endpoint {
    let scheme: String
    let host: String
    let path: String
    let queryItems: [URLQueryItem]?
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
}
