//
//  ShortcutItemConverter.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 05/02/2019.
//

import Foundation
import UIKit

class ShortcutItemConverter {
    
    private lazy var deepLinkFactory: DeepLinkFactory = {
        return DeepLinkFactory(scheme: settings.internalDeepLinkSchemes.first!, host: settings.internalDeepLinkHost)
    }()
    
    private let settings: DeepLinkingSettingsProtocol
    
    init(settings: DeepLinkingSettingsProtocol) {
        self.settings = settings
    }
    
    func deepLink(forShortcutItem item: UIApplicationShortcutItem) -> DeepLink? {
        
        let components = item.type.components(separatedBy: "/")
        
        switch components.count {
        case 3:
            switch (components[1], components[2]) {
            case ("reorder", let orderId):
                return deepLinkFactory.reorderURL(orderId: orderId)
            case ("search", let postcode):
                return deepLinkFactory.searchURL(postcode: postcode, cuisine: nil, location: nil)
            default:
                return nil
            }
            
        case 2:
            switch components[1] {
            case "search":
                return deepLinkFactory.searchURL(postcode: nil, cuisine: nil, location: nil)
            case "orderHistory":
                return deepLinkFactory.orderHistoryURL()
            default:
                return nil
            }
            
        default:
            return nil
        }
    }
}
