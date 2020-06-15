//
//  Sequence+Counting.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Sequence_Counting: XCTestCase {
    
    // MARK: - Count where
    
    func testCountWhere() {
        
        let array = ["a", "b", "b", "b", "c", "d"]
        let count = array.count(where: { $0 == "b" })
        XCTAssert(count == 3)
    }
}
