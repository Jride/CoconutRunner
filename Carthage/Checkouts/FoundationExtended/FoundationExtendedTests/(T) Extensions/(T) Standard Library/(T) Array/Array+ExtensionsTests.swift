//
//  Array+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class Array_ExtensionsTests: XCTestCase {
    
    // MARK: - Flattened
    
    func testFlattened() {
        
        let array: [Int?] = [0, 1, nil, 2, nil]
        XCTAssertEqual(array.flattened(), [0, 1, 2])
    }
}
