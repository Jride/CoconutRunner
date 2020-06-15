//
//  VersionNumberUtilsTests.swift
//  RemoteMessagingTests
//
//  Created by Steve Barnegren on 29/03/2018.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class VersionNumberUtilsTests: XCTestCase {
    
    func testAreVersionEqual() {
        
        XCTAssertTrue( VersionNumberUtils.areVersionsEqual("0", "0") )
        XCTAssertTrue( VersionNumberUtils.areVersionsEqual("0", "0.0") )
        XCTAssertTrue( VersionNumberUtils.areVersionsEqual("0.1", "0.1") )
        XCTAssertTrue( VersionNumberUtils.areVersionsEqual("0.1", "0.1.0.0") )
        XCTAssertTrue( VersionNumberUtils.areVersionsEqual("6.78.901", "6.78.901") )
        
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("0", "1") )
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("0", "0.1") )
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("0", "0.0.0.1") )
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("0.1", "0.0.1") )
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("6.78.901", "6.78.903") )
        XCTAssertFalse( VersionNumberUtils.areVersionsEqual("11.2.11", "11.2.11.11") )
    }
    
    func testVersionNumberIsLessThan() {
        
        // < 1
        XCTAssertTrue( VersionNumberUtils.isVersion("0", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0.0", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0.0.0", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.5", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.999", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.9.10000", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.9", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.9.0.8000", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.10", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.10.10.10", lessThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.99999.999999.99999.9999", lessThanVersion: "1") )
        
        // >= 1
        XCTAssertFalse( VersionNumberUtils.isVersion("1", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0.0", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.1", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.5.8.9", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("3", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("3.9", lessThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("999.0.0.0", lessThanVersion: "1") )

        // < 1.0
        XCTAssertTrue( VersionNumberUtils.isVersion("0", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0.0", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.0.0.0", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.5", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.999", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.1.9.10000", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.9", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.9.0.8000", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.10", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.10.10.10", lessThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("0.99999.999999.99999.9999", lessThanVersion: "1.0") )
        
        // >= 1.0
        XCTAssertFalse( VersionNumberUtils.isVersion("1", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0.0", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.1", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.5.8.9", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("3", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("3.9", lessThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("999.0.0.0", lessThanVersion: "1.0") )
        
        // < 7.1.2
        XCTAssertTrue( VersionNumberUtils.isVersion("0", lessThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("6.9.9", lessThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("6.9.9.11", lessThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7", lessThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.0.10.10", lessThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.1", lessThanVersion: "7.1.2") )

        // >= 7.1.2
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2.0.0.0", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2.0", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.3", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.3.0", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.2.4", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.3", lessThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("8", lessThanVersion: "7.1.2") )
    }
    
    func testVersionNumberIsGreaterThan() {
        
        // <= 1
        XCTAssertFalse( VersionNumberUtils.isVersion("0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0.0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0.0.0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.5", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.999", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.9.10000", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.9", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.9.0.8000", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.10", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.10.10.10", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.99999.999999.99999.9999", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0", greaterThanVersion: "1") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0.0", greaterThanVersion: "1") )
        
        // > 1
        XCTAssertTrue( VersionNumberUtils.isVersion("1.1", greaterThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("1.5.8.9", greaterThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("3", greaterThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("3.9", greaterThanVersion: "1") )
        XCTAssertTrue( VersionNumberUtils.isVersion("999.0.0.0", greaterThanVersion: "1") )
        
        // <= 1.0
        XCTAssertFalse( VersionNumberUtils.isVersion("0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0.0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.0.0.0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.5", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.999", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.1.9.10000", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.9", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.9.0.8000", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.10", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.10.10.10", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("0.99999.999999.99999.9999", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0", greaterThanVersion: "1.0") )
        XCTAssertFalse( VersionNumberUtils.isVersion("1.0.0.0", greaterThanVersion: "1.0") )
        
        // > 1.0
        XCTAssertTrue( VersionNumberUtils.isVersion("1.1", greaterThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("1.5.8.9", greaterThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("3", greaterThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("3.9", greaterThanVersion: "1.0") )
        XCTAssertTrue( VersionNumberUtils.isVersion("999.0.0.0", greaterThanVersion: "1.0") )
        
        // <= 7.1.2
        XCTAssertFalse( VersionNumberUtils.isVersion("0", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("6.9.9", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("6.9.9.11", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.0.10.10", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2.0", greaterThanVersion: "7.1.2") )
        XCTAssertFalse( VersionNumberUtils.isVersion("7.1.2.0.0.0", greaterThanVersion: "7.1.2") )
        
        // > 7.1.2
        XCTAssertTrue( VersionNumberUtils.isVersion("7.1.2.1", greaterThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.1.3", greaterThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.1.3.0", greaterThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.2.4", greaterThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("7.3", greaterThanVersion: "7.1.2") )
        XCTAssertTrue( VersionNumberUtils.isVersion("8", greaterThanVersion: "7.1.2") )
    }
    
}
