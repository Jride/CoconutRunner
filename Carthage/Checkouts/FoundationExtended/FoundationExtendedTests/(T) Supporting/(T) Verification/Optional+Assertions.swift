//
//  Optional+Assertions.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 26/06/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import Foundation

extension Optional {
    
    enum OptionalError: Error {
        case optionalIsNil
    }
    
    func assertUnwrap(_ message: String = "Optional was nil", file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        
        switch self {
        case .none:
            XCTFail(message, file: file, line: line)
            throw OptionalError.optionalIsNil
        case .some(let value):
            return value
        }
    }
}
