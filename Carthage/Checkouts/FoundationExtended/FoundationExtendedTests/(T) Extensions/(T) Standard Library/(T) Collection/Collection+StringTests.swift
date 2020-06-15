//
//  Collection+StringTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Collection_StringTests: XCTestCase {
    
    func testContainsCaseInsensitive() {
        
        let monkey = "monkey"
        
        XCTAssertFalse(["dog", "cat", "bird"].containsCaseInsensitive(monkey))
        XCTAssertFalse([String]().containsCaseInsensitive(monkey))
        XCTAssertFalse(["mon key"].containsCaseInsensitive(monkey))
        XCTAssertFalse(["monkey "].containsCaseInsensitive(monkey))
        XCTAssertFalse([" monkey"].containsCaseInsensitive(monkey))
        
        XCTAssertTrue(["dog", "monkey", "bird"].containsCaseInsensitive(monkey))
        XCTAssertTrue(["dog", "Monkey", "bird"].containsCaseInsensitive(monkey))
        XCTAssertTrue(["dog", "MoNKey", "bird"].containsCaseInsensitive(monkey))
    }
}
