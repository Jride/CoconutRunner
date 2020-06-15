//
//  Dictionary+TypeSafeSubscriptTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Dictionary_TypeSafeSubscriptTests: XCTestCase {
    
    func testStringSubscript() {
        
        let dict = ["fruit": "apple"]
        XCTAssertEqual(dict[string: "fruit"], "apple")
        XCTAssertNil(dict[string: "something else"])
    }
    
    func testBoolSubscript() {
        
        let dict = ["value": true]
        XCTAssertEqual(dict[bool: "value"], true)
        XCTAssertNil(dict[bool: "something else"])
    }
    
    // MARK: - Numeric
    
    func testIntSubscript() {
        
        let dict = ["number": 5]
        XCTAssertEqual(dict[int: "number"], 5)
        XCTAssertNil(dict[int: "something else"])
    }
    
    func testFloatSubscript() {
        
        let dict = ["float": Float(5.2)]
        XCTAssertEqual(dict[float: "float"], 5.2)
        XCTAssertNil(dict[float: "unknown key"])
    }
    
    func testDoubleSubscript() {
        
        let dict = ["double": Double(5.2)]
        XCTAssertEqual(dict[double: "double"], 5.2)
        XCTAssertNil(dict[double: "unknown key"])
    }
    
    // MARK: - Dictionary
    
    func testJsonDictSubscript() {
        
        let innerDict = ["a": "b"]
        let dict = ["inner": innerDict]
        XCTAssertNotNil(dict[jsonDictionary: "inner"])
        XCTAssertNil(dict[jsonDictionary: "something else"])
    }
    
    func testJsonDictOrEmptySubscript() {
        
        let innerDict = ["a": "b"]
        let dict = ["inner": innerDict]
        XCTAssertNotNil(dict[jsonDictOrEmpty: "inner"])
        dict[jsonDictOrEmpty: "something else"].isEmpty.verifyTrue()
    }
}
