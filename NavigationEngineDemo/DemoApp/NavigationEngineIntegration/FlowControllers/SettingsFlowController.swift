//
//  SettingsFlowController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit
import Promis

class SettingsFlowController: SettingsFlowControllerProtocol {

    private let navigationController: UINavigationController
    public let parentFlowController: RootFlowControllerProtocol!
    
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
        navigationController.popToRootViewController(animated: animated)
        return Future<Bool>.future(withResult: true)
    }
    
    @discardableResult
    func goToPrivacyPolicy() -> Future<Bool> {
        let privacyPolicy = PrivacyPolicyViewController.instantiate()
        privacyPolicy.flowController = self
        navigationController.pushViewController(privacyPolicy, animated: true)
        return Future<Bool>.future(withResult: true)
    }
}
