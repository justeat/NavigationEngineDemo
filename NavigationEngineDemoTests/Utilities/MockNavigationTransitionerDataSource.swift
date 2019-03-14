//
//  MockNavigationTransitionerDataSource.swift
//  NavigationEngine-Unit-Tests
//
//  Created by Alberto De Bortoli on 11/02/2019.
//

import Foundation
import Promis
@testable import NavigationEngineDemo

class MockNavigationTransitionerDataSource: NavigationTransitionerDataSource {
    
    private let shouldSucceed: Bool
    private let userStatusProvider: MockUserStatusProvider?
    
    init(shouldSucceed: Bool, userStatusProvider: MockUserStatusProvider? = nil) {
        self.shouldSucceed = shouldSucceed
        self.userStatusProvider = userStatusProvider
    }
    
    func navigationTransitionerDidRequestInputForReorder(orderId: OrderId) -> Future<ReorderInfo> {
        if shouldSucceed {
            let reorderInfo = ReorderInfo(restaurantId: "", postcode: "", serviceType: .delivery)
            return Future<ReorderInfo>.future(withResult: reorderInfo)
        }
        else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            return Future<ReorderInfo>.future(withError: error)
        }
    }
    
    func navigationTransitionerDidRequestUserToLogin() -> Future<Bool> {
        if shouldSucceed {
            userStatusProvider?.userStatus = .loggedIn
            return Future<Bool>.future(withResult: true)
        }
        else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            return Future<Bool>.future(withError: error)
        }
    }
}
