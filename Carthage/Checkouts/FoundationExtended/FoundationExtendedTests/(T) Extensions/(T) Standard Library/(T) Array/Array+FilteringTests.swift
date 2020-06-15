//
//  Array+FilteringTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_FilteringTests: XCTestCase {
    
    // MARK: - Removing
    
    func testRemoving() {
        
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array.removing { $0 == 3 }, [1, 2, 4, 5])
    }
    
    // MARK: - Filter in place
    
    func testFilterInPlaceOnEmptyArrayReturnsEmptyArray() {
        
        var array = [Int]()
        array.filterInPlace { $0 == 1 }
        XCTAssertEqual(array, [])
    }
    
    func testFilterInPlaceFiltersArray() {
        
        var array = [1, 2, 3, 4, 5]
        array.filterInPlace { $0 != 3 }
        XCTAssertEqual(array, [1, 2, 4, 5])
    }
}
