//
//  DeepLinkingFacadeTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
import CoreSpotlight
@testable import NavigationEngineDemo

class DeepLinkingFacadeTests: XCTestCase {
    
    private let timeout = 3.0
    private var deepLinkingFacade: DeepLinkingFacade!
    
    override func setUp() {
        let rootFlowController = MockRootFlowController()
        rootFlowController.setup()
        let flowControllerProvider = FlowControllerProvider(rootFlowController: rootFlowController)
        let navigationTransitionerDataSource = MockNavigationTransitionerDataSource(shouldSucceed: true)
        let settings = MockDeepLinkingSettings()
        let userStatusProvider = MockUserStatusProvider(userStatus: .loggedOut)
        deepLinkingFacade = DeepLinkingFacade(flowControllerProvider: flowControllerProvider,
                                              navigationTransitionerDataSource: navigationTransitionerDataSource,
                                              settings: settings,
                                              userStatusProvider: userStatusProvider)
    }
    
    func test_handleUniversalLink_success() {
        let expectation = self.expectation(description: #function)
        let url = URL(string: "http://just-eat.co.uk/home")!
        deepLinkingFacade.handleURL(url).finally { future in
            XCTAssertTrue(future.hasResult())
            XCTAssertEqual(future.result!, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_handleUniversalLink_failure() {
        let expectation = self.expectation(description: #function)
        let url = URL(string: "http://just-eat.com/invalid")!
        deepLinkingFacade.handleURL(url).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, DeepLinkingFacade.domain)
            XCTAssertEqual(error.code, DeepLinkingFacade.ErrorCode.couldNotHandleURL.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openDeepLink_success() {
        let expectation = self.expectation(description: #function)
        let deepLink = DeepLink(string: "je-internal://just-eat.com/home")!
        deepLinkingFacade.openDeepLink(deepLink).finally { future in
            XCTAssertTrue(future.hasResult())
            XCTAssertEqual(future.result!, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openDeepLink_failure() {
        let expectation = self.expectation(description: #function)
        let deepLink = DeepLink(string: "je-internal://just-eat.com/invalid")!
        deepLinkingFacade.openDeepLink(deepLink).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, DeepLinkingFacade.domain)
            XCTAssertEqual(error.code, DeepLinkingFacade.ErrorCode.couldNotHandleDeepLink.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openSpotlightItem_success() {
        let expectation = self.expectation(description: #function)
        let spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/restaurant/456"])
        deepLinkingFacade.openSpotlightItem(spotlightItem).finally { future in
            XCTAssertTrue(future.hasResult())
            XCTAssertEqual(future.result!, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openSpotlightItem_failure() {
        let expectation = self.expectation(description: #function)
        let spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/invalid"])
        deepLinkingFacade.openSpotlightItem(spotlightItem).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, DeepLinkingFacade.domain)
            XCTAssertEqual(error.code, DeepLinkingFacade.ErrorCode.couldNotDeepLinkFromSpotlightItem.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openShortcutItem_success() {
        let expectation = self.expectation(description: #function)
        let shortcutItem = UIApplicationShortcutItem(type: "/search", localizedTitle: "Search")
        deepLinkingFacade.openShortcutItem(shortcutItem).finally { future in
            XCTAssertTrue(future.hasResult())
            XCTAssertEqual(future.result!, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_openShortcutItem_failure() {
        let expectation = self.expectation(description: #function)
        let shortcutItem = UIApplicationShortcutItem(type: "/invalid", localizedTitle: "Invalid")
        deepLinkingFacade.openShortcutItem(shortcutItem).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, DeepLinkingFacade.domain)
            XCTAssertEqual(error.code, DeepLinkingFacade.ErrorCode.couldNotDeepLinkFromShortcutItem.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}
