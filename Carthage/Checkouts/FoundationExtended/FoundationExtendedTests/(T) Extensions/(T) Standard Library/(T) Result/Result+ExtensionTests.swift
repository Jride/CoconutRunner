//
//  Result+ExtensionTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 25/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Result_ExtensionTests: XCTestCase {
    
    enum UnitTestError: Error {
        case failed
    }
    
    var result: Result<Bool, Error>!

    func test_WhenResultFails_IsSuccessIsFalse() {
        
        result = .failure(UnitTestError.failed)
        result.isSuccess.verifyFalse()
    }
    
    func test_WhenResultSuccess_IsSuccessIsTrue() {
        
        result = .success(true)
        result.isSuccess.verifyTrue()
    }
    
    func test_WhenResultFails_ErrorPropertyIsSet() throws {
        
        result = .failure(UnitTestError.failed)
        result.isSuccess.verifyFalse()
        XCTAssertEqual(try (result.error as? UnitTestError).unwrapThrowing(), UnitTestError.failed)
    }
}
