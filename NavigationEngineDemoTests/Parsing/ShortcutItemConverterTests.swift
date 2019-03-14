//
//  ShortcutItemConverterTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
@testable import NavigationEngineDemo

class ShortcutItemConverterTests: XCTestCase {
    
    private var shortcutItemConverter: ShortcutItemConverter!
    private var mockDeepLinkingSettings = MockDeepLinkingSettings()
    
    override func setUp() {
        super.setUp()
        shortcutItemConverter = ShortcutItemConverter(settings: mockDeepLinkingSettings)
    }
    
    func test_serpShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/search")
        let shortcutItem = UIApplicationShortcutItem(type: "/search", localizedTitle: "Search")
        let test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertEqual(target, test)
    }
    
    func test_serpWithPostcodeShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/search?postcode=EC4M7RF")
        let shortcutItem = UIApplicationShortcutItem(type: "/search/EC4M7RF", localizedTitle: "Search")
        let test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertEqual(target, test)
    }
    
    func test_orderHistoryShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/orders")
        let shortcutItem = UIApplicationShortcutItem(type: "/orderHistory", localizedTitle: "Orders")
        let test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertEqual(target, test)
    }
    
    func test_reorderShortcutItem() {
        let target = DeepLink(string: "je-internal://je.com/reorder?orderId=123")
        let shortcutItem = UIApplicationShortcutItem(type: "/reorder/123", localizedTitle: "Reorder")
        let test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertEqual(target, test)
    }
    
    func test_invalidShortcutItem() {
        var shortcutItem = UIApplicationShortcutItem(type: "/invalid", localizedTitle: "Invalid")
        var test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertNil(test)
        
        shortcutItem = UIApplicationShortcutItem(type: "invalid", localizedTitle: "Invalid")
        test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertNil(test)
        
        shortcutItem = UIApplicationShortcutItem(type: "/invalid/123", localizedTitle: "Invalid")
        test = shortcutItemConverter.deepLink(forShortcutItem: shortcutItem)
        XCTAssertNil(test)
    }
}
