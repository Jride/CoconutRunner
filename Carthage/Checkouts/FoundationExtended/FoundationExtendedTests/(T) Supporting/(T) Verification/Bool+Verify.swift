//
//  Bool+Verify.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 14/08/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation
import XCTest

extension Bool {
    
    func verifyTrue(file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(self, file: file, line: line)
    }
    
    func verifyFalse(file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(self, file: file, line: line)
    }
}
