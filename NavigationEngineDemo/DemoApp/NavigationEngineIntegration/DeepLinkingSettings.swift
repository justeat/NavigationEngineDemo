//
//  DeepLinkingSettings.swift
//  NavigationEngineDemo
//
//  Created by Alberto De Bortoli on 04/02/2019.
//  Copyright © 2019 Just Eat. All rights reserved.
//

import Foundation

class DeepLinkingSettings: DeepLinkingSettingsProtocol {
    
    var universalLinkSchemes = ["http", "https"]
    var universalLinkHosts = ["just-eat.co.uk", "www.just-eat.co.uk"]
    
    var internalDeepLinkSchemes = ["je-internal", "justeat", "just-eat", "just-eat-uk"]
    var internalDeepLinkHost = "je.com"
}
