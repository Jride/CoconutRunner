//
//  Dictionary+PathAccessTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 06/11/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Dictionary_PathAccessTests: XCTestCase {
    
    // MARK: - Success

    func test_AccessNestedObject() {
        
        let dictionary = [
            "this": [
                "is": [
                    "a": "test"
                ]
            ]
        ]
        
        XCTAssertEqual(dictionary.get(path: "this/is/a", as: String.self), "test")
    }
    
    // MARK: - Incorrect Type
    
    func test_AccessNestedObjectOfIncorrectType() {
           
           let dictionary = [
               "this": [
                   "is": [
                       "a": "test"
                   ]
               ]
           ]
           
           XCTAssertNil(dictionary.get(path: "this/is/a", as: Int.self))
       }
    
    func test_AccessNestedObjectThroughIncorrectIntermediateType() {
        
        let dictionary = [
            "this": [
                "is": ["a", "test"]
            ]
        ]
        
        XCTAssertNil(dictionary.get(path: "this/is/a", as: String.self))
    }
    
    // MARK: - Incorrect Paths
    
    func test_IncorrectStartKey() {
        
        let dictionary = [
            "this": [
                "is": [
                    "a": "test"
                ]
            ]
        ]
        
        XCTAssertNil(dictionary.get(path: "xxx/is/a", as: String.self))
    }
    
    func test_IncorrectMiddleKey() {
        
        let dictionary = [
            "this": [
                "is": [
                    "a": "test"
                ]
            ]
        ]
        
        XCTAssertNil(dictionary.get(path: "this/xxx/a", as: String.self))
    }
    
    func test_IncorrectEndKey() {
        
        let dictionary = [
            "this": [
                "is": [
                    "a": "test"
                ]
            ]
        ]
        
        XCTAssertNil(dictionary.get(path: "this/is/xxx", as: String.self))
    }
    
    // MARK: - Empty
    
    func test_EmptyDictionary() {
        
        let dictionary = [String: Any]()
        XCTAssertNil(dictionary.get(path: "some/path", as: String.self))
    }
    
    func test_EmptyPath() {
        
        let dictionary = [
            "this": [
                "is": [
                    "a": "test"
                ]
            ]
        ]
        
        XCTAssertNil(dictionary.get(path: "", as: String.self))
    }
    
    // MARK: - Throwing Access
    
    func test_ThrowingAccessSuccess() throws {
          
          let dictionary = [
              "this": [
                  "is": [
                      "a": "test"
                  ]
              ]
          ]
          
          XCTAssertEqual(try dictionary.getThrowing(path: "this/is/a", as: String.self), "test")
      }
    
    func test_ThrowingAccessFailure() {
        
        let dictionary = [String: Any]()
        
        XCTAssertThrowsError(
            try dictionary.getThrowing(path: "some/path", as: String.self)
        )
    }
}
