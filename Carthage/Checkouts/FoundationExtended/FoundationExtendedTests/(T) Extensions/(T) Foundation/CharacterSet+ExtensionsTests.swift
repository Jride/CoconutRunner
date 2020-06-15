//
//  CharacterSet+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 14/08/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class CharacterSet_ExtensionsTests: XCTestCase {
    
    func test_BasicAlphanumericCharacterSet() {
        
        let characterSet = CharacterSet.basicAlphanumeric
        
        // Verify contains lowercase letters
        characterSet.contains("a").verifyTrue()
        characterSet.contains("b").verifyTrue()
        characterSet.contains("c").verifyTrue()
        characterSet.contains("d").verifyTrue()
        characterSet.contains("e").verifyTrue()
        characterSet.contains("f").verifyTrue()
        characterSet.contains("g").verifyTrue()
        characterSet.contains("h").verifyTrue()
        characterSet.contains("i").verifyTrue()
        characterSet.contains("j").verifyTrue()
        characterSet.contains("k").verifyTrue()
        characterSet.contains("l").verifyTrue()
        characterSet.contains("m").verifyTrue()
        characterSet.contains("n").verifyTrue()
        characterSet.contains("o").verifyTrue()
        characterSet.contains("p").verifyTrue()
        characterSet.contains("q").verifyTrue()
        characterSet.contains("r").verifyTrue()
        characterSet.contains("s").verifyTrue()
        characterSet.contains("t").verifyTrue()
        characterSet.contains("u").verifyTrue()
        characterSet.contains("v").verifyTrue()
        characterSet.contains("w").verifyTrue()
        characterSet.contains("x").verifyTrue()
        characterSet.contains("y").verifyTrue()
        characterSet.contains("z").verifyTrue()
        
        // Verify contains uppercase letters
        characterSet.contains("A").verifyTrue()
        characterSet.contains("B").verifyTrue()
        characterSet.contains("C").verifyTrue()
        characterSet.contains("D").verifyTrue()
        characterSet.contains("E").verifyTrue()
        characterSet.contains("F").verifyTrue()
        characterSet.contains("G").verifyTrue()
        characterSet.contains("H").verifyTrue()
        characterSet.contains("I").verifyTrue()
        characterSet.contains("J").verifyTrue()
        characterSet.contains("K").verifyTrue()
        characterSet.contains("L").verifyTrue()
        characterSet.contains("M").verifyTrue()
        characterSet.contains("N").verifyTrue()
        characterSet.contains("O").verifyTrue()
        characterSet.contains("P").verifyTrue()
        characterSet.contains("Q").verifyTrue()
        characterSet.contains("R").verifyTrue()
        characterSet.contains("S").verifyTrue()
        characterSet.contains("T").verifyTrue()
        characterSet.contains("U").verifyTrue()
        characterSet.contains("V").verifyTrue()
        characterSet.contains("W").verifyTrue()
        characterSet.contains("X").verifyTrue()
        characterSet.contains("Y").verifyTrue()
        characterSet.contains("Z").verifyTrue()
        
        // Verify contains numbers
        characterSet.contains("0").verifyTrue()
        characterSet.contains("1").verifyTrue()
        characterSet.contains("2").verifyTrue()
        characterSet.contains("3").verifyTrue()
        characterSet.contains("4").verifyTrue()
        characterSet.contains("5").verifyTrue()
        characterSet.contains("6").verifyTrue()
        characterSet.contains("7").verifyTrue()
        characterSet.contains("8").verifyTrue()
        characterSet.contains("9").verifyTrue()
        
        // Verify doesn't contain special characters
        characterSet.contains("è").verifyFalse()
        characterSet.contains("ü").verifyFalse()
        
        // Verify doesn't contain whitespace
        characterSet.contains(" ").verifyFalse()
        characterSet.contains("\t").verifyFalse()
        characterSet.contains("\n").verifyFalse()

        // Verify doesn't contain symbols
        characterSet.contains("!").verifyFalse()
        characterSet.contains(".").verifyFalse()
        characterSet.contains(",").verifyFalse()
    }
    
    func test_SpaceCharacterSet() {
        
        let characterSet = CharacterSet.space
        
        // Verify contains space
        characterSet.contains(" ").verifyTrue()
        
        // Verify doesn't contain other whitespace
        characterSet.contains("\t").verifyFalse()
        characterSet.contains("\n").verifyFalse()
        
        // Verify doesn't contain characters or numbers
        characterSet.contains("a").verifyFalse()
        characterSet.contains("A").verifyFalse()
        characterSet.contains("z").verifyFalse()
        characterSet.contains("Z").verifyFalse()
        characterSet.contains("0").verifyFalse()
        characterSet.contains("5").verifyFalse()
    }
    
    
}
