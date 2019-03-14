//
//  CheckoutFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

protocol CheckoutFlowControllerDelegate: class {
    func checkoutFlowControllerDidRequestGoingBackToSERP(_ flowController: CheckoutFlowController) -> Future<Bool>
    func checkoutFlowController(_ flowController: CheckoutFlowController, didRequestGoingToOrder orderId: OrderId) -> Future <Bool>
}

class CheckoutFlowController: CheckoutFlowControllerProtocol {

    weak var delegate: CheckoutFlowControllerDelegate!
    private let navigationController: UINavigationController
    public let parentFlowController: RestaurantsFlowControllerProtocol!
    
    init(with parentFlowController: RestaurantsFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }

    @discardableResult
    func beginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let checkoutVC = CheckoutViewController.instantiate()
        checkoutVC.flowController = self
        navigationController.viewControllers = [checkoutVC]
        
        let leaveButton = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveFlow(_:)))
        checkoutVC.navigationItem.rightBarButtonItem = leaveButton
        
        viewController.present(navigationController, animated: animated) {
            promise.setResult(true)
        }
        return promise.future
    }
    
    @discardableResult
    func proceedToPayment(animated: Bool) -> Future<Bool> {
        let paymentVC = PaymentViewController.instantiate()
        paymentVC.flowController = self
        navigationController.pushViewController(paymentVC, animated: animated)
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToOrderConfirmation(orderId: OrderId) -> Future<Bool> {
        return leaveFlow(animated: false).then { future in
            self.delegate.checkoutFlowController(self, didRequestGoingToOrder: orderId)
        }
    }
    
    @objc func leaveFlow(_ sender: Any) {
        leaveFlow(animated: true)
    }
    
    @discardableResult
    func leaveFlow(animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        navigationController.presentingViewController?.dismiss(animated: animated) {
            promise.setResult(true)
        }
        return promise.future
    }
    
    @discardableResult
    func leaveFlowAndGoBackToSERP() -> Future<Bool> {
        return leaveFlow(animated: false).then { future in
            self.delegate.checkoutFlowControllerDidRequestGoingBackToSERP(self)
        }
    }
}
