//
//  Sequence+ZipTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 16/10/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Sequence_ZipTests: XCTestCase {
    
    // MARK: - Zip

    func test_Zip_EmptySequence() {
        
        let array = Array<Int>()
        let result = array.zip { "\($0)" }
        XCTAssertTrue(Array(result).isEmpty)
    }
    
    func test_Zip_SingleValue() {
        
        let array = [4]
        let result = array.zip { "\($0)" }
        let resultAsArray = Array(result)
        
        XCTAssertEqual(resultAsArray.count, 1)
        XCTAssertEqual(resultAsArray[0].0, 4)
        XCTAssertEqual(resultAsArray[0].1, "4")
    }
    
    func test_Zip_MultipleValues() {
        
        let array = [4, 5, 6]
        let result = array.zip { "\($0)" }
        let resultAsArray = Array(result)
        
        XCTAssertEqual(resultAsArray.count, 3)
        
        XCTAssertEqual(resultAsArray[0].0, 4)
        XCTAssertEqual(resultAsArray[0].1, "4")
        
        XCTAssertEqual(resultAsArray[1].0, 5)
        XCTAssertEqual(resultAsArray[1].1, "5")
        
        XCTAssertEqual(resultAsArray[2].0, 6)
        XCTAssertEqual(resultAsArray[2].1, "6")
    }
    
    // MARK: - Compact Zip
    
    func test_CompactZip_EmptyArray() {
                
        let array = Array<String>()
        let result = array.compactZip(with: Int.init)
        XCTAssertTrue(Array(result).isEmpty)
    }
    
    func test_CompactZip_SingleValidValue() {
                
        let array = ["4"]
        let result = array.compactZip(with: Int.init)
        let resultAsArray = Array(result)
        
        XCTAssertEqual(resultAsArray.count, 1)
        
        XCTAssertEqual(resultAsArray[0].0, "4")
        XCTAssertEqual(resultAsArray[0].1, 4)
    }
    
    func test_CompactZip_SingleNilValue() {
        
        let array = ["a"]
        let result = array.compactZip(with: Int.init)
        let resultAsArray = Array(result)
        
        XCTAssertTrue(resultAsArray.isEmpty)
    }
    
    func test_CompactZip_MixedValidAndNilValues() {
                
        let array = ["4", "a", "5", "b"]
        let result = array.compactZip(with: Int.init)
        let resultAsArray = Array(result)
        
        XCTAssertEqual(resultAsArray.count, 2)
        
        XCTAssertEqual(resultAsArray[0].0, "4")
        XCTAssertEqual(resultAsArray[0].1, 4)
        
        XCTAssertEqual(resultAsArray[1].0, "5")
        XCTAssertEqual(resultAsArray[1].1, 5)
    }

}
