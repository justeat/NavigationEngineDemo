//
//  URLGatewayTests.swift
//  NavigationEngineTests
//
//  Created by Alberto De Bortoli on 07/02/2019.
//

import XCTest
@testable import NavigationEngineDemo

class URLGatewayTests: XCTestCase {
    
    private let timeout = 3.0
    private var urlGateway: URLGateway!
    
    func test_universalLink() {
        let expectation = self.expectation(description: #function)
        urlGateway = URLGateway(settings: MockDeepLinkingSettings())
        let url = URL(string: "https://just-eat.co.uk/login")!
        urlGateway.handleURL(url).finally { future in
            XCTAssertTrue(future.hasResult())
            let target = DeepLink(string: "je-internal://je.com/login")
            let test = future.result!
            XCTAssertEqual(test, target)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_universalLink_invalid() {
        let expectation = self.expectation(description: #function)
        urlGateway = URLGateway(settings: MockDeepLinkingSettings())
        let url = URL(string: "https://just-eat.co.uk/invalid")!
        urlGateway.handleURL(url).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, URLGateway.domain)
            XCTAssertEqual(error.code, URLGateway.ErrorCode.unsupportedUniversalLink.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_deepLink() {
        let expectation = self.expectation(description: #function)
        urlGateway = URLGateway(settings: MockDeepLinkingSettings())
        let url = DeepLink(string: "je-internal://je.com/login")!
        urlGateway.handleURL(url).finally { future in
            XCTAssertTrue(future.hasResult())
            let target = DeepLink(string: "je-internal://je.com/login")
            let test = future.result!
            XCTAssertEqual(test, target)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_deepLinkInvalid() {
        let expectation = self.expectation(description: #function)
        urlGateway = URLGateway(settings: MockDeepLinkingSettings())
        let url = DeepLink(string: "je-internal://je.com/invalid")!
        urlGateway.handleURL(url).finally { future in
            XCTAssertTrue(future.hasResult())
            let target = DeepLink(string: "je-internal://je.com/invalid")
            let test = future.result!
            XCTAssertEqual(test, target)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_invalidLink() {
        let expectation = self.expectation(description: #function)
        urlGateway = URLGateway(settings: MockDeepLinkingSettings())
        let url = URL(string: "someotherscheme://je.com/login")!
        urlGateway.handleURL(url).finally { future in
            XCTAssertTrue(future.hasError())
            let error = future.error! as NSError
            XCTAssertEqual(error.domain, URLGateway.domain)
            XCTAssertEqual(error.code, URLGateway.ErrorCode.generic.rawValue)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}
