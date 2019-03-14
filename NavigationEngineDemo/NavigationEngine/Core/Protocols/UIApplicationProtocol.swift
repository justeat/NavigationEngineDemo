//
//  UIApplicationProtocol.swift
//  Location
//
//  Created by Alberto De Bortoli on 06/02/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import UIKit

protocol UIApplicationProtocol {
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
}
