//
//  TimeTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class TimeTests: XCTestCase {
    
    func testHoursToHours() {
        let time = Time(hours: 1)
        XCTAssertEqual(time.hours, 1)
    }
    
    func testDaysToSeconds() {
        let time = Time(days: 1)
        XCTAssertEqual(time.seconds, 86400)
    }
    
    func testDaysToMinutes() {
        let time = Time(days: 1)
        XCTAssertEqual(time.minutes, 1440)
    }
    
    func testDaysToHours() {
        let time = Time(days: 1)
        XCTAssertEqual(time.hours, 24)
    }
    
    func testHoursToSeconds() {
        let time = Time(hours: 1)
        XCTAssertEqual(time.seconds, 3600)
    }
    
    func testHoursToMinutes() {
        let time = Time(hours: 1)
        XCTAssertEqual(time.minutes, 60)
    }
    
    func testSecondsToSeconds() {
        let time = Time(seconds: 60)
        XCTAssertEqual(time.seconds, 60)
    }
    
    func testSecondsToHours() {
        let time = Time(seconds: 3600)
        XCTAssertEqual(time.hours, 1)
    }
    
    func testSecondsToMinutes() {
        let time = Time(seconds: 60)
        XCTAssertEqual(time.minutes, 1)
    }
    
    func testMinutesToMinutes() {
        let time = Time(minutes: 1)
        XCTAssertEqual(time.minutes, 1)
    }
    
    func testMinutesToSeconds() {
        let time = Time(minutes: 1)
        XCTAssertEqual(time.seconds, 60)
    }
}
