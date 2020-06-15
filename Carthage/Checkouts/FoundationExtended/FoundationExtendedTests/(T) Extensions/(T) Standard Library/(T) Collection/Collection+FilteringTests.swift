//
//  Collection+FilteringTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Collection_FilteringTests: XCTestCase {
    
    // MARK: - Filter If
    
    func test_WhenTrue_FilterIfFiltersValues() {
        
        let values = ["a", "b", "c"]
        let filteredValues = values.filterIf(true) { $0 != "b" }
        XCTAssertEqual(filteredValues, ["a", "c"])
    }
    
    func test_WhenFalse_FilterIfDoesntFilterValues() {
        
        let values = ["a", "b", "c"]
        let filteredValues = values.filterIf(false) { $0 != "b" }
        XCTAssertEqual(filteredValues, ["a", "b", "c"])
    }
    
}
