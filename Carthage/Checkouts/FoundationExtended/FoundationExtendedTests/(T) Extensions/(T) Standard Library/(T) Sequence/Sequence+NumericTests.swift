//
//  Sequence+NumericTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 30/05/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Sequence_NumericTests: XCTestCase {
    
    // MARK: - Sum
    
    func test_SumOnEmptyArray() {
        XCTAssertEqual(Array<Int>().sum(), 0)
    }
    
    func test_SumOnArrayWithSingleValue() {
        XCTAssertEqual([5].sum(), 5)
    }
    
    func test_SumOnArrayWithMultipleValues() {
        XCTAssertEqual([5, 10, 3].sum(), 18)
    }
}
