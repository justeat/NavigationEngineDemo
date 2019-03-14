//
//  NavigationIntentFactoryTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
@testable import NavigationEngineDemo

class NavigationIntentFactoryTests: XCTestCase {
    
    private let navigationIntentFactory = NavigationIntentFactory()
    
    func test_home() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/home")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToHome
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_login1() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/login")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToLogin
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_login2() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/account/login")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToLogin
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_resetPassword() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/resetPassword?resetToken=123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToResetPassword("123")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_serp() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/search")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToSearch(nil, nil)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_serpWithPostcode() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/search?postcode=EC4M7RF")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToSearch("EC4M7RF", nil)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_serpWithPostcodeAndCuisine() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/search?postcode=EC4M7RF&cuisine=italian")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToSearch("EC4M7RF", "italian")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_restaurant() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/restaurant?restaurantId=123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToRestaurant("123", nil, nil, nil)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_restaurantWithPostcode() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/restaurant?restaurantId=123&postcode=EC4M7RF")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToRestaurant("123", "EC4M7RF", nil, nil)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_restaurantWithPostcodeAndServiceType() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToRestaurant("123", "EC4M7RF", .delivery, nil)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_restaurantWithPostcodeAndServiceTypeAndSection() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery&section=menu")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToRestaurant("123", "EC4M7RF", .delivery, .menu)
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_orderHistory1() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/orderHistory")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToOrderHistory
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_orderHistory2() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/order-history")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToOrderHistory
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_orderHistory3() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/orders")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToOrderHistory
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_orderDetails1() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/order?orderId=123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToOrderDetails("123")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_orderDetails2() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/order/123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToOrderDetails("123")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_reorder1() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/reorder?orderId=123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToReorder("123")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_reorder2() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/reorder/123")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToReorder("123")
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_settings() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/settings")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result(let intent):
            let target = NavigationIntent.goToSettings
            XCTAssertEqual(intent, target)
        default:
            XCTFail("Factory should have produced an intent")
        }
    }
    
    func test_unsupported1() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/invalid")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result:
            XCTFail("Factory should have produced an error")
        case .error(let error as NSError):
            XCTAssertEqual(error.domain, NavigationIntentFactory.domain)
            XCTAssertEqual(error.code, NavigationIntentFactory.ErrorCode.unsupportedURL.rawValue)
        }
    }
    
    func test_unsupported2() {
        let deepLink = DeepLink(string: "je-internal://just-eat.com/invalid/kfc")!
        let result = navigationIntentFactory.intent(for: deepLink)
        switch result {
        case .result:
            XCTFail("Factory should have produced an error")
        case .error(let error as NSError):
            XCTAssertEqual(error.domain, NavigationIntentFactory.domain)
            XCTAssertEqual(error.code, NavigationIntentFactory.ErrorCode.unsupportedURL.rawValue)
        }
    }
}
