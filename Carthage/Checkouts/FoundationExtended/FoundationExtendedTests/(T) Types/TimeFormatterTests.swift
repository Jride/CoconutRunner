//
//  TimeFormatterTests.swift
//  FoundationExtendedTests
//
//  Created by Josh Rideout on 15/02/2019.
//  Copyright © 2019 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class TimeFormatterTests: XCTestCase {
    
    func test_WhenTimeIsSeconds_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: 45)
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:00:45")
    }
    
    func test_WhenTimeIsMinutes_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromMinutes: 23))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:23:00")
    }
    
    func test_WhenTimeIsHours_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromHours: 1))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "01:00:00")
    }
    
    func test_WhenTimeIsMinutesSeconds_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromMinutes: 23, seconds: 52))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:23:52")
    }
    
    func test_WhenTimeIsHoursMinutesSeconds_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromHours: 3, minutes: 23, seconds: 52))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "03:23:52")
    }
    
    func test_WhenTimeIsHoursSeconds_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromHours: 10, minutes: 0, seconds: 49))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "10:00:49")
    }
    
    func test_WhenLargeTimeGiven_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromHours: 999, minutes: 40, seconds: 7))
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "999:40:07")
    }
    
    func test_WhenDecimalValueGiven_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: seconds(fromHours: 3, minutes: 23, seconds: 52) + 0.995434)
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "03:23:52")
    }
    
    func test_WhenZeroValueGiven_TimeIsFormattedCorrectly() {
        let timeFormatter = TimeFormatter(seconds: 0)
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:00:00")
    }
    
    func test_WhenNanValueGiven_TimeFormatterRespondsAccordingly() {
        let timeFormatter = TimeFormatter(seconds: Double.nan)
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:00:00")
    }
    
    func test_WhenInfiniteValueGiven_TimeFormatterRespondsAccordingly() {
        let timeFormatter = TimeFormatter(seconds: Double.infinity)
        XCTAssertEqual(timeFormatter.playerDurationFormat(), "00:00:00")
    }
    
}

extension TimeFormatterTests {
    
    func seconds(fromHours hours: Int, minutes: Int = 0, seconds: Int = 0) -> TimeInterval {
        return Double((hours * 60 * 60) + (minutes * 60) + seconds)
    }
    
    func seconds(fromMinutes minutes: Int, seconds: Int = 0) -> TimeInterval {
        return Double(minutes * 60 + seconds)
    }
}
