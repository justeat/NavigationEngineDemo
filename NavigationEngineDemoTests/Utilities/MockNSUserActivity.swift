//
//  MockNSUserActivity.swift
//  NavigationEngine
//
//  Created by Alberto De Bortoli on 11/02/2019.
//

import Foundation
@testable import NavigationEngineDemo

class MockNSUserActivity: NSUserActivityProtocol {
    
    var activityType: String
    var userInfo: [AnyHashable : Any]?
    
    init(activityType: String, userInfo: [AnyHashable : Any]?) {
        self.activityType = activityType
        self.userInfo = userInfo
    }
}
