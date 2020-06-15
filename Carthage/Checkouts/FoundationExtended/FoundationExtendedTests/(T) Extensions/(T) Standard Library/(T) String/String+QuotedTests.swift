//
//  String+QuotedTests.swift
//  FoundationExtendedTests
//
//  Created by Tom O'Rourke on 25/09/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class String_QuotedTests: XCTestCase {
    
    func test_WhenAStringsQuotedPropertyIsAccessed_ThenTheStringIsReturnedWrappedInDoubleQuotes() {
        
        let str = "abcde"
        
        XCTAssertEqual(str.quoted, "\"abcde\"")
        
    }
    
}
