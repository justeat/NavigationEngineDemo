//
//  NavigationIntentHandling.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 28/12/2018.
//  Copyright © 2018 Just Eat. All rights reserved.
//

import Foundation
import Promis

protocol NavigationIntentHandling {
    
    func handleIntent(_ intent: NavigationIntent) -> Future<Bool>
}
