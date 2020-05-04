//
//  BoolMatcher.swift
//  RemoteMessaging
//
//  Created by Steve Barnegren on 29/03/2018.
//  Copyright © 2019 ITV. All rights reserved.
//

import Foundation

/// Compares semantic versioning version numbers (eg. 3.5.1)
public class VersionNumberUtils {
    
    public static func areVersionsEqual(_ a: String, _ b: String) -> Bool {
        return numbers(forString: a) == numbers(forString: b)
    }
    
    public static func isVersion(_ a: String, lessThanVersion b: String) -> Bool {
        
        let aNumbers = self.numbers(forString: a)
        let bNumbers = self.numbers(forString: b)
        
        let maxCount = min(aNumbers.count, bNumbers.count)
        var index = 0
        
        while index < maxCount {
            
            let aNumber = aNumbers[index]
            let bNumber = bNumbers[index]
            
            if aNumber < bNumber {
                return true
            } else if aNumber > bNumber {
                return false
            }
            
            index += 1
        }
        
        // If we're here, then the longer number is the greater one
        if aNumbers.count < bNumbers.count {
            return true
        } else {
            return false
        }
    }
    
    public static func isVersion(_ a: String, greaterThanVersion b: String) -> Bool {
        return isVersion(b, lessThanVersion: a)
    }
    
    private static func numbers(forString string: String) -> [Int] {
        var numbers = string.components(separatedBy: ".").compactMap(Int.init)
        
        while numbers.count > 1 && numbers.last == 0 {
            _ = numbers.popLast()
        }
        
        return numbers
    }
    
}
