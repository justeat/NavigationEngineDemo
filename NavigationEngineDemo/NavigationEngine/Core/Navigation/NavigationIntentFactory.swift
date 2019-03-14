//
//  NavigationIntentFactory.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 28/12/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import Foundation

public typealias OrderId = String
public typealias Postcode = String
public typealias Cuisine = String
public typealias ReorderId = String
public typealias ResetPasswordToken = String
public typealias RestaurantId = String

public enum ServiceType: String {
    case delivery
    case collection
}

public enum NavigationIntent: Equatable {
    case goToHome
    case goToLogin
    case goToResetPassword(ResetPasswordToken)
    case goToSearch(Postcode?, Cuisine?)
    case goToRestaurant(RestaurantId, Postcode?, ServiceType?, RestaurantSection?)
    case goToReorder(ReorderId)
    case goToOrderHistory
    case goToOrderDetails(OrderId)
    case goToSettings
}

enum NavigationIntentFactoryResult {
    case result(NavigationIntent)
    case error(Error)
}

class NavigationIntentFactory {
    
    static let domain = "com.justeat.navigationIntentFactory"
    
    enum ErrorCode: Int {
        case malformedURL
        case unsupportedURL
    }
    
    func intent(for url: DeepLink) -> NavigationIntentFactoryResult {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let pathComponents = components.url?.pathComponents
            else {
                return .error(NSError(domain: NavigationIntentFactory.domain, code: ErrorCode.malformedURL.rawValue, userInfo: nil))
        }
        
        let queryItems = components.queryItems
        
        switch pathComponents.count {
        case 3:
            switch (pathComponents[1], pathComponents[2]) {
            case ("account", "login"):
                return .result(.goToLogin)
            case ("order", let orderId):
                return .result(.goToOrderDetails(orderId))
            case ("reorder", let orderId):
                return .result(.goToReorder(orderId))
            default: break
            }
                
        case 2:
            switch pathComponents[1] {
            case "home":
                return .result(.goToHome)
            case "login":
                return .result(.goToLogin)
            case "search":
                let postcode = queryValue(queryItems, key: "postcode")
                let cuisine = queryValue(queryItems, key: "cuisine")
                return .result(.goToSearch(postcode, cuisine))
            case ("resetPassword") where queryContainsKey(queryItems, key: "resetToken"):
                return .result(.goToResetPassword(queryValue(queryItems, key: "resetToken")!))
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
                return .result(.goToRestaurant(restaurantId, postcode, serviceType, section))
            case ("orderHistory"):
                return .result(.goToOrderHistory)
            case ("order-history"):
                return .result(.goToOrderHistory)
            case ("orders"):
                return .result(.goToOrderHistory)
            case ("order") where queryContainsKey(queryItems, key: "orderId"):
                return .result(.goToOrderDetails(queryValue(queryItems, key: "orderId")!))
            case ("reorder") where queryContainsKey(queryItems, key: "orderId"):
                return .result(.goToReorder(queryValue(queryItems, key: "orderId")!))
            case ("settings"):
                return .result(.goToSettings)
            default: break
            }
            
        case 1:
            return .result(.goToHome)
            
        default: break
        }
        
        return .error(NSError(domain: NavigationIntentFactory.domain, code: ErrorCode.unsupportedURL.rawValue, userInfo: nil))
    }
    
    private func queryContainsKey(_ items: [URLQueryItem]?, key: String) -> Bool {
        guard let queryItems = items else { return false }
        return queryItems.filter({ $0.name.caseInsensitiveCompare(key) == .orderedSame }).count > 0
    }
    
    private func queryValue(_ items: [URLQueryItem]?, key: String) -> String? {
        guard let queryItems = items else { return nil }
        return queryItems.filter({ $0.name.caseInsensitiveCompare(key) == .orderedSame }).first?.value
    }
}
