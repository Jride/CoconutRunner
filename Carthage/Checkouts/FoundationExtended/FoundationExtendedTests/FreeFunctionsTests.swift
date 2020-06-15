//
//  FreeFunctionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class FreeFunctionsTests: XCTestCase {
    
    // MARK: - Repeated
    
    func testRepeatedFunctionRunsHandlerZeroTimes() {
        
        var timesRun = 0
        
        repeated(times: 0) {
            timesRun += 1
        }
        
        XCTAssertEqual(timesRun, 0)
    }
    
    func testRepeatedFunctionRunsHandlerOnce() {
        
        var timesRun = 0
        
        repeated(times: 1) {
            timesRun += 1
        }
        
        XCTAssertEqual(timesRun, 1)
    }
    
    func testRepeatedFunctionRunsHandlerMultipleTimes() {
        
        var timesRun = 0
        
        repeated(times: 10) {
            timesRun += 1
        }
        
        XCTAssertEqual(timesRun, 10)
    }
}
