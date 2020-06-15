//
//  String+CharacterSetTests.swift
//  FoundationExtendedTests
//
//  Created by Tom O'Rourke on 25/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class String_CharacterSetTests: XCTestCase {
    
    func test_WhenACharacterSetIsReplacedInAString_ThenTheReplacementCharacterIsSeenInsteadOfCharactersInTheCharacterSet() {
        
        let acceptableCharacters = CharacterSet.basicAlphanumeric
        
        let input = "abcdef))--!!ghijki"
        
        let output = input.replacing(charactersInSet: acceptableCharacters.inverted, with: ".")
        
        XCTAssertEqual(output, "abcdef......ghijki")
        
    }
    
}
