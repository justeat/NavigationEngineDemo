//
//  RestaurantViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, Storyboarding {
    
    var flowController: RestaurantsFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func basketButtonSelected(_ sender: Any) {
        flowController.goToBasket(reorderId: "", animated: true)
    }
}
