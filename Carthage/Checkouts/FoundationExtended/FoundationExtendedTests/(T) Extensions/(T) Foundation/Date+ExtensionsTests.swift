//
//  Date+ExtensionsTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest

class DateExtensionsTests: XCTestCase {
    
    // MARK: - Creation
    
    func testInitWithDayMonthYear() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let datesAndStrings: [(Date, String)] = [
            (Date.init(day: 1, month: 1, year: 2000), "01/01/2000"),
            (Date.init(day: 14, month: 2, year: 1987), "14/02/1987"),
            (Date.init(day: 18, month: 11, year: 2019), "18/11/2019")
        ]
        
        for (date, string) in datesAndStrings {
            XCTAssertEqual(formatter.string(from: date), string)
        }
    }
    
    func testInitWithDayMonthYearHourMinute() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let datesAndStrings: [(Date, String)] = [
            (Date.init(day: 1, month: 1, year: 2000, hour: 1, minute: 15), "01/01/2000 01:15"),
            (Date.init(day: 14, month: 2, year: 1987, hour: 15, minute: 30), "14/02/1987 15:30"),
            (Date.init(day: 18, month: 11, year: 2019, hour: 19, minute: 56), "18/11/2019 19:56")
        ]
        
        for (date, string) in datesAndStrings {
            XCTAssertEqual(formatter.string(from: date), string)
        }
    }
    
    // MARK: - MillisecondsSince1970
    
    func testInitWithMillisecondsSince1970() {
        
        let secondsDate = Date(timeIntervalSince1970: 500)
        let millisecondsDate = Date(millisecondsSince1970: 500000)
        
        XCTAssertEqual(millisecondsDate, secondsDate)
    }
    
    // MARK: - Retriving day / month / year
    
    func testDayComputedProperty() {
        
        let date = Date(day: 5, month: 1, year: 2000)
        XCTAssertEqual(date.day, 5)
    }
    
    func testMonthComputedProperty() {
        
        let date = Date(day: 1, month: 5, year: 2000)
        XCTAssertEqual(date.month, 5)
    }
    
    func testYearComputedProperty() {
        
        let date = Date(day: 1, month: 1, year: 2000)
        XCTAssertEqual(date.year, 2000)
    }
    
    // MARK: - Adding days
    
    func testAddingDays() {
        
        let date = Date(day: 1, month: 1, year: 2000)
        
        guard let newDate = date.adding(days: 3) else {
            XCTFail("Failed to create date")
            return
        }
        
        XCTAssertEqual(newDate.day, 4)
    }
}
