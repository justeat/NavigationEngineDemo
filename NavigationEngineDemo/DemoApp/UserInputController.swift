//
//  UserInputController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 01/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation
import Promis

class UserInputController {
    
    private let domain = "com.justeat.userInputController"
    
    private enum ErrorCode: Int {
        case abortUserInput
        case abortFakeLogin
    }
    
    private let userStatusProvider: UserStatusProvider
    
    init(userStatusProvider: UserStatusProvider) {
        self.userStatusProvider = userStatusProvider
    }
    
    func gatherReorderUserInput() -> Future<ReorderInfo> {
        let promise = Promise<ReorderInfo>()
        
        showReorderUserInputAlert { input in
            if let input = input {
                promise.setResult(input)
            }
            else {
                let error = NSError(domain: self.domain, code: ErrorCode.abortUserInput.rawValue, userInfo: nil)
                promise.setError(error)
            }
        }
        
        return promise.future
    }
    
    func promptUserForLogin() -> Future<Bool> {
        let promise = Promise<Bool>()
        
        showLoginUserAlert { success in
            if success {
                self.userStatusProvider.userStatus = .loggedIn
                promise.setResult(true)
            }
            else {
                let error = NSError(domain: self.domain, code: ErrorCode.abortFakeLogin.rawValue, userInfo: nil)
                promise.setError(error)
            }
        }
        
        return promise.future
    }
    
    private func showReorderUserInputAlert(handler: @escaping (ReorderInfo?) -> Void) {
        let alert = UIAlertController(title: "Reorder user input", message: "Please enter the reorder required values", preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .default) { _ in
            let postcode = (alert.textFields![0] as UITextField).text ?? ""
            let restaurantId = (alert.textFields![1] as UITextField).text ?? ""
            let serviceType = ServiceType(rawValue: (alert.textFields![2] as UITextField).text ?? "") ?? ServiceType.delivery
            let reorderInfo = ReorderInfo(restaurantId: restaurantId, postcode: postcode, serviceType: serviceType)
            handler(reorderInfo)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            handler(nil)
        }
        alert.addAction(action)
        alert.addAction(action2)
        
        alert.addTextField { textField in
            textField.placeholder = "postcode"
        }
        alert.addTextField { textField in
            textField.placeholder = "seo name"
        }
        alert.addTextField { textField in
            textField.placeholder = "service type"
        }
        
        presentAlert(alert)
    }
    
    private func showLoginUserAlert(handler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Fake login", message: "Proceed to faking a user login", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { _ in
            handler(true)
        }
        let action2 = UIAlertAction(title: "No", style: .cancel) { _ in
            handler(false)
        }
        alert.addAction(action)
        alert.addAction(action2)
        presentAlert(alert)
    }
    
    private func presentAlert(_ alert: UIAlertController) {
        let presentingViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        if let presentedViewController = presentingViewController.presentedViewController {
            presentedViewController.present(alert, animated: true) { }
        }
        else {
            presentingViewController.present(alert, animated: true) { }
        }
    }
}
