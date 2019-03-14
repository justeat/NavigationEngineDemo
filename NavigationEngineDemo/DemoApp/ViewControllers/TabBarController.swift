//
//  TabBarController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, Storyboarding {

    weak var flowController: RootFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
        flowController.setup()
    }
}
