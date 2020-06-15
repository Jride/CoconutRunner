//
//  SignedNumeric+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class SignedNumeric_ExtensionsTests: XCTestCase {
    
    func testAbs() {
        XCTAssertEqual(32.abs, 32)
        XCTAssertEqual((-32).abs, 32)
    }
    
    func testAbsDistance() {
        XCTAssertEqual(10.absDistance(to: 12), 2)
        XCTAssertEqual(10.absDistance(to: 4), 6)
        XCTAssertEqual(10.absDistance(to: 10), 0)
        XCTAssertEqual(10.absDistance(to: -5), 15)
        XCTAssertEqual((-2).absDistance(to: 10), 12)
        XCTAssertEqual((-3).absDistance(to: -5), 2)
    }
}
