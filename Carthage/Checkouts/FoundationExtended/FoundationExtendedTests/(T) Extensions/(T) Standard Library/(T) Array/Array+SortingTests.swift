//
//  Array+SortingTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_SortingTests: XCTestCase {
    
    // MARK: - Test Sorted Ascending / Descending
    
    func testSortedAscendingSortsAscending() {
        
        let array = [5, 2, 3, 1, 4]
        XCTAssertEqual(array.sortedAscending(), [1, 2, 3, 4, 5])
    }
    
    func testSortedDescendingSortsDescending() {
        
        let array = [5, 2, 3, 1, 4]
        XCTAssertEqual(array.sortedDescending(), [5, 4, 3, 2, 1])
    }
    
    func testSortAscendingSortsAscending() {
        
        var array = [5, 2, 3, 1, 4]
        array.sortAscending()
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
    }
    
    func testSortDescendingSortsDescending() {
        
        var array = [5, 2, 3, 1, 4]
        array.sortDescending()
        XCTAssertEqual(array, [5, 4, 3, 2, 1])
    }
    
    // MARK: - Test insert sort
    
    func testInsertSortedAscendingBy() {
        
        func assert(value: Int,
                    insertedIntoArray array: [Int],
                    producesArray expectedArray: [Int],
                    insertionIndex expectedInsertionIndex: Int,
                    file: StaticString = #file,
                    line: UInt = #line) {
            
            var array = array
            
            let index = array.insert(value, sortedAscendingBy: { $0 })
            XCTAssertEqual(array, expectedArray, file: file, line: line)
            XCTAssertEqual(index, expectedInsertionIndex, file: file, line: line)
        }
        
        // Test empty array
        assert(value: 5, insertedIntoArray: [], producesArray: [5], insertionIndex: 0)
        
        // Test single value
        assert(value: 5, insertedIntoArray: [4], producesArray: [4, 5], insertionIndex: 1)
        assert(value: 5, insertedIntoArray: [6], producesArray: [5, 6], insertionIndex: 0)
        assert(value: 5, insertedIntoArray: [5], producesArray: [5, 5], insertionIndex: 1)
        
        // Test three values
        assert(value: 5, insertedIntoArray: [6, 7, 8], producesArray: [5, 6, 7, 8], insertionIndex: 0)
        assert(value: 5, insertedIntoArray: [4, 6, 7], producesArray: [4, 5, 6, 7], insertionIndex: 1)
        assert(value: 5, insertedIntoArray: [3, 4, 6], producesArray: [3, 4, 5, 6], insertionIndex: 2)
        assert(value: 5, insertedIntoArray: [2, 3, 4], producesArray: [2, 3, 4, 5], insertionIndex: 3)
        
        // Test four values
        assert(value: 5, insertedIntoArray: [1, 5, 5, 10], producesArray: [1, 5, 5, 5, 10], insertionIndex: 3)
    }
    
    func testInsertSortedDescendingBy() {
        
        func assert(value: Int,
                    insertedIntoArray array: [Int],
                    producesArray expectedArray: [Int],
                    insertionIndex expectedInsertionIndex: Int,
                    file: StaticString = #file,
                    line: UInt = #line) {
            
            var array = array
            
            let index = array.insert(value, sortedDescendingBy: { $0 })
            XCTAssertEqual(array, expectedArray, file: file, line: line)
            XCTAssertEqual(index, expectedInsertionIndex, file: file, line: line)
        }
        
        // Test empty array
        assert(value: 5, insertedIntoArray: [], producesArray: [5], insertionIndex: 0)
        
        // Test single value
        assert(value: 5, insertedIntoArray: [4], producesArray: [5, 4], insertionIndex: 0)
        assert(value: 5, insertedIntoArray: [6], producesArray: [6, 5], insertionIndex: 1)
        assert(value: 5, insertedIntoArray: [5], producesArray: [5, 5], insertionIndex: 1)
        
        // Test three values
        assert(value: 8, insertedIntoArray: [7, 6, 5], producesArray: [8, 7, 6, 5], insertionIndex: 0)
        assert(value: 7, insertedIntoArray: [7, 6, 5], producesArray: [7, 7, 6, 5], insertionIndex: 1)
        assert(value: 6, insertedIntoArray: [7, 6, 5], producesArray: [7, 6, 6, 5], insertionIndex: 2)
        assert(value: 5, insertedIntoArray: [7, 6, 5], producesArray: [7, 6, 5, 5], insertionIndex: 3)
        assert(value: 4, insertedIntoArray: [7, 6, 5], producesArray: [7, 6, 5, 4], insertionIndex: 3)
    }
    
    // MARK: - test Sorted Ascending / Descending by key
    
    struct IntWrapper {
        let value: Int
        
        static func == (lhs: IntWrapper, rhs: IntWrapper) -> Bool {
            return lhs.value == rhs.value
        }
    }
    
    func testSortedAscendingByKeySortsAscending() {
        
        let array = [IntWrapper(value: 5),
                     IntWrapper(value: 2),
                     IntWrapper(value: 3),
                     IntWrapper(value: 1),
                     IntWrapper(value: 4)]
        
        XCTAssertEqual(array.sortedAscendingBy { $0.value }.map {  $0.value }, [1, 2, 3, 4, 5])
    }
    
    func testSortedDescendingByKeySortsDescending() {
        
        let array = [IntWrapper(value: 5),
                     IntWrapper(value: 2),
                     IntWrapper(value: 3),
                     IntWrapper(value: 1),
                     IntWrapper(value: 4)]
        
        XCTAssertEqual(array.sortedDescendingBy { $0.value }.map { $0.value }, [5, 4, 3, 2, 1])
    }
    
    func testSortAscendingByKeySortsAscending() {
        
        var array = [IntWrapper(value: 5),
                     IntWrapper(value: 2),
                     IntWrapper(value: 3),
                     IntWrapper(value: 1),
                     IntWrapper(value: 4)]
        array.sortAscendingBy { $0.value }
        XCTAssertEqual(array.map { $0.value }, [1, 2, 3, 4, 5])
    }
    
    func testSortDescendingByKeySortsDescending() {
        
        var array = [IntWrapper(value: 5),
                     IntWrapper(value: 2),
                     IntWrapper(value: 3),
                     IntWrapper(value: 1),
                     IntWrapper(value: 4)]
        array.sortDescendingBy { $0.value }
        XCTAssertEqual(array.map { $0.value }, [5, 4, 3, 2, 1])
    }
    
    // MARK: - Bring to front
    
    func testBringToFrontMovesSingleItemToFront() {
        
        var array = ["a", "b", "c", "d"]
        array.bringToFront { $0 == "c" }
        XCTAssertEqual(array, ["c", "a", "b", "d"])
    }
    
    func testBringToFrontLeavesAlreadyFrontItemAtFront() {
        
        var array = ["a", "b", "c", "d"]
        array.bringToFront { $0 == "a" }
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
    
    func testBringToFrontBringsMultipleItemsToFront() {
        
        var array = ["a", "b", "c", "d", "c"]
        array.bringToFront { $0 == "c" }
        XCTAssertEqual(array, ["c", "c", "a", "b", "d"])
    }
    
    func testBringToFrontMaintainsItemsOrder() {
        
        var array = ["a", "b", "c1", "c2", "d", "c3"]
        array.bringToFront { $0.contains("c") }
        XCTAssertEqual(array, ["c1", "c2", "c3", "a", "b", "d"])
    }
    
    // MARK: - Send to back
    
    func testSendToBackMovesSingleItemToBack() {
        
        var array = ["a", "b", "c", "d"]
        array.sendToBack { $0 == "c" }
        XCTAssertEqual(array, ["a", "b", "d", "c"])
    }
    
    func testSendToBackLeavesAlreadyLastItemAtBack() {
        
        var array = ["a", "b", "c", "d"]
        array.sendToBack { $0 == "d" }
        XCTAssertEqual(array, ["a", "b", "c", "d"])
    }
    
    func testSendToBackSendsMultipleItemsToBack() {
        
        var array = ["a", "b", "a", "c", "d"]
        array.sendToBack { $0 == "a" }
        XCTAssertEqual(array, ["b", "c", "d", "a", "a"])
    }
    
    func testSendToBackMaintainsItemsOrder() {
        
        var array = ["a", "b", "c1", "c2", "d", "c3"]
        array.sendToBack { $0.contains("c") }
        XCTAssertEqual(array, ["a", "b", "d", "c1", "c2", "c3"])
    }
}
