//
//  Character+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 07/09/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Character_ExtensionsTests: XCTestCase {
    
    func test_IsCharacter() {
     
        Character("0").isDigit.verifyTrue()
        Character("1").isDigit.verifyTrue()
        Character("2").isDigit.verifyTrue()
        Character("3").isDigit.verifyTrue()
        Character("4").isDigit.verifyTrue()
        Character("5").isDigit.verifyTrue()
        Character("6").isDigit.verifyTrue()
        Character("7").isDigit.verifyTrue()
        Character("8").isDigit.verifyTrue()
        Character("9").isDigit.verifyTrue()
        
        Character("a").isDigit.verifyFalse()
        Character("A").isDigit.verifyFalse()
        Character(".").isDigit.verifyFalse()
        Character("!").isDigit.verifyFalse()
    }
}
