//
//  SerpViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class SerpViewController: UIViewController, Storyboarding {
    
    var flowController: RestaurantsFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func restaurantSelected(_ sender: Any) {
        flowController.goToRestaurant(restaurantId: "", postcode: nil, serviceType: nil, section: nil, animated: true)
    }
}
