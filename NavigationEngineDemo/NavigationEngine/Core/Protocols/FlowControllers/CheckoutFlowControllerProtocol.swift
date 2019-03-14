//
//  CheckoutFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

public protocol CheckoutFlowControllerProtocol {

    var parentFlowController: RestaurantsFlowControllerProtocol! { get }
    
    @discardableResult func beginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool>
    @discardableResult func proceedToPayment(animated: Bool) -> Future<Bool>
    @discardableResult func goToOrderConfirmation(orderId: OrderId) -> Future<Bool>
    @discardableResult func leaveFlow(animated: Bool) -> Future<Bool>
    @discardableResult func leaveFlowAndGoBackToSERP() -> Future<Bool>
}
