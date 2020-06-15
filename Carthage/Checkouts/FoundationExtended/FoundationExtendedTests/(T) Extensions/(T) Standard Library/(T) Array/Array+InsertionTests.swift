//
//  Array+InsertionTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class Array_InsertionTests: XCTestCase {
    
    // MARK: - Appending
    
    func testAppendingMethodReturnsArrayWithAppendedItem() {
        
        let array = [1, 2, 3, 4]
        let newArray = array.appending(5)
        XCTAssertEqual(newArray, [1, 2, 3, 4, 5])
    }
    
    // MARK: - Inserting
    
    func test_InsertMaybeMethod_ReturnsExpectedArray() {
        
        var array = [1, 2, 3, 4]
        array.insert(999, safelyAt: 3)
        XCTAssertEqual(array, [1, 2, 3, 999, 4])
    }
    
    func test_InsertMaybeMethodUsingEndIndex_ReturnsExpectedArray() {
        
        var array = [1, 2, 3, 4]
        array.insert(999, safelyAt: array.endIndex)
        XCTAssertEqual(array, [1, 2, 3, 4, 999])
    }
    
    func test_ArraySizeNotBigEnoughToInsertAtIndex_ItemIsNotAddedToArray() {
        
        var array = [1, 2, 3, 4]
        array.insert(999, safelyAt: 5)
        XCTAssertEqual(array, [1, 2, 3, 4])
    }
    
    func test_ArraySizeNotBigEnoughToInsertAtIndex_InsertOrAppendMethodAppends() {
        
        var array = [1, 2, 3, 4]
        array.insertOrAppend(999, at: 8)
        XCTAssertEqual(array, [1, 2, 3, 4, 999])
    }
    
    func test_ArrayCanInsertItemAtIndex_InsertOrAppendMethodInsertsAtCorrectIndex() {
        
        var array = [1, 2, 3, 4]
        array.insertOrAppend(999, at: 2)
        XCTAssertEqual(array, [1, 2, 999, 3, 4])
    }
    
    // MARK: - Subscript
    
    func test_ArraySizeNotBigEnoughToInsertAtIndex_UsingSubscriptItemIsNotAddedToArray() {
        
        var array = [1, 2, 3, 4]
        array[safe: 7] = 999
        XCTAssertEqual(array, [1, 2, 3, 4])
    }
    
    func test_ArrayCanInsertItemAtIndex_UsingSubscriptInsertsAtCorrectIndex() {
        
        var array = [1, 2, 3, 4]
        array[safe: 2] = 999
        XCTAssertEqual(array, [1, 2, 999, 3, 4])
    }
    
    func test_IndexOutOfBounds_ReturnsNilForSafeIndex() {
        
        let array = [1, 2, 3, 4]
        XCTAssertNil(array[safe: 10])
    }
    
    func test_InsertingItemAtEndIndex_ItemIsInsertedAtCorrectIndex() {
        
        var array = [1, 2, 3, 4]
        let endIndex = array.endIndex
        array[safe: endIndex] = 999
        XCTAssertEqual(array, [1, 2, 3, 4, 999])
    }
}
