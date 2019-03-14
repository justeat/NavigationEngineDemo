//
//  BasketViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController, Storyboarding {
    
    var flowController: RestaurantsFlowController!
    private var checkoutFlowController: CheckoutFlowController!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func checkoutButtonSelected(_ sender: Any) {
        flowController.goToCheckout(animated: true)
    }
}
