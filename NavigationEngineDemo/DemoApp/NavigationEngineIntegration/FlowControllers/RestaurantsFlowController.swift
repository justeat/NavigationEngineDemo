//
//  RestaurantsFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

protocol RestaurantsFlowControllerDelegate: class {
    func restaurantsFlowController(_ flowController: RestaurantsFlowController, didRequestGoingToOrder orderId: OrderId) -> Future<Bool>
}

class RestaurantsFlowController: RestaurantsFlowControllerProtocol {
    
    weak var delegate: RestaurantsFlowControllerDelegate!
    fileprivate let navigationController: UINavigationController
    let parentFlowController: RootFlowControllerProtocol!
    
    var checkoutFlowController: CheckoutFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func dismiss(animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        navigationController.dismiss(animated: animated)
        // cannot use the completion to fulfill the future since it might never get called
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goBackToRoot(animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        navigationController.popToRootViewController(animated: animated)
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goToSearchAnimated(postcode: Postcode?, cuisine: Cuisine?, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let serp = SerpViewController.instantiate()
        serp.flowController = self
        navigationController.pushViewController(serp, animated: animated)
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goToRestaurant(restaurantId: RestaurantId, postcode: Postcode?, serviceType: ServiceType?, section: RestaurantSection?, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let restaurantVC = RestaurantViewController.instantiate()
        restaurantVC.flowController = self
        navigationController.pushViewController(restaurantVC, animated: animated)
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goToBasket(reorderId: ReorderId, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let basket = BasketViewController.instantiate()
        basket.flowController = self
        navigationController.pushViewController(basket, animated: animated)
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goToCheckout(animated: Bool) -> Future<Bool> {
        let checkoutNC = UINavigationController()
        let flowController = CheckoutFlowController(with: self, navigationController: checkoutNC)
        flowController.delegate = self
        checkoutFlowController = flowController
        return checkoutFlowController.beginFlow(from: navigationController, animated: animated)
    }
}

extension RestaurantsFlowController: CheckoutFlowControllerDelegate {
    
    @discardableResult
    func checkoutFlowControllerDidRequestGoingBackToSERP(_ flowController: CheckoutFlowController) -> Future<Bool> {
        navigationController.viewControllers = Array(navigationController.viewControllers[0...1])
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func checkoutFlowController(_ flowController: CheckoutFlowController, didRequestGoingToOrder orderId: OrderId) -> Future<Bool> {
        return delegate.restaurantsFlowController(self, didRequestGoingToOrder: orderId)
    }
}
