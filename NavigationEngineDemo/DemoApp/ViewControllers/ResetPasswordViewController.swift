//
//  ResetPasswordViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 05/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController, Storyboarding {
    
    var flowController: AccountFlowController!
    var token: ResetPasswordToken!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
}
