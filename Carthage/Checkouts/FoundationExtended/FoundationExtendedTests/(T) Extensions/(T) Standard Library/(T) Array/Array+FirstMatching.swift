//
//  Array+FirstMatching.swift
//  FoundationExtendedTests
//
//  Created by Andrew Brown on 17/01/2020.
//  Copyright © 2020 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_FirstMatching: XCTestCase {
    
    func testFirstMatchingReturnsSingleValue() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array.first(number: 1) { $0 == 1 }, [1])
    }
    
    func testFirstMatchingReturnsMatchingValues() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array.first(number: 3) { $0 < 4 }, [1, 2, 3])
    }
    
    func testFirstMatchingWithNotEnoughValues() {
        let array = [1, 2]
        XCTAssertEqual(array.first(number: 4) { $0 < 4 }, [1, 2])
    }
    
    func testFirstMatchingWithNoMatchingValuesReturnsEmpty() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array.first(number: 3) { $0 > 5 }, [])
    }
    
    func testFirstMatchingWithMultipleMatchesReturnsThemAll() {
        let array = [1, 2, 3, 3, 4, 5]
        XCTAssertEqual(array.first(number: 2) { $0 == 3 }, [3, 3])
    }
    
    func testFirstMatchingWithEmptyArrayDoesntRunClosure() {
        var closureCalled = false
        
        let array = [Int]()
        let newArray = array.first(number: 3) {
            closureCalled = true
            return $0 > 4
        }
        XCTAssertTrue(newArray.isEmpty)
        XCTAssertFalse(closureCalled)
    }
}
