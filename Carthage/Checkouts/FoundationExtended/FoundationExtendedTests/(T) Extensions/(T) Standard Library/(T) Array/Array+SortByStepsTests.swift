//
//  Array+SortByStepsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

private struct StringAndBool {
    let string: String
    let bool: Bool
}

extension StringAndBool: Equatable {
    static func == (lhs: StringAndBool, rhs: StringAndBool) -> Bool {
        return lhs.string == rhs.string && lhs.bool == rhs.bool
    }
}

class ArraySortingTests: XCTestCase {
    
    // MARK: - Sorted by steps
    
    func testSortByStepsWithNoStepsDoesntChangeItemOrder() {
        
        let array = [2, 3, 1, 5, 4]
        var sortedArray = array
        sortedArray.sortBySteps([])
        XCTAssertEqual(array, sortedArray)
    }
    
    func testSortByStepsOnEmptyArrayReturnsEmptyArray() {
        
        var array = [Int]()
        array.sortBySteps(
            Array.SortStep(ascending: { $0 })
        )
        XCTAssertTrue(array.isEmpty)
    }
    
    func testSortStepAscending() {
        
        var array = [2, 3, 1, 5, 4]
        array.sortBySteps(
            Array.SortStep(ascending: { $0 })
        )
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
    }
    
    func testSortStepAscendingWithIdenticalValues() {
        
        var array = [2, 1, 3, 3, 2, 3]
        array.sortBySteps(
            Array.SortStep(ascending: { $0 })
        )
        XCTAssertEqual(array, [1, 2, 2, 3, 3, 3])
    }
    
    func testSortStepDescending() {
        
        var array = [2, 3, 1, 5, 4]
        array.sortBySteps(
            Array.SortStep(descending: { $0 })
        )
        XCTAssertEqual(array, [5, 4, 3, 2, 1])
    }
    
    func testSortStepDescendingWithIdenticalValues() {
        
        var array = [2, 1, 3, 3, 2, 3]
        array.sortBySteps(
            Array.SortStep(descending: { $0 })
        )
        XCTAssertEqual(array, [3, 3, 3, 2, 2, 1])
    }
    
    func testSortStepWithAscendingDirection() {
        
        let direction = SortStepDirection.ascending
        
        var array = [2, 3, 1, 5, 4]
        array.sortBySteps(
            Array<Int>.SortStep(direction: direction, transform: { $0 })
        )
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
    }
    
    func testSortStepWithDescendingDirection() {
        
        let direction = SortStepDirection.descending
        
        var array = [2, 3, 1, 5, 4]
        array.sortBySteps(
            Array<Int>.SortStep(direction: direction, transform: { $0 })
        )
        XCTAssertEqual(array, [5, 4, 3, 2, 1])
    }
    
    // MARK: - True first
    
    func testSortStepTrueFirstThenString() {
        
        let expected = [
            StringAndBool(string: "a", bool: true),
            StringAndBool(string: "b", bool: true),
            StringAndBool(string: "c", bool: true),
            StringAndBool(string: "a", bool: false),
            StringAndBool(string: "b", bool: false),
            StringAndBool(string: "c", bool: false)
        ]
        
        let results = expected
            .shuffled()
            .sortedBySteps(
                Array.SortStep(trueFirst: { $0.bool }),
                Array.SortStep(ascending: { $0.string })
        )
        
        XCTAssertEqual(results, expected)
    }
    
    func testSortStepStringThenTrueFirst() {
        
        let expected = [
            StringAndBool(string: "a", bool: true),
            StringAndBool(string: "a", bool: false),
            StringAndBool(string: "b", bool: true),
            StringAndBool(string: "b", bool: false),
            StringAndBool(string: "c", bool: true),
            StringAndBool(string: "c", bool: false)
        ]
        
        let results = expected
            .shuffled()
            .sortedBySteps(
                Array.SortStep(ascending: { $0.string }),
                Array.SortStep(trueFirst: { $0.bool })
        )
        
        XCTAssertEqual(results, expected)
    }
    
    // MARK: - False first
    
    func testSortStepFalseFirstThenString() {
        
        let expected = [
            StringAndBool(string: "a", bool: false),
            StringAndBool(string: "b", bool: false),
            StringAndBool(string: "c", bool: false),
            StringAndBool(string: "a", bool: true),
            StringAndBool(string: "b", bool: true),
            StringAndBool(string: "c", bool: true)
        ]
        
        let results = expected
            .shuffled()
            .sortedBySteps(
                Array.SortStep(falseFirst: { $0.bool }),
                Array.SortStep(ascending: { $0.string })
        )
        
        XCTAssertEqual(results, expected)
    }
    
    func testSortStepStringThenFalseFirst() {
        
        let expected = [
            StringAndBool(string: "a", bool: false),
            StringAndBool(string: "a", bool: true),
            StringAndBool(string: "b", bool: false),
            StringAndBool(string: "b", bool: true),
            StringAndBool(string: "c", bool: false),
            StringAndBool(string: "c", bool: true)
        ]
        
        let results = expected
            .shuffled()
            .sortedBySteps(
                Array.SortStep(ascending: { $0.string }),
                Array.SortStep(falseFirst: { $0.bool })
        )
        
        XCTAssertEqual(results, expected)
    }
    
    // MARK: - Multiple steps
    
    func testMultipleSortSteps() {
        
        do {
            var array = ["3b", "1a", "2a", "2b", "1b", "3c", "3a", "1c", "2c"]
            array.sortBySteps(
                Array.SortStep(ascending: { $0[String.Index(utf16Offset: 0, in: $0)]}),
                Array.SortStep(ascending: { $0[String.Index(utf16Offset: 1, in: $0)]})
            )
            XCTAssertEqual(array, ["1a", "1b", "1c", "2a", "2b", "2c", "3a", "3b", "3c"])
        }
        
        do {
            var array = ["3b", "1a", "2a", "2b", "1b", "3c", "3a", "1c", "2c"]
            array.sortBySteps(
                Array.SortStep(ascending: { $0[String.Index(utf16Offset: 0, in: $0)]}),
                Array.SortStep(descending: { $0[String.Index(utf16Offset: 1, in: $0)]})
            )
            XCTAssertEqual(array, ["1c", "1b", "1a", "2c", "2b", "2a", "3c", "3b", "3a"])
        }
        
        do {
            var array = ["3b", "1a", "2a", "2b", "1b", "3c", "3a", "1c", "2c"]
            array.sortBySteps(
                Array.SortStep(descending: { $0[String.Index(utf16Offset: 0, in: $0)]}),
                Array.SortStep(ascending: { $0[String.Index(utf16Offset: 1, in: $0)]})
            )
            XCTAssertEqual(array, ["3a", "3b", "3c", "2a", "2b", "2c", "1a", "1b", "1c"])
        }
    }
    
    // MARK: - First
    
    func test_FirstSortedBySteps_ReturnsNilForEmptyArray() {
        let array = Array<String>()
        let result = array.first(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0 })
            ])
        XCTAssertNil(result)
    }
    
    func test_FirstSortedBySteps_ReturnsFirstSortedValue() {
        
        let array: [String] = ["b", "d", "a", "c"]
        let result = array.first(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0 })
            ])
        XCTAssertEqual(result, "a")
    }
    
    func test_FirstSortedBySteps_ReturnsFirstObjectWhenMultipleHaveSameValue() {
        
        let array = ["b", "a2", "c", "a1"]
        let result = array.first(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0.first! })
            ])
        XCTAssertEqual(result, "a2")
    }
    
    func test_LastSortedBySteps_ReturnsNilForEmptyArray() {
        let array = Array<String>()
        let result = array.last(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0 })
            ])
        XCTAssertNil(result)
    }
    
    func test_LastSortedBySteps_ReturnsLastSortedValue() {
        
        let array: [String] = ["b", "d", "a", "c"]
        let result = array.last(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0 })
            ])
        XCTAssertEqual(result, "d")
    }
    
    func test_LastSortedBySteps_ReturnsLastObjectWhenMultipleHaveSameValue() {
        
        let array: [String] = ["b", "d2", "a", "d1", "c"]
        let result = array.last(sortedBySteps: [
            Array.SortStep<String>(ascending: { $0.first! })
            ])
        XCTAssertEqual(result, "d1")
    }
    
    // MARK: - Insertion
    
    func testInsertWithSortSteps() {
        
        func assert(value: Int,
                    insertedIntoArray array: [Int],
                    producesArray expectedArray: [Int],
                    insertionIndex expectedInsertionIndex: Int,
                    file: StaticString = #file,
                    line: UInt = #line) {
            
            var array = array
            
            let steps: [Array<Int>.SortStep<Int>] = [Array<Int>.SortStep<Int>(ascending: { $0 })]
            let index = array.insert(value, sortSteps: steps)
            XCTAssertEqual(array, expectedArray, file: file, line: line)
            XCTAssertEqual(index, expectedInsertionIndex, file: file, line: line)
        }
        
        // Test empty array
        assert(value: 5, insertedIntoArray: [], producesArray: [5], insertionIndex: 0)
        
        // Test single value
        assert(value: 5, insertedIntoArray: [4], producesArray: [4, 5], insertionIndex: 1)
        assert(value: 5, insertedIntoArray: [6], producesArray: [5, 6], insertionIndex: 0)
        assert(value: 5, insertedIntoArray: [5], producesArray: [5, 5], insertionIndex: 1)

        // Test three values
        assert(value: 5, insertedIntoArray: [6, 7, 8], producesArray: [5, 6, 7, 8], insertionIndex: 0)
        assert(value: 5, insertedIntoArray: [4, 6, 7], producesArray: [4, 5, 6, 7], insertionIndex: 1)
        assert(value: 5, insertedIntoArray: [3, 4, 6], producesArray: [3, 4, 5, 6], insertionIndex: 2)
        assert(value: 5, insertedIntoArray: [2, 3, 4], producesArray: [2, 3, 4, 5], insertionIndex: 3)
        
        // Test four values
        assert(value: 5, insertedIntoArray: [1, 5, 5, 10], producesArray: [1, 5, 5, 5, 10], insertionIndex: 3)
    }
}

