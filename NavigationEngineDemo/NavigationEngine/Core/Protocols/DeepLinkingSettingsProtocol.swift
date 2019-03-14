//
//  DeepLinkingSettingsProtocol.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation

public protocol DeepLinkingSettingsProtocol {
    
    var universalLinkSchemes: [String] { get }
    var universalLinkHosts: [String] { get }
    
    var internalDeepLinkSchemes: [String] { get }
    var internalDeepLinkHost: String { get }
}
