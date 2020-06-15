//
//  XCTestCase+CustomAssertions.swift
//  TweenKit
//
//  Created by Steven Barnegren on 24/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import XCTest
@testable import TweenKit

extension XCTestCase {
    
    enum Filter {
        case none
        case onlyMatchingExpectedEventsTypes
        
        func apply(recordedEvents: [EventType],
                   expectedEvents: [EventType]) -> [EventType] {
            
            let expectedEventsAsStrings = expectedEvents.map{ $0.asString() }
            
            switch self {
            case .none:
                return recordedEvents
            case .onlyMatchingExpectedEventsTypes:
                return recordedEvents.filter{ recorded in expectedEventsAsStrings.contains(recorded.asString()) }
            }
        }
    }
    
    func AssertLifeCycleEventsAreAsExpected(recordedEvents: [EventType],
                                            expectedEvents: [EventType],
                                            filter: Filter,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        
        func stringFromEvents(_ events: [EventType]) -> String {
            
            var string = ""
            string += "["
            for event in events {
                string += "\n"
                string += event.asString()
            }
            
            if string != "[" {
                string += "\n"
            }
            
            string += "]"
            return string
        }
        
        // Filter events
        var recordedEvents = recordedEvents
        recordedEvents = filter.apply(recordedEvents: recordedEvents,
                                      expectedEvents: expectedEvents)
        
        // Generate strings for error messages
        let eventsAsString = stringFromEvents(recordedEvents)
        let otherEventsAsString = stringFromEvents(expectedEvents)
        
        // Assert
        XCTAssertEqual(eventsAsString,
                       otherEventsAsString,
                       "\n\nRECORDED EVENTS:\n\n\(eventsAsString)\n\nARE NOT EQUAL TO EXPECTED EVENTS:\n\n\(otherEventsAsString)\n\n",
            file: file,
            line: line)
    }
    
    func AssertCGPointsAreEqualWithAccuracy(_ p1: CGPoint,
                                            _ p2: CGPoint,
                                            accuracy: Double,
                                            file: StaticString = #file,
                                            line: UInt = #line) {
        
        let xDiff = abs(p2.x - p1.x)
        let yDiff = abs(p2.y - p1.y)
        
        let allowedDifference = 0.001
        
        if Double(xDiff) < allowedDifference && Double(yDiff) < allowedDifference {
            return
        }
        
        let message = "(\(p1.x), \(p1.y)) is not equal to (\((p2.x, p2.y))))"
        
        XCTFail(message, file: file, line: line)
    }
    
    func AssertCGSizesAreEqualWithAccuracy(_ s1: CGSize,
                                           _ s2: CGSize,
                                           accuracy: Double,
                                           file: StaticString = #file,
                                           line: UInt = #line) {
        
        let wDiff = abs(s2.width - s1.width)
        let hDiff = abs(s2.height - s1.height)
        
        let allowedDifference = 0.001
        
        if Double(wDiff) < allowedDifference && Double(hDiff) < allowedDifference {
            return
        }
        
        let message = "(\(s1.width), \(s1.height)) is not equal to (\((s2.width, s2.height))))"
        
        XCTFail(message, file: file, line: line)
    }
    
    func AssertCGRectsAreEqualWithAccuracy(_ r1: CGRect,
                                           _ r2: CGRect,
                                           accuracy: Double,
                                           file: StaticString = #file,
                                           line: UInt = #line) {
        
        let xDiff = abs(r2.origin.x - r1.origin.x)
        let yDiff = abs(r2.origin.y - r1.origin.y)
        let wDiff = abs(r2.size.width - r1.size.width)
        let hDiff = abs(r2.size.height - r1.size.height)
        
        let allowedDifference = 0.001
        
        if Double(xDiff) < allowedDifference
            && Double(yDiff) < allowedDifference
            && Double(wDiff) < allowedDifference
            && Double(hDiff) < allowedDifference{
            return
        }
        
        let message = "\(r1) is not equal to \(r2)"
        
        XCTFail(message, file: file, line: line)
    }
    
    
}

