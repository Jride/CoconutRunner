//
//  FloatingPoint+InterpolationTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 20/11/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class FloatingPoint_InterpolationTests: XCTestCase {

    let accuracy = 0.01
    
    func test_PosititveInterpolation() {
        XCTAssertEqual(Double(5).interpolated(to: 10, t: 0), 5, accuracy: accuracy)
        XCTAssertEqual(Double(5).interpolated(to: 10, t: 0.2), 6, accuracy: accuracy)
        XCTAssertEqual(Double(5).interpolated(to: 10, t: 1), 10, accuracy: accuracy)
    }
    
    func test_NegativeInterpolation() {
        XCTAssertEqual(Double(10).interpolated(to: 5, t: 0), 10, accuracy: accuracy)
        XCTAssertEqual(Double(10).interpolated(to: 5, t: 0.2), 9, accuracy: accuracy)
        XCTAssertEqual(Double(10).interpolated(to: 5, t: 1), 5, accuracy: accuracy)
    }
    
    func test_InterpolationToSameValue() {
        XCTAssertEqual(Double(5).interpolated(to: 5, t: 0), 5, accuracy: accuracy)
        XCTAssertEqual(Double(5).interpolated(to: 5, t: 0.2), 5, accuracy: accuracy)
        XCTAssertEqual(Double(5).interpolated(to: 5, t: 1), 5, accuracy: accuracy)
    }
}
