//
//  Optional+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class Optional_ExtensionsTests: XCTestCase {
    
    // MARK: - Nil Or False Tests
    
    func testTrueBoolShouldNotBeNilOrFalse() {
        
        let bool: Bool? = true
        XCTAssertEqual(bool.isNilOrFalse, false)
    }
    
    func testFalseBoolShouldBeNilOrFalse() {  
        
        let bool: Bool? = false
        XCTAssertEqual(bool.isNilOrFalse, true)
    }
    
    func testNilBoolShouldBeNilOrFalse() {
        
        let bool: Bool? = nil
        XCTAssertEqual(bool.isNilOrFalse, true)
    }
    
    // MARK: - Is True Tests
    
    func testNilBoolShouldBeFalse() {
        
        let bool: Bool? = nil
        XCTAssertEqual(bool.isTrue, false)
    }
    
    func testFalseBoolShouldBeFalse() {
        
        let bool: Bool? = false
        XCTAssertEqual(bool.isTrue, false)
    }
    
    func testTrueBoolShouldBeTrue() {
        
        let bool: Bool? = true
        XCTAssertEqual(bool.isTrue, true)
    }
    
    // MARK: - Unwrap Throwing
    
    func testUnwrapThrowing() {
        
        let some = Optional.some(5)
        
        do {
            let unwrapped = try some.unwrapThrowing()
            XCTAssertEqual(unwrapped, 5)
        } catch {
            XCTFail("Populated optional should not throw")
        }
        
        let none: Int?  = nil
        
        do {
            _ = try none.unwrapThrowing()
            XCTFail("Nil optional should throw")
        } catch {}
    }
    
    // MARK: - Pipe
    
    func test_Pipe() {
        
        var storeStringWasCalled = false
        var storedString: String?
        
        func storeString(string: String) {
            storeStringWasCalled = true
            storedString = string
        }
        
        let nilString: String? = nil
        nilString.pipe(maybe: storeString)
        XCTAssertFalse(storeStringWasCalled)
        XCTAssertNil(storedString)
        
        let string: String? = "test"
        string.pipe(maybe: storeString)
        XCTAssertTrue(storeStringWasCalled)
        XCTAssertEqual(storedString, "test")
    }
}
