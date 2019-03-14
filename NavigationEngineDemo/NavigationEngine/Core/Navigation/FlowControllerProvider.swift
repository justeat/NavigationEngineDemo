//
//  FlowControllerProvider.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 25/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

public class FlowControllerProvider {
    
    public let rootFlowController: RootFlowControllerProtocol
    
    public var restaurantsFlowController: RestaurantsFlowControllerProtocol {
        return rootFlowController.restaurantsFlowController
    }
    
    public var ordersFlowController: OrdersFlowControllerProtocol {
        return rootFlowController.ordersFlowController
    }
    
    public var checkoutFlowController: CheckoutFlowControllerProtocol {
        return rootFlowController.restaurantsFlowController.checkoutFlowController
    }
    
    public var settingsFlowController: SettingsFlowControllerProtocol {
        return rootFlowController.settingsFlowController
    }
    
    public init(rootFlowController: RootFlowControllerProtocol) {
        self.rootFlowController = rootFlowController
    }
}
