//
//  MockUserStatusProvider.swift
//  NavigationEngine-Unit-Tests
//
//  Created by Alberto De Bortoli on 12/02/2019.
//

import Foundation
@testable import NavigationEngineDemo

class MockUserStatusProvider: UserStatusProviding {
    
    var userStatus: UserStatus
    
    init(userStatus: UserStatus) {
        self.userStatus = userStatus
    }
}
