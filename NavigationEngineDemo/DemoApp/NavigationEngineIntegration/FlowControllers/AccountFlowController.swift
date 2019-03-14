//
//  AccountFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 05/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation
import Promis

class AccountFlowController: AccountFlowControllerProtocol {
    
    private let navigationController: UINavigationController
    public let parentFlowController: RootFlowControllerProtocol!
    
    init(with parentFlowController: RootFlowControllerProtocol, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }
    
    @discardableResult
    func beginLoginFlow(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let loginVC = LoginViewController.instantiate()
        loginVC.flowController = self
        navigationController.viewControllers = [loginVC]
        
        let leaveButton = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveFlow(_:)))
        loginVC.navigationItem.rightBarButtonItem = leaveButton
        
        viewController.present(navigationController, animated: animated)
        
        promise.setResult(true)
        return promise.future
    }
    
    @discardableResult
    func waitForUserToLogin(from viewController: UIViewController, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let loginVC = LoginViewController.instantiate()
        loginVC.flowController = self
        navigationController.viewControllers = [loginVC]
        
        let leaveButton = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveFlow(_:)))
        loginVC.navigationItem.rightBarButtonItem = leaveButton
        
        viewController.present(navigationController, animated: animated) {
            promise.setResult(true)
        }
        return promise.future
    }
    
    @discardableResult
    func beginResetPasswordFlow(from viewController: UIViewController, token: ResetPasswordToken, animated: Bool) -> Future<Bool> {
        let promise = Promise<Bool>()
        let resetPswVC = ResetPasswordViewController.instantiate()
        resetPswVC.flowController = self
        resetPswVC.token = token
        navigationController.viewControllers = [resetPswVC]
        
        let leaveButton = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(leaveFlow(_:)))
        resetPswVC.navigationItem.rightBarButtonItem = leaveButton
        
        viewController.present(navigationController, animated: animated) {
            promise.setResult(true)
        }
        return promise.future
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
}
