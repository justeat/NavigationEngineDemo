//
//  UniversalLinkConverterTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
@testable import NavigationEngineDemo

class UniversalLinkConverterTests: XCTestCase {
    
    private var universalLinkConverter: UniversalLinkConverter!
    private var deepLinkingSettings = MockDeepLinkingSettings()
    
    override func setUp() {
        super.setUp()
        universalLinkConverter = UniversalLinkConverter(settings: deepLinkingSettings)
    }
    
    func test_root() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk")!
        let target = DeepLink(string: "je-internal://je.com/home")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_root2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/")!
        let target = DeepLink(string: "je-internal://je.com/home")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_home() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/home")!
        let target = DeepLink(string: "je-internal://je.com/home")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_login1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/login")!
        let target = DeepLink(string: "je-internal://je.com/login")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_login2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/account/login")!
        let target = DeepLink(string: "je-internal://je.com/login")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcode1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcode2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7-CityThameslink")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcodeAndLocation() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7-CityThameslink?lat=45.951342&long=12.497958")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7&lat=45.951342&long=12.497958")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcodeAndCuisine1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7-CityThameslink/italian")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7&cuisine=italian")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcodeAndCuisine2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7-CityThameslink?cuisine=italian")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7&cuisine=italian")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_areaWithPostcodeAndCuisineAndLocation() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/area/ECM7-CityThameslink?cuisine=italian&lat=45.951342&long=12.497958")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=ECM7&cuisine=italian&lat=45.951342&long=12.497958")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_serp() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/search")!
        let target = DeepLink(string: "je-internal://je.com/search")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_serpWithPostcode() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/search?postcode=EC4M7RF")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=EC4M7RF")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_serpWithPostcodeAndCuisine() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/search?postcode=EC4M7RF&cuisine=italian")!
        let target = DeepLink(string: "je-internal://je.com/search?postcode=EC4M7RF&cuisine=italian")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurant() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantWithPostcode() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123&postcode=EC4M7RF")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123&postcode=EC4M7RF")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantWithPostcodeAndServiceType() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantWithMenuSection() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123&section=menu")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123&section=menu")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantWithReviewSection() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123&section=reviews")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123&section=reviews")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantWithInfoSection() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/restaurant?restaurantId=123&section=info")!
        let target = DeepLink(string: "je-internal://je.com/restaurant?restaurantId=123&section=info")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_resetPassword() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/resetPassword?resetToken=123")!
        let target = DeepLink(string: "je-internal://je.com/resetPassword?resetToken=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderHistory1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/orders")!
        let target = DeepLink(string: "je-internal://je.com/orders")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderHistory2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/order-history")!
        let target = DeepLink(string: "je-internal://je.com/orders")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderHistory3() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/account/order-history")!
        let target = DeepLink(string: "je-internal://je.com/orders")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/order?orderId=123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/orders?orderId=123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails3() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/order/123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails4() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/orders/123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails5() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/pages/orderstatus.aspx?orderId=123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetails6() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/account/order/123")!
        let target = DeepLink(string: "je-internal://je.com/order?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_reorder1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/reorder?orderId=123")!
        let target = DeepLink(string: "je-internal://je.com/reorder?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_reorder2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/reorder/123")!
        let target = DeepLink(string: "je-internal://je.com/reorder?orderId=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_updatePassword() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/account/update-password?token=123")!
        let target = DeepLink(string: "je-internal://je.com/resetPassword?resetToken=123")
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertEqual(target, test)
    }
    
    func test_invalid1() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/pretty/much/invalid")!
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertNil(test)
    }
    
    func test_invalid2() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/totally/invalid")!
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertNil(test)
    }
    
    func test_invalid3() {
        let universalLink = UniversalLink(string: "https://just-eat.co.uk/invalid")!
        let test = universalLinkConverter.deepLink(forUniversalLink: universalLink)
        XCTAssertNil(test)
    }
}
