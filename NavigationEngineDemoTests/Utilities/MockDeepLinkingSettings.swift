//
//  MockDeepLinkingSettings.swift
//  Pods
//
//  Created by Alberto De Bortoli on 10/02/2019.
//

import Foundation
import NavigationEngineDemo

class MockDeepLinkingSettings: DeepLinkingSettingsProtocol {
    
    var universalLinkSchemes = ["http", "https"]
    var universalLinkHosts = ["just-eat.co.uk", "www.just-eat.co.uk"]
    
    var internalDeepLinkSchemes = ["je-internal", "justeat", "just-eat", "just-eat-uk"]
    var internalDeepLinkHost = "je.com"
}
