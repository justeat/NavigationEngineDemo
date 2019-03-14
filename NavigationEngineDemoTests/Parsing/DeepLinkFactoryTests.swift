//
//  DeepLinkFactoryTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
import CoreLocation
@testable import NavigationEngineDemo

class DeepLinkFactoryTests: XCTestCase {
    
    private let scheme = "justeat"
    private let host = "je.com"
    
    private var deepLinkFactory: DeepLinkFactory!
    
    override func setUp() {
        super.setUp()
        deepLinkFactory = DeepLinkFactory(scheme: scheme, host: host)
    }
    
    func test_homeUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/home")!
        let test = deepLinkFactory.homeURL()
        XCTAssertEqual(target, test)
    }
    
    func test_loginUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/login")!
        let test = deepLinkFactory.loginURL()
        XCTAssertEqual(target, test)
    }
    
    func test_updatePasswordUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/resetPassword?resetToken=qwerty")!
        let test = deepLinkFactory.updatePasswordURL(token: "qwerty")
        XCTAssertEqual(target, test)
    }
    
    func test_serpSearchUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/search")!
        let test = deepLinkFactory.searchURL(postcode: nil, cuisine: nil, location: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_serpSearchUrlWithPostcode() {
        let target = DeepLink(string: "\(scheme)://\(host)/search?postcode=EC4M7RF")!
        let test = deepLinkFactory.searchURL(postcode: "EC4M7RF", cuisine: nil, location: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_serpSearchUrlWithPostcodeAndLocation() {
        let target = DeepLink(string: "\(scheme)://\(host)/search?postcode=EC4M7RF&lat=45.951342&long=12.497958")!
        let test = deepLinkFactory.searchURL(postcode: "EC4M7RF", cuisine: nil, location: CLLocationCoordinate2D(latitude: 45.951342, longitude: 12.497958))
        XCTAssertEqual(target, test)
    }
    
    func test_serpSearchUrlWithPostcodeAndCuisine() {
        let target = DeepLink(string: "\(scheme)://\(host)/search?postcode=EC4M7RF&cuisine=italian")!
        let test = deepLinkFactory.searchURL(postcode: "EC4M7RF", cuisine: "italian", location: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_serpSearchUrlWithPostcodeAndCuisineAndLocation() {
        let target = DeepLink(string: "\(scheme)://\(host)/search?postcode=EC4M7RF&cuisine=italian&lat=45.951342&long=12.497958")!
        let test = deepLinkFactory.searchURL(postcode: "EC4M7RF", cuisine: "italian", location: CLLocationCoordinate2D(latitude: 45.951342, longitude: 12.497958))
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: nil, serviceType: nil, section: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrlWithPostcode() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123&postcode=EC4M7RF")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: "EC4M7RF", serviceType: nil, section: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrlWithPostcodeAndServiceType() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: "EC4M7RF", serviceType: .delivery, section: nil)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrlWithPostcodeAndServiceTypeAndMenuSection() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery&section=menu")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: "EC4M7RF", serviceType: .delivery, section: .menu)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrlWithPostcodeAndServiceTypeAndReviewsSection() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery&section=reviews")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: "EC4M7RF", serviceType: .delivery, section: .reviews)
        XCTAssertEqual(target, test)
    }
    
    func test_restaurantUrlWithPostcodeAndServiceTypeAndInfoSection() {
        let target = DeepLink(string: "\(scheme)://\(host)/restaurant?restaurantId=123&postcode=EC4M7RF&serviceType=delivery&section=info")!
        let test = deepLinkFactory.restaurantURL(restaurantId: "123", postcode: "EC4M7RF", serviceType: .delivery, section: .info)
        XCTAssertEqual(target, test)
    }
    
    func test_orderHistoryUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/orders")!
        let test = deepLinkFactory.orderHistoryURL()
        XCTAssertEqual(target, test)
    }
    
    func test_orderDetailsUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/order?orderId=123")!
        let test = deepLinkFactory.orderDetailsURL(orderId: "123")
        XCTAssertEqual(target, test)
    }
    
    func test_reorderUrl() {
        let target = DeepLink(string: "\(scheme)://\(host)/reorder?orderId=123")!
        let test = deepLinkFactory.reorderURL(orderId: "123")
        XCTAssertEqual(target, test)
    }
}
