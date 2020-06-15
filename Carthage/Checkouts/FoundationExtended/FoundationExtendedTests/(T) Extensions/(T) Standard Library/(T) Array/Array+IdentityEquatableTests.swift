//
//  Array+IdentityEquatableTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 27/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import Foundation
import FoundationExtended

class Array_IdentityEquatableTests: XCTestCase {
    
    struct Word: IdentityEquatable {
        
        let id: Int
        let text: String
        
        var equatableId: Int {
            return id
        }
    }
    
    // MARK: - Append or replace
    
    func testReplace() {
        
        var array: [Word] = [
            Word(id: 1, text: "dog"),
            Word(id: 2, text: "cat"),
            Word(id: 3, text: "cow"),
            Word(id: 4, text: "sheep")
        ]
        
        array.appendOrReplace(identityEquatable: Word(id: 2, text: "parrot"))
        XCTAssertEqual(array.map { $0.text }, ["dog", "parrot", "cow", "sheep"])
    }
    
    func testAppend() {
        
        var array: [Word] = [
            Word(id: 1, text: "dog"),
            Word(id: 2, text: "cat"),
            Word(id: 3, text: "cow"),
            Word(id: 4, text: "sheep")
        ]
        
        array.appendOrReplace(identityEquatable: Word(id: 5, text: "parrot"))
        XCTAssertEqual(array.map { $0.text }, ["dog", "cat", "cow", "sheep", "parrot"])
    }
}

