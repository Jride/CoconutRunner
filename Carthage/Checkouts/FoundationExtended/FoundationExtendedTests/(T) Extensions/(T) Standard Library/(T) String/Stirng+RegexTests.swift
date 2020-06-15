//
//  Stirng+RegexTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Stirng_RegexTests: XCTestCase {
    
    func testMatchesRegex() {
        
        XCTAssertTrue("test".matches(regex: "test"))
        XCTAssertFalse("test".matches(regex: "no match"))
        
        XCTAssertTrue("test".matches(regex: "^*"))
        XCTAssertTrue("a test".matches(regex: "^*test"))
        XCTAssertTrue("a test".matches(regex: "^*t*"))
        XCTAssertFalse("a test".matches(regex: "^t"))
        XCTAssertFalse("a test".matches(regex: "^test"))
        XCTAssertFalse("a test".matches(regex: "^test*"))
        XCTAssertFalse("a test".matches(regex: "^no match"))
    }
}
