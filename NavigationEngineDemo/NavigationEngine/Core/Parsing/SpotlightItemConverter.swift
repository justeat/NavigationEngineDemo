//
//  SpotlightItemConverter.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 05/02/2019.
//

import Foundation
import CoreSpotlight

class SpotlightItemConverter {
    
    private lazy var deepLinkFactory: DeepLinkFactory = {
        return DeepLinkFactory(scheme: settings.internalDeepLinkSchemes.first!, host: settings.internalDeepLinkHost)
    }()
    
    private let settings: DeepLinkingSettingsProtocol
    
    init(settings: DeepLinkingSettingsProtocol) {
        self.settings = settings
    }
    
    func deepLink(forSpotlightItem userActivity: NSUserActivityProtocol) -> DeepLink? {
        guard userActivity.activityType == CSSearchableItemActionType, let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return nil }
        
        let components = uniqueIdentifier.components(separatedBy: "/")
        
        switch components.count {
        case 3:
            switch (components[1], components[2]) {
            case ("restaurant", let restaurantId):
                return deepLinkFactory.restaurantURL(restaurantId: restaurantId, postcode: nil, serviceType: nil, section: nil)
            case ("orderDetails", let orderId):
                return deepLinkFactory.orderDetailsURL(orderId: orderId)
            default:
                return nil
            }
            
        default:
            return nil
        }
    }
}
