//
//  Array+Chunking.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Array_Chunking: XCTestCase {
    
    // MARK: - Chunk
    
    func testChunkingEmptyArrayReturnsEmptyArray() {
        let array = [Int]()
        XCTAssertEqual(array.chunk(size: 10).count, 0)
    }
    
    func testChunkingArrayReturnsCorrectChunks() throws {
        
        let array = [1, 2, 3, 4, 5, 6]
        
        let twos = array.chunk(size: 2)
        XCTAssertEqual(twos.count, 3)
        XCTAssertEqual(try twos.at(throwing: 0), [1, 2])
        XCTAssertEqual(try twos.at(throwing: 1), [3, 4])
        XCTAssertEqual(try twos.at(throwing: 2), [5, 6])
        
        let threes = array.chunk(size: 3)
        XCTAssertEqual(threes.count, 2)
        XCTAssertEqual(try threes.at(throwing: 0), [1, 2, 3])
        XCTAssertEqual(try threes.at(throwing: 1), [4, 5, 6])
        
        let fours = array.chunk(size: 4)
        XCTAssertEqual(fours.count, 2)
        XCTAssertEqual(try fours.at(throwing: 0), [1, 2, 3, 4])
        XCTAssertEqual(try fours.at(throwing: 1), [5, 6])
        
        let fives = array.chunk(size: 5)
        XCTAssertEqual(fives.count, 2)
        XCTAssertEqual(try fives.at(throwing: 0), [1, 2, 3, 4, 5])
        XCTAssertEqual(try fives.at(throwing: 1), [6])
        
        let sixes = array.chunk(size: 6)
        XCTAssertEqual(sixes.count, 1)
        XCTAssertEqual(try sixes.at(throwing: 0), [1, 2, 3, 4, 5, 6])
    }
    
    // MARK: - Test split at change to
    
    func testSplitAtChangeToSplitsAtChange() {
        
        let input = [1, 1, 1, 2, 2, 3]
        let result = input.split(atChangeTo: { $0 })
        
        XCTAssertEqual(result.count, 3)
        
        if let array0 = result[maybe: 0] {
            XCTAssertEqual(array0, [1, 1, 1])
        } else {
            XCTFail("Expected array 0 to exist")
        }
        
        if let array1 = result[maybe: 1] {
            XCTAssertEqual(array1, [2, 2])
        } else {
            XCTFail("Expected array 1 to exist")
        }
        
        if let array2 = result[maybe: 2] {
            XCTAssertEqual(array2, [3])
        } else {
            XCTFail("Expected array 2 to exist")
        }
    }
    
    func testSplitWithPrefix() {
        
        let input = ["a", "b", "c", "d"]
        
        // Note that, as of Swift 4.0, unfortunately XCTAssertEqual does not work with Arrays of Arrays.
        
        do {
            let result = input.split(prefix: 0)
            let expected = [["a", "b", "c", "d"]]
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
        }
        
        do {
            let result = input.split(prefix: 1)
            let expected = [["a"], ["b", "c", "d"]]
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
            XCTAssertEqual(try result.at(throwing: 1), try expected.at(throwing: 1))
        }
        
        do {
            let result = input.split(prefix: 2)
            let expected = [["a", "b"], ["c", "d"]]
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
            XCTAssertEqual(try result.at(throwing: 1), try expected.at(throwing: 1))
        }
        
        do {
            let result = input.split(prefix: 3)
            let expected = [["a", "b", "c"], ["d"]]
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
            XCTAssertEqual(try result.at(throwing: 1), try expected.at(throwing: 1))
        }
        
        do {
            let result = input.split(prefix: 4)
            let expected = [["a", "b", "c", "d"]]
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
        }
        
        do {
            let result = input.split(prefix: 5)
            let expected = [["a", "b", "c", "d"]]
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(try result.at(throwing: 0), try expected.at(throwing: 0))
        }
    }
    
    func testSplitEmptyArrayWithPrefix() {
        let input: [Int] = []
        let result = input.split(prefix: 1)
        XCTAssertEqual(result.count, 0)
    }
    
}
