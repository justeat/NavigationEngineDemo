//
//  NavigationTransitionerTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
import Promis
@testable import NavigationEngineDemo

class NavigationTransitionerTests: XCTestCase {
    
    private let timeout = 3.0
    
    private var flowControllerProvider: FlowControllerProvider!
    private var navigationTransitioner: NavigationTransitioner!
    private var navigationTransitionerDataSource: MockNavigationTransitionerDataSource!
    
    override func setUp() {
        super.setUp()
        let rootFlowController = MockRootFlowController()
        rootFlowController.setup()
        flowControllerProvider = FlowControllerProvider(rootFlowController: rootFlowController)
    }
    
    func test_goToRoot() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToRoot(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation1)
        goToRoot(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        goToRoot(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goToHome() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToHome(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation1)
        goToHome(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        goToHome(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goToLogin() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToLogin(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation1)
        goToLogin(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation2)
        goToLogin(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goToResetPassword() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToResetPassword(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation1)
        goToResetPassword(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation2)
        goToResetPassword(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goFromHomeToSerp() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goFromHomeToSerp(setUpTransitionerWithBasicTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation1)
        goFromHomeToSerp(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation2)
        goFromHomeToSerp(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goFromHomeToRestaurant() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goFromHomeToRestaurant(setUpTransitionerWithBasicTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation1)
        goFromHomeToRestaurant(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation2)
        goFromHomeToRestaurant(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .home), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goFromSerpToRestaurant() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goFromSerpToRestaurant(setUpTransitionerWithBasicTransitions(initialState: .search), shouldBeAllowed: true, expectation: expectation1)
        goFromSerpToRestaurant(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .search), shouldBeAllowed: true, expectation: expectation2)
        goFromSerpToRestaurant(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .search), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goFromRestaurantToBasket() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goFromRestaurantToBasket(setUpTransitionerWithBasicTransitions(initialState: .restaurant), shouldBeAllowed: false, expectation: expectation1)
        goFromRestaurantToBasket(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .restaurant), shouldBeAllowed: true, expectation: expectation2)
        goFromRestaurantToBasket(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .restaurant), shouldBeAllowed: false, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }

    func test_goToOrderHistory() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToOrderHistory(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation1)
        goToOrderHistory(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        goToOrderHistory(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goFromOrderHistoryToOrderDetails() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goFromOrderHistoryToOrderDetails(setUpTransitionerWithBasicTransitions(initialState: .orderHistory), shouldBeAllowed: false, expectation: expectation1)
        goFromOrderHistoryToOrderDetails(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .orderHistory), shouldBeAllowed: true, expectation: expectation2)
        goFromOrderHistoryToOrderDetails(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .orderHistory), shouldBeAllowed: false, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_goToSettings() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        goToSettings(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation1)
        goToSettings(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        goToSettings(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_requestInputForReorder_allowed() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        requestInputForReorder(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation1)
        requestInputForReorder(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        requestInputForReorder(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_requestInputForReorder_notAllowed() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        requestInputForReorder(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation1)
        requestInputForReorder(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation2)
        requestInputForReorder(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_requestUserToLogin_allowed() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        requestUserToLogin(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation1)
        requestUserToLogin(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation2)
        requestUserToLogin(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: true, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
    
    func test_requestUserToLogin_notAllowed() {
        let expectation1 = expectation(description: #function)
        let expectation2 = expectation(description: #function)
        let expectation3 = expectation(description: #function)
        requestUserToLogin(setUpTransitionerWithBasicTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation1)
        requestUserToLogin(setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation2)
        requestUserToLogin(setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: .allPoppedToRoot), shouldBeAllowed: false, expectation: expectation3)
        wait(for: [expectation1, expectation2, expectation3], timeout: timeout)
    }
}
    
extension NavigationTransitionerTests {
    
    fileprivate func goToRoot(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToRoot(animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goToHome(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToHome(animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goToLogin(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToLogin(animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goToResetPassword(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToResetPassword(token: "<token>", animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goFromHomeToSerp(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goFromHomeToSearch(postcode: "", cuisine: "", animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goFromHomeToRestaurant(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goFromHomeToRestaurant(restaurantId: "", postcode: "", serviceType: .delivery, section: nil, animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goFromSerpToRestaurant(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goFromSearchToRestaurant(restaurantId: "", postcode: "", serviceType: .delivery, section: nil, animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goFromRestaurantToBasket(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goFromRestaurantToBasket(reorderId: "", animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goToOrderHistory(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToOrderHistory(animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goFromOrderHistoryToOrderDetails(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goFromOrderHistoryToOrderDetails(orderId: "", animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func goToSettings(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitioner.goToSettings(animated: false).finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func requestInputForReorder(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitionerDataSource = MockNavigationTransitionerDataSource(shouldSucceed: shouldBeAllowed)
        navigationTransitioner.dataSource = navigationTransitionerDataSource
        navigationTransitioner.requestInputForReorder(orderId: "").finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
    
    fileprivate func requestUserToLogin(_ autoclosure: @autoclosure () -> Void, shouldBeAllowed: Bool, expectation: XCTestExpectation) {
        autoclosure()
        navigationTransitionerDataSource = MockNavigationTransitionerDataSource(shouldSucceed: shouldBeAllowed)
        navigationTransitioner.dataSource = navigationTransitionerDataSource
        navigationTransitioner.requestUserToLogin().finally { future in
            XCTAssertTrue(shouldBeAllowed ? future.hasResult() : future.hasError())
            expectation.fulfill()
        }
    }
}

extension NavigationTransitionerTests {
    
    fileprivate func setUpTransitionerWithBasicTransitions(initialState: StateType) {
        let stateMachine = StateMachine(initialState: initialState, allowedTransitions: [.basicTransitions])
        navigationTransitioner = NavigationTransitioner(flowControllerProvider: flowControllerProvider, stateMachine: stateMachine)
    }
    
    fileprivate func setUpTransitionerWithBasicAndUserLoggedInTransitions(initialState: StateType) {
        let stateMachine = StateMachine(initialState: initialState, allowedTransitions: [.basicTransitions, .userLoggedIn])
        navigationTransitioner = NavigationTransitioner(flowControllerProvider: flowControllerProvider, stateMachine: stateMachine)
    }
    
    fileprivate func setUpTransitionerWithBasicAndUserLoggedOutTransitions(initialState: StateType) {
        let stateMachine = StateMachine(initialState: initialState, allowedTransitions: [.basicTransitions, .userLoggedOut])
        navigationTransitioner = NavigationTransitioner(flowControllerProvider: flowControllerProvider, stateMachine: stateMachine)
    }
}
