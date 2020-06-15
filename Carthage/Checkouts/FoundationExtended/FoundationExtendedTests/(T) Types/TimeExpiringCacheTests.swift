//
//  TimeExpiringCacheTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class TimeExpiringCacheTests: XCTestCase {
    
    func testReturnsNilBeforeValueIsSet() {
        
        let cache = TimeExpiringCache<Double>(duration: 10, getCurrentTime: { 0.0 })
        XCTAssertNil(cache.value)
    }
    
    func testReturnsValueDuringCacheDuration() {
        
        let cache = TimeExpiringCache<String>(duration: 10, getCurrentTime: { 0.0 })
        cache.value = "test"
        XCTAssertEqual(cache.value, "test")
    }
    
    func testReturnsNilAfterCacheDuration() {
        
        var time = CFTimeInterval(0)
        let cache = TimeExpiringCache<String>(duration: 10, getCurrentTime: { time })
        cache.value = "test"
        
        time += 9
        XCTAssertEqual(cache.value, "test")
        time += 2
        XCTAssertNil(cache.value)
    }
}
