//
//  FlowControllerProviderTests.swift
//  NavigationEngine-Unit-Tests
//
//  Created by Alberto De Bortoli on 11/02/2019.
//

import XCTest
import Stateful
@testable import NavigationEngineDemo

class FlowControllerProviderTests: XCTestCase {
    
    private var flowControllerProvider: FlowControllerProvider!
    private let rootFlowController = MockRootFlowController()
    
    override func setUp() {
        super.setUp()
        rootFlowController.setup()
        flowControllerProvider = FlowControllerProvider(rootFlowController: rootFlowController)
    }
    
    func test_rootFlowController() {
        let fc1 = flowControllerProvider.rootFlowController as! MockRootFlowController
        let fc2 = rootFlowController
        XCTAssert(fc1 === fc2)
    }
    
    func test_restaurantsFlowController() {
        let fc1 = flowControllerProvider.restaurantsFlowController as! MockRestaurantsFlowController
        let fc2 = rootFlowController.restaurantsFlowController as! MockRestaurantsFlowController
        XCTAssert(fc1 === fc2)
    }
    
    func test_checkoutFlowController() {
        let fc1 = flowControllerProvider.checkoutFlowController as! MockCheckoutFlowController
        let fc2 = rootFlowController.restaurantsFlowController.checkoutFlowController as! MockCheckoutFlowController
        XCTAssert(fc1 === fc2)
    }
    
    func test_ordersFlowController() {
        let fc1 = flowControllerProvider.ordersFlowController as! MockOrdersFlowController
        let fc2 = rootFlowController.ordersFlowController as! MockOrdersFlowController
        XCTAssert(fc1 === fc2)
    }
    
    func test_settingsFlowController() {
        let fc1 = flowControllerProvider.settingsFlowController as! MockSettingsFlowController
        let fc2 = rootFlowController.settingsFlowController as! MockSettingsFlowController
        XCTAssert(fc1 === fc2)
    }
}
