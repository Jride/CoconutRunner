//
//  Sequence+SumTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 31/05/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest

class Sequence_SumTests: XCTestCase {
    
    struct IntWrapper {
        let value: Int
    }
    
    func test_SumOf_ReturnsZeroForEmptyArray() {
        let array: [IntWrapper] = []
        let result = array.sum(of: { $0.value })
        XCTAssertEqual(result, 0)
    }
    
    func test_SumOf_ReturnsValueForArrayWithSingleValue() {
        let array = [IntWrapper(value: 5)]
        let result = array.sum(of: { $0.value })
        XCTAssertEqual(result, 5)
    }
    
    func test_SumOf_ReturnsAumForArrayWithMultipleValues() {
        let array = [IntWrapper(value: 5), IntWrapper(value: 7), IntWrapper(value: 2)]
        let result = array.sum(of: { $0.value })
        XCTAssertEqual(result, 14)
    }
    
    func test_sumOf_WithKeyPath() {
        let array = [IntWrapper(value: 5), IntWrapper(value: 7), IntWrapper(value: 2)]
        let result = array.sum(\.value)
        XCTAssertEqual(result, 14)
    }
}
