//
//  DeepLinkFactory.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation
import CoreLocation

public class DeepLinkFactory {
    
    let scheme: String
    let host: String
    
    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
}

extension DeepLinkFactory {
    
    public func homeURL() -> DeepLink {
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/home",
                                queryItems: nil)
        return endpoint.url
    }
    
    public func loginURL() -> DeepLink {
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/login",
                                queryItems: nil)
        return endpoint.url
    }
    
    public func updatePasswordURL(token: ResetPasswordToken) -> DeepLink {
        let tokenQueryItem = URLQueryItem(name: "resetToken", value: token)
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/resetPassword",
                                queryItems: [tokenQueryItem])
        return endpoint.url
    }
}

extension DeepLinkFactory {
    
    public func searchURL(postcode: Postcode?, cuisine: Cuisine?, location: CLLocationCoordinate2D?) -> DeepLink {
        let postcodeQueryItem = postcode != nil ? URLQueryItem(name: "postcode", value: postcode) : nil
        let cuisineQueryItem = cuisine != nil ? URLQueryItem(name: "cuisine", value: cuisine) : nil
        var queryItems = [postcodeQueryItem, cuisineQueryItem].compactMap { return $0 }
        if let location = location {
            let latitudeQueryItem = URLQueryItem(name: "lat", value: "\(location.latitude)")
            let longitudeQueryItem = URLQueryItem(name: "long", value: "\(location.longitude)")
            queryItems.append(latitudeQueryItem)
            queryItems.append(longitudeQueryItem)
        }
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/search",
                                queryItems: queryItems.count > 0 ? queryItems : nil)
        return endpoint.url
    }
    
    public func restaurantURL(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?) -> DeepLink {
        let restaurantIdQueryItem = URLQueryItem(name: "restaurantId", value: restaurantId)
        let postcodeQueryItem = postcode != nil ? URLQueryItem(name: "postcode", value: postcode) : nil
        let serviceTypeQueryItem = serviceType != nil ? URLQueryItem(name: "serviceType", value: serviceType?.rawValue) : nil
        let sectionQueryItem = section != nil ? URLQueryItem(name: "section", value: section?.rawValue) : nil
        let queryItems = [restaurantIdQueryItem, postcodeQueryItem, serviceTypeQueryItem, sectionQueryItem].compactMap { return $0 }
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/restaurant",
                                queryItems: queryItems.count > 0 ? queryItems : nil)
        return endpoint.url
    }
}

extension DeepLinkFactory {
    
    public func orderHistoryURL() -> DeepLink {
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/orders",
                                queryItems: nil)
        return endpoint.url
    }
    
    public func orderDetailsURL(orderId: OrderId) -> DeepLink {
        let orderIdQueryItem = URLQueryItem(name: "orderId", value: orderId)
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/order",
                                queryItems: [orderIdQueryItem])
        return endpoint.url
    }
    
    public func reorderURL(orderId: OrderId) -> DeepLink {
        let orderIdQueryItem = URLQueryItem(name: "orderId", value: orderId)
        let endpoint = Endpoint(scheme: scheme,
                                host: host,
                                path: "/reorder",
                                queryItems: [orderIdQueryItem])
        return endpoint.url
    }
}
