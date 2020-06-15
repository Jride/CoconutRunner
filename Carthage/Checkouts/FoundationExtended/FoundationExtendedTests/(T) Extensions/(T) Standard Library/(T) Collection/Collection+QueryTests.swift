//
//  Collection+Query.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Collection_Query: XCTestCase {
    
    // MARK: - isAscending
    
    func test_WhenCollectionIsAscending_IsAscendingIsTrue() {
        XCTAssertTrue([1, 2, 3, 4, 5].isAscending)
        XCTAssertTrue([1, 2].isAscending)
        XCTAssertTrue([-40, 100, 9999].isAscending)
    }
    
    func test_WhenCollectionIsNotAscending_IsAscendingIsFalse() {
        XCTAssertFalse([5, 4, 3, 2, 1].isAscending)
        XCTAssertFalse([2, 1].isAscending)
        XCTAssertFalse([9999, 100, -40].isAscending)
    }
    
    func test_WhenAscendingCollectionContainsDuplicateValues_IsAscendingIsTrue() {
        XCTAssertTrue([1, 2, 3, 3, 3, 3, 3, 4, 5].isAscending)
    }
    
    func test_WhenAscendingCollectionIsEmpty_IsAscendingIsTrue() {
        XCTAssertTrue([Int]().isAscending)
    }
    
    // MARK: - isDescending
    
    func test_WhenCollectionIsDescending_IsDescendingIsTrue() {
        XCTAssertTrue([5, 4, 3, 2, 1].isDescending)
        XCTAssertTrue([2, 1].isDescending)
        XCTAssertTrue([9999, 100, -40].isDescending)
    }
    
    func test_WhenCollectionIsNotDescending_IsDescendingIsFalse() {
        XCTAssertFalse([1, 2, 3, 4, 5].isDescending)
        XCTAssertFalse([1, 2].isDescending)
        XCTAssertFalse([-40, 100, 9999].isDescending)
    }
    
    func test_WhenDescendingCollectionContainsDuplicateValues_IsDescendingIsTrue() {
        XCTAssertTrue([5, 4, 3, 3, 3, 3, 3, 2, 1].isDescending)
    }
    
    func test_WhenDescendingCollectionIsEmpty_IsDescendingIsTrue() {
        XCTAssertTrue([Int]().isDescending)
    }
}
