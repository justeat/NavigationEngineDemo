//
//  RootFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

class RootFlowController: RootFlowControllerProtocol {
    
    private let tabBarController: TabBarController
    
    var restaurantsFlowController: RestaurantsFlowControllerProtocol!
    var ordersFlowController: OrdersFlowControllerProtocol!
    var settingsFlowController: SettingsFlowControllerProtocol!
    
    var accountFlowController: AccountFlowControllerProtocol!
    
    init(with tabBarController: TabBarController) {
        self.tabBarController = tabBarController
    }
    
    func setup() {
        let takeawayNavigationController = tabBarController.viewControllers![0] as! UINavigationController
        let restaurantsFlowController = RestaurantsFlowController(with: self, navigationController: takeawayNavigationController)
        restaurantsFlowController.delegate = self
        self.restaurantsFlowController = restaurantsFlowController
        let homeViewController = takeawayNavigationController.topViewController as! HomeViewController
        homeViewController.flowController = restaurantsFlowController
        
        let ordersNavigationController = tabBarController.viewControllers![1] as! UINavigationController
        let ordersFlowController = OrdersFlowController(with: self, navigationController: ordersNavigationController)
        ordersFlowController.delegate = self
        self.ordersFlowController = ordersFlowController
        let orderHistoryViewController = ordersNavigationController.topViewController as! OrderHistoryViewController
        orderHistoryViewController.flowController = ordersFlowController
        
        let settingsNavigationController = tabBarController.viewControllers![2] as! UINavigationController
        let settingsFlowController = SettingsFlowController(with: self, navigationController: settingsNavigationController)
        let settingsViewController = settingsNavigationController.topViewController as! SettingsViewController
        self.settingsFlowController = settingsFlowController
        settingsViewController.flowController = settingsFlowController
    }
    
    @discardableResult
    func dismissAll(animated: Bool) -> Future<Bool> {
        // cannot use the completion to fulfill any future since it might never get called
        tabBarController.dismiss(animated: animated)
        let fut1 = restaurantsFlowController.dismiss(animated: animated)
        let fut2 = ordersFlowController.dismiss(animated: animated)
        let fut3 = settingsFlowController.dismiss(animated: animated)
        return Future.whenAll([fut1, fut2, fut3]).then { future in
            let erroredFuture = [fut1, fut2, fut3].filter { $0.hasError() }
            if let firstErroredFuture = erroredFuture.first {
                return Future<Bool>.future(withError: firstErroredFuture.error!)
            }
            return Future<Bool>.future(withResult: fut1.result! && fut2.result! && fut3.result!)
        }
    }
    
    @discardableResult
    func dismissAndPopToRootAll(animated: Bool) -> Future<Bool> {
        let fut0 = dismissAll(animated: animated)
        let fut1 = restaurantsFlowController.goBackToRoot(animated: animated)
        let fut2 = ordersFlowController.goBackToRoot(animated: animated)
        let fut3 = settingsFlowController.goBackToRoot(animated: animated)
        return Future.whenAll([fut0, fut1, fut2, fut3]).then { future in
            let erroredFuture = [fut0, fut1, fut2, fut3].filter { $0.hasError() }
            if let firstErroredFuture = erroredFuture.first {
                return Future<Bool>.future(withError: firstErroredFuture.error!)
            }
            return Future<Bool>.future(withResult: fut0.result! && fut1.result! && fut2.result! && fut3.result!)
        }
    }
    
    @discardableResult
    func goToLogin(animated: Bool) -> Future<Bool> {
        let accountNC = UINavigationController()
        accountFlowController = AccountFlowController(with: self, navigationController: accountNC)
        return accountFlowController.beginLoginFlow(from: tabBarController, animated: animated)
    }
    
    @discardableResult
    func goToResetPassword(token: ResetPasswordToken, animated: Bool) -> Future<Bool> {
        let accountNC = UINavigationController()
        accountFlowController = AccountFlowController(with: self, navigationController: accountNC)
        return accountFlowController.beginResetPasswordFlow(from: tabBarController, token: token, animated: animated)
    }
    
    @discardableResult
    func goToRestaurantsSection() -> Future<Bool> {
        tabBarController.selectedIndex = 0
        return Future<Bool>.future(withResult: true)
    }

    @discardableResult
    func goToOrdersSection() -> Future<Bool> {
        tabBarController.selectedIndex = 2
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToSettingsSection() -> Future<Bool> {
        tabBarController.selectedIndex = 3
        return Future<Bool>.future(withResult: true)
    }
}

extension RootFlowController: OrdersFlowControllerDelegate {
    
    func ordersFlowController(_ flowController: OrdersFlowController, didRequestGoingToRestaurant restaurantId: String) -> Future<Bool> {
        return goToRestaurantsSection().then { future in
            self.restaurantsFlowController.goBackToRoot(animated: false)
            }.then { future in
                self.restaurantsFlowController.goToRestaurant(restaurantId: restaurantId, postcode: nil, serviceType: nil, section: nil, animated: false)
        }
    }
}

extension RootFlowController: RestaurantsFlowControllerDelegate {
    
    func restaurantsFlowController(_ flowController: RestaurantsFlowController, didRequestGoingToOrder orderId: OrderId) -> Future<Bool> {
        return dismissAndPopToRootAll(animated: false).then { future in
            return self.goToOrdersSection()
            }.then { future in
                self.ordersFlowController.goToOrder(orderId: orderId, animated: false)
        }
    }
}
