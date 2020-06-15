//
//  BinaryInteger+ParityTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 03/07/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class BinaryInteger_ParityTests: XCTestCase {
    
    func testArrayOfEvenIntegers() {
        
        let evenNumbers = [2, 4, 6, 8, 10, 12, 14]
        evenNumbers.forEach {
            XCTAssert($0.isEven)
        }
        
    }
    
    func testArrayOfOddIntegers() {
        
        let oddNumbers = [1, 3, 5, 7, 9, 11, 13]
        oddNumbers.forEach {
            XCTAssert($0.isOdd)
        }
    }
    
    func testRangeOfIntegers() {
        
        var assertValue = false
        for i in 1...100 {
            XCTAssertEqual(i.isEven, assertValue)
            assertValue = !assertValue
        }
        
    }
    
}
