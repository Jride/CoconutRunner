//
//  Date+Extensions.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 25/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

public extension Date {
    
    static var now: Date {
        return Date()
    }
    
    /** Constructs Date from day / month / year. Note that first index is 1, not 0 */
    init(day: Int, month: Int, year: Int, hour: Int? = nil, minute: Int? = nil) {
        
        let calendar = Date.getCurrentCalendar()
        
        var components = DateComponents()
        components.calendar = calendar
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
        
        self = calendar.date(from: components)!
    }
    
    init(millisecondsSince1970 milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds / 1000)
    }
    
    // MARK: - Adding days
    
    func adding(days: Int) -> Date? {
        
        let calendar = Date.getCurrentCalendar()
        return calendar.date(byAdding: .day, value: days, to: self)
    }
    
    func subtracting(days: Int) -> Date? {
        
        return adding(days: -days)
    }
    
    // MARK: - Get day / month / year
    
    var day: Int {
        let calendar = Date.getCurrentCalendar()
        return calendar.component(.day, from: self)
    }
    
    var month: Int {
        let calendar = Date.getCurrentCalendar()
        return calendar.component(.month, from: self)
    }
    
    var year: Int {
        let calendar = Date.getCurrentCalendar()
        return calendar.component(.year, from: self)
    }
    
    // MARK: - Helpers
    
    private static func getCurrentCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }
}
