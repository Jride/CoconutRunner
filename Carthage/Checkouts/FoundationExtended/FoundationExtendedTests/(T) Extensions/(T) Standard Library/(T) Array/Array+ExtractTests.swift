//
//  Array+ExtractTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_ExtractTests: XCTestCase {
    
    // MARK: - Extract
    
    func testExtractOnEmptyArrayDoesntRunClosure() {
        
        var closureCalled = false
        
        var array = [Int]()
        let extracted = array.extract {
            closureCalled = true
            return $0 == 100
        }
        XCTAssertTrue(extracted.isEmpty)
        XCTAssertFalse(closureCalled)
    }
    
    func testExtractOnArrayWithNoMatchingValuesReturnsEmptyArray() {
        
        var array = ["cow", "sheep", "pig"]
        let extracted = array.extract { $0 == "moose" }
        XCTAssertEqual(array, ["cow", "sheep", "pig"])
        XCTAssertTrue(extracted.isEmpty)
    }
    
    func testExtractReturnsAndRemovesSingleMatchingValue() {
        
        var array = [1, 2, 3, 4, 5]
        let extracted = array.extract { $0 == 3 }
        XCTAssertEqual(array, [1, 2, 4, 5])
        XCTAssertEqual(extracted, [3])
    }
    
    func testExtractReturnsAndRemovesMultipleMatchingValues() {
        
        var array = ["dog", "cat", "duck", "dog", "cow"]
        let extracted = array.extract { $0 == "dog" }
        XCTAssertEqual(array, ["cat", "duck", "cow"])
        XCTAssertEqual(extracted, ["dog", "dog"])
    }
    
    // MARK: - Extract First
    
    func testExtractFirstOnEmptyArrayDoesntRunClosure() {
        
        var closureCalled = false
        
        var array = [Int]()
        let item = array.extractFirst {
            closureCalled = true
            return $0 == 100
        }
        XCTAssertNil(item)
        XCTAssertFalse(closureCalled)
    }
    
    func testExtractFirstOnArrayWithNoMatchingValuesReturnsNil() {
        
        var array = ["cow", "sheep", "pig"]
        let item = array.extractFirst { $0 == "moose" }
        XCTAssertEqual(array, ["cow", "sheep", "pig"])
        XCTAssertNil(item)
    }
    
    func testExtractFirstReturnsAndRemovesSingleMatchingValue() {
        
        var array = [1, 2, 3, 4, 5]
        let item = array.extractFirst { $0 == 3 }
        XCTAssertEqual(array, [1, 2, 4, 5])
        XCTAssertEqual(item, 3)
    }
    
    func testExtractFirstReturnsFirstItemFromMultipleMatchingValues() {
        
        var array = ["sheep", "dog", "cat", "duck", "dog", "cow"]
        let item = array.extractFirst { $0 == "dog" }
        XCTAssertEqual(array, ["sheep", "cat", "duck", "dog", "cow"])
        XCTAssertEqual(item, "dog")
    }
    
    // MARK: - Extract first compacted
    
    func testExtractFirstCompactedExtractsFirstItem() {
        
        var array = ["a", "b", "3", "c", "d"]
        let extracted = array.extractFirstCompacted(transform: Int.init)
        XCTAssertEqual(extracted, 3)
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
    
    func testExtractFirstCompactedReturnsNilIfNoMatchingItems() {
        
        var array = ["a", "b", "c", "d"]
        let extracted = array.extractFirstCompacted(transform: Int.init)
        XCTAssertNil(extracted)
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
    
    func testExtractFirstCompactedReturnsNilForEmptyArray() {
        
        var array = [String]()
        let extracted = array.extractFirstCompacted(transform: Int.init)
        XCTAssertNil(extracted)
        XCTAssertEqual(array, [])
    }
    
    // MARK: - Extract first compacted (multiple)
    
    func testExtractFirstCompactedMultipleExtractsFirstItems() {
        
        var array = ["a", "b", "3", "c", "d", "4", "e", "f", "5"]
        let extracted = array.extractFirstCompacted(2, transform: Int.init)
        XCTAssertEqual(extracted, [3, 4])
        XCTAssertEqual(array, ["a", "b", "c", "d", "e", "f", "5"])
    }
    
    func testExtractFirstCompactedMultipleExtractsFewerItemsIfNotEnoughMatches() {
        
        var array = ["a", "b", "3", "c", "d", "4", "e", "f", "5"]
        let extracted = array.extractFirstCompacted(99, transform: Int.init)
        XCTAssertEqual(extracted, [3, 4, 5])
        XCTAssertEqual(array, ["a", "b", "c", "d", "e", "f"])
    }
    
    func testExtractFirstMultipleReturnsEmptyArrayIfNoMatchingItems() {
        
        var array = ["a", "b", "c", "d", "e", "f"]
        let extracted = array.extractFirstCompacted(99, transform: Int.init)
        XCTAssertEqual(extracted, [])
        XCTAssertEqual(array, ["a", "b", "c", "d", "e", "f"])
    }
    
}
