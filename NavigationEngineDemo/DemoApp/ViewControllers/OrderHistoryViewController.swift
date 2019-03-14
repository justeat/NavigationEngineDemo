//
//  OrderHistoryViewController.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 23/11/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {
    
    var flowController: OrdersFlowController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(NSStringFromClass(type(of: self)).split(separator: ".").last!)
    }
    
    @IBAction func orderSelected(_ sender: Any) {
        flowController.goToOrder(orderId: "", animated: true)
    }
}
