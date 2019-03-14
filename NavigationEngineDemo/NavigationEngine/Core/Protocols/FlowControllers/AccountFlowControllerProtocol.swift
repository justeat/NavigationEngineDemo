//
//  AccountFlowControllerProtocol.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 05/02/2019.
//

import Foundation
import Promis

public protocol AccountFlowControllerProtocol {
    
    var parentFlowController: RootFlowControllerProtocol! { get }
    
    @discardableResult func beginLoginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool>
    @discardableResult func waitForUserToLogin(from viewController: UIViewController, animated: Bool) -> Future<Bool>
    @discardableResult func beginResetPasswordFlow(from viewController: UIViewController, token: ResetPasswordToken, animated: Bool) -> Future<Bool>
    @discardableResult func leaveFlow(animated: Bool) -> Future<Bool>
}
