//
//  StringRepresentable+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Tom O'Rourke on 28/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

enum FirstOrSecond: String, StringRepresentable, Equatable {
    case first
    case second
}

class StringRepresentable_RawRepresentableTests: XCTestCase {
    
    func testStringRepresentableRawRepresentable_HasStringRepresentationEquivalentToItsRawValue() {
        
        XCTAssertEqual(FirstOrSecond(string: "first"), .first)
    }
}
