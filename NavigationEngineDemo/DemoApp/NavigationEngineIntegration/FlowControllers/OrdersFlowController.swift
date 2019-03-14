//
//  OrdersFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

protocol OrdersFlowControllerDelegate: class {
    func ordersFlowController(_ flowController: OrdersFlowController, didRequestGoingToRestaurant restaurantId: String) -> Future<Bool>
}

class OrdersFlowController: OrdersFlowControllerProtocol {

    weak var delegate: OrdersFlowControllerDelegate!
    private let navigationController: UINavigationController
    public  let parentFlowController: RootFlowControllerProtocol!
    
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
    func goToOrder(orderId: OrderId, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let orderDetails = OrderDetailsViewController.instantiate()
        orderDetails.flowController = self
        navigationController.pushViewController(orderDetails, animated: animated)
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func goToRestaurant(restaurantId: String) -> Future<Bool> {
        return delegate.ordersFlowController(self, didRequestGoingToRestaurant: restaurantId)
    }
    
    @objc func leaveFlow(_ sender: Any) {
        leaveFlow(animated: true)
    }
    
    @discardableResult
    func leaveFlow(animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        navigationController.presentedViewController?.dismiss(animated: animated) {
            promise.setResult(true)
        }
        return promise.future
    }
}
