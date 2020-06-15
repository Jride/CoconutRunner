//
//  Collection+DatesTests.swift
//  FoundationExtendedTests
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import XCTest
import FoundationExtended

class Collection_DatesTests: XCTestCase {
    
    func testLatestDate() {
        
        let date1 = Date(day: 1, month: 1, year: 2000)
        let date2 = Date(day: 2, month: 1, year: 2000)
        let date3 = Date(day: 3, month: 1, year: 2000)
        let date4 = Date(day: 4, month: 1, year: 2000)
        let date5 = Date(day: 5, month: 1, year: 2000)
        let date6 = Date(day: 6, month: 1, year: 2000)
        let date7 = Date(day: 7, month: 1, year: 2000)
        let date8 = Date(day: 8, month: 1, year: 2000)
        let date9 = Date(day: 9, month: 1, year: 2000)
        let date10 = Date(day: 10, month: 1, year: 2000)
        
        let jumbledDatesWithDuplicates = [
            date2, date10, date3, date1, date1, date5, date10, date8, date4, date7,
            date3, date9, date1, date2, date5, date8, date3, date10, date10, date8,
            date4, date6, date6, date6, date5, date2, date3, date3, date9, date2
        ]
        let latestDate1 = jumbledDatesWithDuplicates.latestDate
        XCTAssert(latestDate1 == date10)
        
        let setOfDates: Set<Date> = Set(jumbledDatesWithDuplicates)
        let latestDate2 = setOfDates.latestDate
        XCTAssert(latestDate2 == date10)
        
        let orderedDatesNoDuplicates = [date1, date2, date3, date4, date5]
        let latestDate3 = orderedDatesNoDuplicates.latestDate
        XCTAssert(latestDate3 == date5)
        
        let reverseOrderedDatesNoDuplicates = [date5, date4, date3, date2, date1]
        let latestDate4 = reverseOrderedDatesNoDuplicates.latestDate
        XCTAssert(latestDate4 == date5)
        
        let jumbledDatesNoDuplicates = [date3, date5, date2, date1, date4]
        let latestDate5 = jumbledDatesNoDuplicates.latestDate
        XCTAssert(latestDate5 == date5)
    }
    
}
