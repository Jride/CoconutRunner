//
//  URL+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 01/11/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class URL_ExtensionsTests: XCTestCase {
    
    func test_InitWithStaticString() {
        XCTAssertEqual(URL(static: "test://a-test-url"),
                       URL(string: "test://a-test-url")!)
    }

    func test_ValueForQueryItem() {
        
        let url = URL(string: "http://unittests.com?someKey=someItem")!
        XCTAssertEqual(url.value(forQueryItem: "someKey"), "someItem")
        XCTAssertNil(url.value(forQueryItem: "someOtherKey"))
    }
    
    func test_IsWebURL_WithValidHTTPWebURL() {
        let url = URL(static: "http://www.test-web-url")
        XCTAssertTrue(url.isWebURL)
    }
    
    func test_IsWebURL_WithValidHTTPSWebURL() {
        let url = URL(static: "https://www.test-web-url")
        XCTAssertTrue(url.isWebURL)
    }
    
    func test_IsWebURL_WithInvalidWebURL() {
        let url = URL(static: "test-string")
        XCTAssertFalse(url.isWebURL)
    }
}
