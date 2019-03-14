//
//  Storyboarding.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/01/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import UIKit

protocol Storyboarding {
    static func instantiate() -> Self
}

extension Storyboarding where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
