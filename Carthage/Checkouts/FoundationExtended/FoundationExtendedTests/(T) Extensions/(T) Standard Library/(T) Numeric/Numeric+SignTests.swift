//
//  Numeric+SignTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 05/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Numeric_SignTests: XCTestCase {
    
    func test_WhenNumericIsPositive_IsPositiveIsTrue() {
        
        XCTAssertFalse((-2).isPositive)
        XCTAssertFalse((-1).isPositive)
        XCTAssertTrue(0.isPositive)
        XCTAssertTrue(1.isPositive)
        XCTAssertTrue(2.isPositive)
    }
    
    func test_WhenNumericIsNegative_IsNegativeIsTrue() {
        
        XCTAssertTrue((-2).isNegative)
        XCTAssertTrue((-1).isNegative)
        XCTAssertFalse(0.isNegative)
        XCTAssertFalse(1.isNegative)
        XCTAssertFalse(2.isNegative)
    }
}
