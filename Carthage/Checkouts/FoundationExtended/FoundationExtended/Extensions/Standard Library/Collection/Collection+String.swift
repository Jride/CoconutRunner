//
//  Collection+String.swift
//  FoundationExtended
//
//  Created by Steve Barnegren on 26/06/2018.
//  Copyright © 2018 ITV. All rights reserved.
//

import Foundation

extension Collection where Element == String {
    
    public func containsCaseInsensitive(_ string: String) -> Bool {
        
        return self.contains { (element) -> Bool in
            return element.caseInsensitiveCompare(string) == .orderedSame
        }
    }
}
