//
//  DeepLinkingConstants.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation

public typealias DeepLink = URL
public typealias UniversalLink = URL

public enum UserStatus: CaseIterable {
    case loggedIn
    case loggedOut
}

public enum RestaurantSection: String {
    case menu
    case reviews
    case info
}

public struct ReorderInfo {
    public let restaurantId: RestaurantId
    public let postcode: Postcode?
    public let serviceType: ServiceType?
    
    public init(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?) {
        self.restaurantId = restaurantId
        self.postcode = postcode
        self.serviceType = serviceType
    }
}
