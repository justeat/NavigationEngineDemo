//
//  GenericURIConverter.swift
//  JUSTEAT
//
//  Created by Alberto De Bortoli on 13/10/2015.
//  Copyright © 2015 JUST EAT. All rights reserved.
//

import Foundation
import CoreLocation

class UniversalLinkConverter {
        
    private lazy var deepLinkFactory: DeepLinkFactory = {
        return DeepLinkFactory(scheme: settings.internalDeepLinkSchemes.first!, host: settings.internalDeepLinkHost)
    }()
    
    private let settings: DeepLinkingSettingsProtocol
    
    init(settings: DeepLinkingSettingsProtocol) {
        self.settings = settings
    }
    
    func deepLink(forUniversalLink url: UniversalLink) -> DeepLink? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let pathComponents = components.url?.pathComponents,
            let scheme = components.scheme,
            let host = components.host,
            settings.universalLinkHosts.contains(host),
            settings.universalLinkSchemes.contains(scheme) else { return nil }
        
        let queryItems = components.queryItems
        
        switch pathComponents.count {
        case 4:
            switch (pathComponents[1], pathComponents[2], pathComponents[3]) {
            case ("area", let postcodeString, let cuisine):
                let postcode = self.postcodeFromString(postcodeString)
                let location: CLLocationCoordinate2D? = {
                    if let latitude = queryValue(queryItems, key: "lat"), let longitude = queryValue(queryItems, key: "long"),
                        let latitudeDoubleValue = Double(latitude), let longitudeDoubleValue = Double(longitude) {
                        return CLLocationCoordinate2D(latitude: latitudeDoubleValue, longitude: longitudeDoubleValue)
                    }
                    return nil
                }()
                return deepLinkFactory.searchURL(postcode: postcode, cuisine: cuisine, location: location)
            case ("account", "order", let orderId):
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            default:
                return nil
            }
        case 3:
            switch (pathComponents[1], pathComponents[2]) {
            case ("pages", "orderstatus.aspx") where queryContainsKey(queryItems, key: "orderId"):
                let orderId = queryValue(queryItems, key: "orderId")!
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            case ("account", "update-password") where queryContainsKey(queryItems, key: "token"):
                let token = queryValue(queryItems, key: "token")!
                return deepLinkFactory.updatePasswordURL(token: token)
            case ("account", "login"):
                return deepLinkFactory.loginURL()
            case ("account", "order-history"):
                return deepLinkFactory.orderHistoryURL()
            case ("orders", let orderId):
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            case ("order", let orderId):
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            case ("reorder", let orderId):
                return deepLinkFactory.reorderURL(orderId: orderId)
            case ("area", let postcodeString):
                let postcode = self.postcodeFromString(postcodeString)
                let cuisine = queryValue(queryItems, key: "cuisine")
                let location: CLLocationCoordinate2D? = {
                    if let latitude = queryValue(queryItems, key: "lat"), let longitude = queryValue(queryItems, key: "long"),
                        let latitudeDoubleValue = Double(latitude), let longitudeDoubleValue = Double(longitude) {
                        return CLLocationCoordinate2D(latitude: latitudeDoubleValue, longitude: longitudeDoubleValue)
                    }
                    return nil
                }()
                return deepLinkFactory.searchURL(postcode: postcode, cuisine: cuisine, location: location)
            default:
                return nil
            }
            
        case 2:
            switch pathComponents[1] {
            case ("home"):
                return deepLinkFactory.homeURL()
            case ("login"):
                return deepLinkFactory.loginURL()
            case ("search") where queryContainsKey(queryItems, key: "postcode"):
                let postcode = queryValue(queryItems, key: "postcode")!
                let cuisine = queryValue(queryItems, key: "cuisine")
                return deepLinkFactory.searchURL(postcode: postcode, cuisine: cuisine, location: nil)
            case ("search"):
                return deepLinkFactory.searchURL(postcode: nil, cuisine: nil, location: nil)
            case ("restaurant") where queryContainsKey(queryItems, key: "restaurantId"):
                let restaurantId = queryValue(queryItems, key: "restaurantId")!
                let postcode = queryValue(queryItems, key: "postcode")
                let serviceType: ServiceType? = {
                    guard let val = queryValue(queryItems, key: "serviceType") else { return nil }
                    return ServiceType(rawValue: val)
                }()
                let section: RestaurantSection? = {
                    guard let val = queryValue(queryItems, key: "section") else { return nil }
                    return RestaurantSection(rawValue: val)
                }()
                return deepLinkFactory.restaurantURL(restaurantId: restaurantId, postcode: postcode, serviceType: serviceType, section: section)
            case ("resetPassword") where queryContainsKey(queryItems, key: "resetToken"):
                let token = queryValue(queryItems, key: "resetToken")!
                return deepLinkFactory.updatePasswordURL(token: token)
            case ("orders") where queryContainsKey(queryItems, key: "orderId"):
                let orderId = queryValue(queryItems, key: "orderId")!
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            case ("orders"):
                return deepLinkFactory.orderHistoryURL()
            case ("order-history"):
                return deepLinkFactory.orderHistoryURL()
            case ("order") where queryContainsKey(queryItems, key: "orderId"):
                let orderId = queryValue(queryItems, key: "orderId")!
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            case ("reorder") where queryContainsKey(queryItems, key: "orderId"):
                let orderId = queryValue(queryItems, key: "orderId")!
                return deepLinkFactory.reorderURL(orderId: orderId)
            default:
                return nil
            }
            
        case 1:
            return deepLinkFactory.homeURL()
            
        default:
            return deepLinkFactory.homeURL()
        }
    }
    
    fileprivate func queryContainsKey(_ items: [URLQueryItem]?, key: String) -> Bool {
        guard let queryItems = items else { return false }
        return queryItems.filter({ $0.name.caseInsensitiveCompare(key) == .orderedSame }).count > 0
    }
    
    fileprivate func queryValue(_ items: [URLQueryItem]?, key: String) -> String? {
        guard let queryItems = items else { return nil }
        return queryItems.filter({ $0.name.caseInsensitiveCompare(key) == .orderedSame }).first?.value
    }
    
    fileprivate func postcodeFromString(_ string: String) -> String {
        let areaComponents = string.components(separatedBy: "-")
        
        if areaComponents.count > 0 {
            return areaComponents.first!
        }
        
        return string
    }
}
