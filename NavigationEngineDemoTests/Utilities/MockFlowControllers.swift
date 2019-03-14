//
//  MockFlowControllers.swift
//  NavigationEngine_Example
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import NavigationEngineDemo
import Promis

class MockRestaurantsFlowController: RestaurantsFlowControllerProtocol {
    
    fileprivate let navigationController: UINavigationController
    
    var checkoutFlowController: CheckoutFlowControllerProtocol!
    var parentFlowController: RootFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
        checkoutFlowController = MockCheckoutFlowController(with: self, navigationController: UINavigationController())
    }
    
    @discardableResult
    func dismiss(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goBackToRoot(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToSearchAnimated(postcode: Postcode?, cuisine: Cuisine?, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToRestaurant(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToBasket(reorderId: ReorderId, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToCheckout(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}

class MockOrdersFlowController: OrdersFlowControllerProtocol {
    
    private let navigationController: UINavigationController
    var parentFlowController: RootFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func dismiss(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goBackToRoot(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToOrder(orderId: OrderId, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToRestaurant(restaurantId: String) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func leaveFlow(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}

class MockCheckoutFlowController: CheckoutFlowControllerProtocol {
    
    private let navigationController: UINavigationController
    var parentFlowController: RestaurantsFlowControllerProtocol!
    
    init(with parentFlowController: RestaurantsFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func beginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func proceedToPayment(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToOrderConfirmation(orderId: String) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func leaveFlow(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func leaveFlowAndGoBackToSERP() -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}

class MockSettingsFlowController: SettingsFlowControllerProtocol {
    
    private let navigationController: UINavigationController
    var parentFlowController: RootFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func dismiss(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goBackToRoot(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}

class MockAccountFlowController: AccountFlowControllerProtocol {
    
    private let navigationController: UINavigationController
    var parentFlowController: RootFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func beginLoginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func waitForUserToLogin(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func beginResetPasswordFlow(from viewController: UIViewController, token: ResetPasswordToken, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func leaveFlow(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}

class MockRootFlowController: RootFlowControllerProtocol {
    
    private let tabBarController = UITabBarController()
    
    var restaurantsFlowController: RestaurantsFlowControllerProtocol!
    var ordersFlowController: OrdersFlowControllerProtocol!
    var settingsFlowController: SettingsFlowControllerProtocol!
    
    var accountFlowController: AccountFlowControllerProtocol!
    
    func setup() {
        let takeawayNavigationController = UINavigationController()
        let restaurantsFlowController = MockRestaurantsFlowController(with: self, navigationController: takeawayNavigationController)
        self.restaurantsFlowController = restaurantsFlowController
        
        let ordersNavigationController = UINavigationController()
        let ordersFlowController = MockOrdersFlowController(with: self, navigationController: ordersNavigationController)
        self.ordersFlowController = ordersFlowController
        
        let settingsNavigationController = UINavigationController()
        let settingsFlowController = MockSettingsFlowController(with: self, navigationController: settingsNavigationController)
        self.settingsFlowController = settingsFlowController
    }
    
    func dismissAll(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func dismissAndPopToRootAll(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func goToLogin(animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func goToResetPassword(token: ResetPasswordToken, animated: Bool) -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func goToRestaurantsSection() -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }

    func goToOrdersSection() -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
    
    func goToSettingsSection() -> Future<Bool> {
        return Future<Bool>.future(withResult: true)
    }
}
