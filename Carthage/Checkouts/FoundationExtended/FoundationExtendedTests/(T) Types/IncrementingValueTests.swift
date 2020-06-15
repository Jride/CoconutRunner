//
//  IncrementingValueTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 03/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class IncrementingValueTests: XCTestCase {
    
    func test_IncrementingValue() {
        
        let value = IncrementingValue(initialValue: 0) { $0 + 1 }
        XCTAssertEqual(value.current, 0)
        
        XCTAssertEqual(value.next(), 0)
        XCTAssertEqual(value.current, 0)
        
        XCTAssertEqual(value.next(), 1)
        XCTAssertEqual(value.current, 1)
        
        XCTAssertEqual(value.next(), 2)
        XCTAssertEqual(value.current, 2)
    }
}
