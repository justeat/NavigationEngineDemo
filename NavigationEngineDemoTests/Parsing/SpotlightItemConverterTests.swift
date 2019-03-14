//
//  SpotlightItemConverterTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
import CoreSpotlight
@testable import NavigationEngineDemo

class SpotlightItemConverterTests: XCTestCase {
    
    private var spotlightItemConverter: SpotlightItemConverter!
    private var mockDeepLinkingSettings = MockDeepLinkingSettings()
    
    override func setUp() {
        super.setUp()
        spotlightItemConverter = SpotlightItemConverter(settings: mockDeepLinkingSettings)
    }
    
    func test_restaurantShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=456")
        let spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/restaurant/456"])
        let test = spotlightItemConverter.deepLink(forSpotlightItem: spotlightItem)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetailsShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/orderDetails/123"])
        let test = spotlightItemConverter.deepLink(forSpotlightItem: spotlightItem)
        XCTAssertEqual(target, test)
    }
    
    func test_invalidShortcutItem() {
        var spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/invalid"])
        var test = spotlightItemConverter.deepLink(forSpotlightItem: spotlightItem)
        XCTAssertNil(test)
        
        spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "invalid"])
        test = spotlightItemConverter.deepLink(forSpotlightItem: spotlightItem)
        XCTAssertNil(test)
        
        spotlightItem = MockNSUserActivity(activityType: CSSearchableItemActionType, userInfo: [CSSearchableItemActivityIdentifier: "/invalid/123"])
        test = spotlightItemConverter.deepLink(forSpotlightItem: spotlightItem)
        XCTAssertNil(test)
    }
}
