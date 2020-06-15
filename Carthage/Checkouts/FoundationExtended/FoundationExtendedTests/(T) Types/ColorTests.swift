//
//  ColorTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 30/05/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class ColorTests: XCTestCase {

    func test_InitialisesWithCorrectValues() {
        let color = Color(r: 0.1, g: 0.2, b: 0.3, a: 0.4)
        
        XCTAssertEqual(color.r, 0.1)
        XCTAssertEqual(color.g, 0.2)
        XCTAssertEqual(color.b, 0.3)
        XCTAssertEqual(color.a, 0.4)
    }
    
    func test_InitialisesWith255Values() {
        let color = Color(r255: 50, g: 100, b: 150, a: 0.5)
        
        XCTAssertEqual(color.r * 255, 50)
        XCTAssertEqual(color.g * 255, 100)
        XCTAssertEqual(color.b * 255, 150)
        XCTAssertEqual(color.a, 0.5)
    }
    
    func test_DarkerToPct() {
        let color = Color(r: 1, g: 1, b: 1).darker(toPct: 0.8)
        
        XCTAssertEqual(color.r, 0.8)
        XCTAssertEqual(color.g, 0.8)
        XCTAssertEqual(color.b, 0.8)
        XCTAssertEqual(color.a, 1)
    }
    
    func test_Equatable() {
        let color1 = Color(r: 0.1, g: 0.2, b: 0.3, a: 0.4)
        let color2 = Color(r: 0.1, g: 0.2, b: 0.3, a: 0.4)
        let color3 = Color(r: 0.2, g: 0.3, b: 0.4, a: 0.5)
        
        XCTAssertTrue(color1 == color2)
        XCTAssertTrue(color1 == color1)
        XCTAssertTrue(color2 == color2)
        XCTAssertTrue(color1 != color3)
        XCTAssertTrue(color2 != color3)
    }
    
}
