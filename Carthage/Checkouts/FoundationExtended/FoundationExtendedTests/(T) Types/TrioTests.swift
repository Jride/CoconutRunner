//
//  TrioTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 05/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class TrioTests: XCTestCase {
    
    func test_TrioInitialisedWithElements_HoldsCorrectElements() {
        
        let trio = Trio("a", "b", "c")
        XCTAssertEqual(trio.first, "a")
        XCTAssertEqual(trio.second, "b")
        XCTAssertEqual(trio.third, "c")
    }
    
    func test_TrioElementsCanBeMutated() {
        
        var trio = Trio("1", "2", "3")
        
        trio.first = "a"
        XCTAssertEqual(trio, Trio("a", "2", "3"))
        
        trio.second = "b"
        XCTAssertEqual(trio, Trio("a", "b", "3"))
        
        trio.third = "c"
        XCTAssertEqual(trio, Trio("a", "b", "c"))
    }
    
    func test_TrioCanBeMapped() {
        
        let trio = Trio("1", "2", "3")
        XCTAssertEqual(trio.map(Int.init), Trio(1, 2, 3))
    }
    
    // MARK: - Equatable
    
    func test_TrioEquatableConformance() {
        
        XCTAssertEqual(Trio(1, 2, 3), Trio(1, 2, 3))
        XCTAssertNotEqual(Trio(1, 1, 1), Trio(2, 2, 2))
        XCTAssertNotEqual(Trio(1, 2, 3), Trio(3, 2, 1))
    }
}
