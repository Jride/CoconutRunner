//
//  Dictionary+AccessorsWithDefaultsTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 26/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Dictionary_AccessorsWithDefaultsTests: XCTestCase {

    func test_WhenAccessingInvalidStringValue_DefaultValueIsReturned() {
        
        let dict = ["baz": "somevalue"]
        XCTAssertNil(dict[string: "foo"])
        XCTAssertEqual(dict.string(forKey: "foo", default: "bar"), "bar")
    }
    
    func test_WhenAccessingValidStringValue_DefaultIsNotUsed() {
        
        let dict = ["foo": "somevalue"]
        XCTAssertEqual(dict.string(forKey: "foo", default: "bar"), "somevalue")
    }
    
    func test_WhenAccessingInvalidIntValue_DefaultValueIsReturned() {
        
        let dict = ["baz": 1]
        XCTAssertNil(dict[int: "foo"])
        XCTAssertEqual(dict.int(forKey: "foo", default: 2), 2)
    }
    
    func test_WhenAccessingValidIntValue_DefaultIsNotUsed() {
        
        let dict = ["foo": 4]
        XCTAssertEqual(dict.int(forKey: "foo", default: 2), 4)
    }
    
    func test_WhenAccessingInvalidBoolValue_DefaultValueIsReturned() {
        
        let dict = ["baz": false]
        XCTAssertNil(dict[int: "foo"])
        XCTAssertEqual(dict.bool(forKey: "foo", default: true), true)
    }
    
    func test_WhenAccessingValidBoolValue_DefaultIsNotUsed() {
        
        let dict = ["foo": false]
        XCTAssertEqual(dict.bool(forKey: "foo", default: true), false)
    }
    
    func test_WhenAccessingInvalidJsonDictValue_DefaultValueIsReturned() throws {
        
        let defaultJsonDict: [String: Int] = [
            "key1": 1,
            "key2": 2,
            "key3": 3
        ]
        
        let dict = ["baz": 2]
        
        let result = try (dict.jsonDictionary(forKey: "foo", default: defaultJsonDict) as? [String: Int]).assertUnwrap()
        
        XCTAssertEqual(result, defaultJsonDict)
    }
    
    func test_WhenAccessingValidJsonDictValue_DefaultIsNotUsed() throws {
        
        let defaultJsonDict: [String: Int] = [
            "key1": 1,
            "key2": 2,
            "key3": 3
        ]
        
        let jsonDict: [String: Int] = [
            "key1": 5,
            "key2": 4,
            "key3": 3
        ]
        
        let dict: [String: Any] = ["foo": jsonDict]
        
        let result = try (dict.jsonDictionary(forKey: "foo", default: defaultJsonDict) as? [String: Int]).assertUnwrap()
        
        XCTAssertEqual(result, jsonDict)
    }
    
    func test_WhenAccessingInvalidArrayStringsValue_DefaultValueIsReturned() {
        
        let defaultArray = ["foo", "bar", "baz"]
        
        let dict = ["baz": false]
        XCTAssertNil(dict[int: "foo"])
        XCTAssertEqual(dict.arrayOfStrings(forKey: "foo", default: defaultArray), defaultArray)
    }
    
    func test_WhenAccessingValidArrayStringsValue_DefaultIsNotUsed() {
        
        let defaultArray = ["foo", "bar", "baz"]
        
        let array = ["foo", "baz", "bar", "new value"]
        
        let dict: [String: Any] = ["foo": array]
        XCTAssertNil(dict[int: "foo"])
        XCTAssertEqual(dict.arrayOfStrings(forKey: "foo", default: defaultArray), array)
    }

}
