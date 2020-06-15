//
//  Collection+IndicesTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class Collection_IndicesTests: XCTestCase {
    
    // MARK: - Last Index
    
    func test_WhenCollectionIsPopulated_LastIndexReturnsLastIndex() {
        
        let array = ["a", "b", "c"]
        XCTAssertEqual(array.lastIndex, 2)
    }
    
    func test_WhenCollectionIsEmpty_LastIndexReturnsNil() {
        
        let array = [String]()
        XCTAssertNil(array.lastIndex)
    }
}
