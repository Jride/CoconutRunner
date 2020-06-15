//
//  Array+AccessorsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_AccessorsTests: XCTestCase {
    
    // MARK: - Pop first
    
    func testPopFirstReturnsNilForEmptyArray() {
        
        var array = [Int]()
        XCTAssertNil(array.popFirst())
    }
    
    func testPopFirstRemovesAndReturnsFirstItem() {
        
        var array = [1, 2, 3, 4, 5]
        let first = array.popFirst()
        XCTAssertEqual(array, [2, 3, 4, 5])
        XCTAssertEqual(first, 1)
    }
    
    // MARK: - Test Maybe subscript
    
    func testMaybeSubscriptWithEmptyArray() {
        
        let array = [Int]()
        XCTAssertNil(array[maybe: -1])
        XCTAssertNil(array[maybe: 0])
        XCTAssertNil(array[maybe: 1])
    }
    
    func testMaybeSubscriptWithPopulatedArray() {
        
        let array = ["cat", "dog", "monkey"]
        XCTAssertNil(array[maybe: -1])
        XCTAssertEqual(array[maybe: 0], "cat")
        XCTAssertEqual(array[maybe: 1], "dog")
        XCTAssertEqual(array[maybe: 2], "monkey")
        XCTAssertNil(array[maybe: 3])
    }
}
