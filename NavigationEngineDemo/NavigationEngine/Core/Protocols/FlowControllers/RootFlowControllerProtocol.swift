//
//  RootFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

public protocol RootFlowControllerProtocol {

    var restaurantsFlowController: RestaurantsFlowControllerProtocol! { get }
    var ordersFlowController: OrdersFlowControllerProtocol! { get }
    var settingsFlowController: SettingsFlowControllerProtocol! { get }
    var accountFlowController: AccountFlowControllerProtocol! { get }
    
    func setup()
    
    @discardableResult func dismissAll(animated: Bool) -> Future<Bool>
    @discardableResult func dismissAndPopToRootAll(animated: Bool) -> Future<Bool>
    @discardableResult func goToLogin(animated: Bool) -> Future<Bool>
    @discardableResult func goToResetPassword(token: ResetPasswordToken, animated: Bool) -> Future<Bool>
    @discardableResult func goToRestaurantsSection() -> Future<Bool>
    @discardableResult func goToOrdersSection() -> Future<Bool>
    @discardableResult func goToSettingsSection() -> Future<Bool>
}
