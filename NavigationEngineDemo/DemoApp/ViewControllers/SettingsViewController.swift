//
//  SettingsViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var flowController: SettingsFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func privacyPolicySelected(_ sender: Any) {
        flowController.goToPrivacyPolicy()
    }
}
