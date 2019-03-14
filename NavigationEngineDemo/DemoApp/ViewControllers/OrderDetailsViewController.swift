//
//  OrderDetailsViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController, Storyboarding {
    
    var flowController: OrdersFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func goToRestaurantButtonTapped(_ sender: Any) {
        flowController.goToRestaurant(restaurantId: "")
    }
}
