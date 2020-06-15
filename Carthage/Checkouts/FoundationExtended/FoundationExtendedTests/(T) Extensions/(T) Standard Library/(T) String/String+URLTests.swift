//
//  String+URLTests.swift
//  FoundationExtendedTests
//
//  Created by Tom O'Rourke on 09/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import Foundation

class String_URLTests: XCTestCase {

    func test_WhenAStringIsNotEmpty_ThenAValidURLPropertyIsAvailable() {
    
        let link = "link"
    
        XCTAssertNotNil(link.URL)
        XCTAssertEqual(link.URL?.absoluteString, "link")
    }
    
    func test_WhenAStringIsEmpty_ThenAValidURLPropertyIsNotAvailable() {
        
        let link = ""
        
        XCTAssertNil(link.URL)
    }
}
