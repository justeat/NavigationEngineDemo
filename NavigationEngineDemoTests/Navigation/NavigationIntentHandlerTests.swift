//
//  NavigationIntentHandlerTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
@testable import NavigationEngineDemo

class NavigationIntentHandlerTests: XCTestCase {
    
    private let timeout = 3.0
    private var navigationIntentHandler: NavigationIntentHandler!
    
    func setUp(userStatus: UserStatus, dataSourceShouldSucceed: Bool = true) {
        let rootFlowController = MockRootFlowController()
        rootFlowController.setup()
        let flowControllerProvider = FlowControllerProvider(rootFlowController: rootFlowController)
        let userStatusProvider = MockUserStatusProvider(userStatus: userStatus)
        let navigationTransitionerDataSource = MockNavigationTransitionerDataSource(shouldSucceed: dataSourceShouldSucceed, userStatusProvider: userStatusProvider)
        navigationIntentHandler = NavigationIntentHandler(flowControllerProvider: flowControllerProvider,
                                                          userStatusProvider: userStatusProvider,
                                                          navigationTransitionerDataSource: navigationTransitionerDataSource)
    }
    
    func test_goToHome() {
        wait(for: [
            goToHome(status: .loggedOut, shouldSucceed: true),
            goToHome(status: .loggedIn, shouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToLogin() {
        wait(for: [
            goToLogin(status: .loggedOut, shouldSucceed: true),
            goToLogin(status: .loggedIn, shouldSucceed: false)
            ], timeout: timeout)
    }
    
    func test_goToResetPassword() {
        wait(for: [
            goToResetPassword(status: .loggedOut, shouldSucceed: true),
            goToResetPassword(status: .loggedIn, shouldSucceed: false)
            ], timeout: timeout)
    }
    
    func test_goToSearch() {
        wait(for: [
            goToSearch(status: .loggedOut, shouldSucceed: true),
            goToSearch(status: .loggedIn, shouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToRestaurant() {
        wait(for: [
            goToRestaurant(status: .loggedOut, shouldSucceed: true),
            goToRestaurant(status: .loggedIn, shouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToOrderHistory() {
        wait(for: [
            goToOrderHistory(status: .loggedOut, shouldSucceed: false, dataSourceShouldSucceed: false),
            goToOrderHistory(status: .loggedOut, shouldSucceed: true, dataSourceShouldSucceed: true),
            goToOrderHistory(status: .loggedIn, shouldSucceed: true, dataSourceShouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToOrderDetails() {
        wait(for: [
            goToOrderDetails(status: .loggedOut, shouldSucceed: false, dataSourceShouldSucceed: false),
            goToOrderDetails(status: .loggedOut, shouldSucceed: true, dataSourceShouldSucceed: true),
            goToOrderDetails(status: .loggedIn, shouldSucceed: true, dataSourceShouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToSettings() {
        wait(for: [
            goToSettings(status: .loggedOut, shouldSucceed: true),
            goToSettings(status: .loggedIn, shouldSucceed: true)
            ], timeout: timeout)
    }
    
    func test_goToReorder() {
        wait(for: [
            goToReorder(status: .loggedOut, shouldSucceed: false, dataSourceShouldSucceed: false),
            goToReorder(status: .loggedOut, shouldSucceed: true, dataSourceShouldSucceed: true),
            goToReorder(status: .loggedIn, shouldSucceed: true, dataSourceShouldSucceed: true)
            ], timeout: timeout)
    }
}

extension NavigationIntentHandlerTests {
    
    fileprivate func goToHome(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToHome).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToLogin(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToLogin).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToResetPassword(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToResetPassword("")).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToSearch(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToSearch(nil, nil)).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToRestaurant(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToRestaurant("", nil, nil, nil)).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToReorder(status: UserStatus, shouldSucceed: Bool, dataSourceShouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status, dataSourceShouldSucceed: dataSourceShouldSucceed)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToReorder("")).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToOrderHistory(status: UserStatus, shouldSucceed: Bool, dataSourceShouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status, dataSourceShouldSucceed: dataSourceShouldSucceed)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToOrderHistory).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToOrderDetails(status: UserStatus, shouldSucceed: Bool, dataSourceShouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status, dataSourceShouldSucceed: dataSourceShouldSucceed)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToOrderDetails("")).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
    
    fileprivate func goToSettings(status: UserStatus, shouldSucceed: Bool) -> XCTestExpectation {
        setUp(userStatus: status)
        let expectation = self.expectation(description: #function)
        navigationIntentHandler.handleIntent(.goToSettings).finally { future in
            XCTAssert(shouldSucceed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
        return expectation
    }
}
