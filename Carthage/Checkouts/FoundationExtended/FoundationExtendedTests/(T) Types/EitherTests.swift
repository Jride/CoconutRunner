//
//  EitherTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 13/08/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class EitherTests: XCTestCase {
    
    func testEquatable() {
        
        let uniqueInstances: [Either<Int, String>] = [
        .left(0),
        .left(1),
        .right("a"),
        .right("b")
        ]
        
        for (leftIndex, left) in uniqueInstances.enumerated() {
            for (rightIndex, right) in uniqueInstances.enumerated() {
                if leftIndex == rightIndex {
                    XCTAssertEqual(left, right)
                } else {
                    XCTAssertNotEqual(left, right)
                }
            }
        }
    }

    // MARK: - Replace
    
    func test_WhenReplacingLeftValue_LeftValueIsReplaced() {
        
        var either = Either<String, Void>.left("a")
        either.replaceLeft("b")
        
        switch either {
        case .left(let value):
            XCTAssertEqual(value, "b")
        case .right:
            XCTFail("Expected left value")
        }
    }
    
    func test_WhenReplacingRightValue_RightValueIsReplaced() {
        
        var either = Either<Void, String>.right("a")
        either.replaceRight("b")
        
        switch either {
        case .left:
            XCTFail("Expected right value")
        case .right(let value):
            XCTAssertEqual(value, "b")
        }
    }
    
    // MARK: - Mutate
    
    func test_WhenContainingLeftValue_MutateLeftMutatesLeftValue() {
        
        var either = Either<String, Void>.left("abc")
        either.mutateLeft { $0.append("d") }
        
        switch either {
        case .left(let value):
            XCTAssertEqual(value, "abcd")
        case .right:
            XCTFail("Expected left value")
        }
    }
    
    func test_WhenContainingRightValue_MutateRightMutatesRightValue() {
        
        var either = Either<Void, String>.right("abc")
        either.mutateRight { $0.append("d") }
        
        switch either {
        case .left:
            XCTFail("Expected right value")
        case .right(let value):
            XCTAssertEqual(value, "abcd")
        }
    }
    
    // MARK: - Map
    
    func test_Map() {
        
        let lowercase: (String) -> String = { $0.lowercased() }
        
        XCTAssertEqual(
            Either<Int, String>.left(2).map(String.init, lowercase),
            "2"
        )
        
        XCTAssertEqual(
            Either<Int, String>.right("HELLO").map(String.init, lowercase),
            "hello"
        )
    }
}
